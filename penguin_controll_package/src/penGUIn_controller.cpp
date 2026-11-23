#include "rclcpp/rclcpp.hpp"
#include "penguin_interface_package/msg/single.hpp"
#include "std_msgs/msg/int32.hpp"
#include <string>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/prctl.h>
#include <signal.h>
#include <unistd.h>
#include <vector>
#include <chrono>

#include <cerrno>
#include <csignal>
#include <unordered_map>

using namespace std::placeholders;
using namespace std::chrono_literals;

class PenGUInController : public rclcpp::Node {
    public:
        PenGUInController() : Node("penguin_controller") {
            // Launch a usual commandline program
            launch_single_subscriber = this->create_subscription<penguin_interface_package::msg::Single>(
                "penGUIn/start_single",
                10,
                std::bind(&PenGUInController::launchSingleProgramCallBack, this, std::placeholders::_1)
            );
            // Stop a usual commandline program
            stop_single_subscriber = this->create_subscription<penguin_interface_package::msg::Single>(
                "penGUIn/stop_single",
                10,
                std::bind(&PenGUInController::stopSingleProgramCallback, this, std::placeholders::_1)
            );
            RCLCPP_INFO(this->get_logger(), "All subscribers have been started");
        }
    private:
        using Clock = std::chrono::steady_clock;

        // Possible stages of each process
        enum class Stage {
            running,
            stopping_process,
            running_stop_process,
            stopping_stop_process
        };

        // Information about each child process
        struct ProcInfo {
            pid_t pid{-1};
            Stage stage{Stage::running};
            std::string custom_stop_cmd;
            Clock::time_point deadline{};
            bool sigkill_sent{false};
            rclcpp::TimerBase::SharedPtr timer;
        };

        // Callback for launching a new cmd program
        void launchSingleProgramCallBack(const penguin_interface_package::msg::Single::SharedPtr msg) {
            std::string cmd = msg ->cmd;
            int id = msg->id;
            RCLCPP_WARN(this->get_logger(), "Id: %i", id);

            // Return if the command is empty
            if (msg->cmd.empty()) {
                RCLCPP_WARN(this->get_logger(), "ERROR: Unprocessable command");
                return;
            }

            // Return if a prozess with the same id already exists
            if (procs_.find(msg->id) != procs_.end()) {
                RCLCPP_WARN(this->get_logger(), "Prozess with id '%i' already running", id);
                return;
            }

            // Launch a new child process
            const pid_t pid = launchProcess(msg->id, msg->cmd);
            if (pid < 0) {
                return;
            }

            // Store the pid of that process
            procs_.emplace(msg->id, ProcInfo{});
            procs_.at(msg->id).pid = pid;

            // Update the information of this process
            procs_.at(msg->id).stage = Stage::running;

            RCLCPP_INFO(get_logger(), "Started id=%d pid=%d", msg->id, pid);
        }

        // Launch a new child process
        pid_t launchProcess(int id, const std::string &cmd) {
            const pid_t parent_pid = getpid();
            const pid_t pid = fork();

            // Return if the pid is invalid
            if (pid < 0) {
                RCLCPP_ERROR(get_logger(), "Fork failed for id=%d", id);
                return -1;
            }

            // Move on if pid is fine
            if (pid == 0) {
                // Make sure all prozesses stop after this node being stopped
                prctl(PR_SET_PDEATHSIG, SIGTERM);

                // Stop this child process if the parent terminates within fork() & prctl()
                if (getppid() != parent_pid) {
                    _exit(1);
                }

                // Apply a certain process group
                setpgid(0, 0);

                // Launch this process
                char *const argv[] = {const_cast<char *>("bash"), const_cast<char *>("-lc"), const_cast<char *>(cmd.c_str()), nullptr};
                execv("/bin/bash", argv);
                _exit(127);
            }

            // Return and apply the parent group
            setpgid(pid, pid);
            return pid;
        }

        // Callback for stopping a cmd program
        void stopSingleProgramCallback(const penguin_interface_package::msg::Single::SharedPtr msg) {
            // Check whether there's such a process
            auto it = procs_.find(msg->id);
            if (it == procs_.end()) {
                RCLCPP_WARN(get_logger(), "No registered process for id=%d", msg->id);
                return;
            }

            // Return if this process is already about to be canceled
            ProcInfo &proc = it->second;
            if (proc.stage != Stage::running) {
                RCLCPP_WARN(get_logger(), "A stop sequence is already active for id=%d", msg->id);
                return;
            }

            // Terminate this process
            proc.custom_stop_cmd = msg->cmd;
            proc.stage = Stage::stopping_process;
            beginTermination(msg->id, proc);

            // Create a timer, which is shared over the whole termination process
            proc.timer = create_wall_timer(100ms, [this, id = msg->id]() {
                processStateMachine(id);
            });
        }

        // Try to terminate via SIGTERM
        void beginTermination(int id, ProcInfo &proc) {
            // Send SIGTERM (Strg+C) first
            RCLCPP_INFO(get_logger(), "Sending SIGTERM for id=%d pid=%d", id, proc.pid);
            if (kill(-proc.pid, SIGTERM) < 0 && errno != ESRCH) {
                RCLCPP_ERROR(get_logger(), "SIGTERM failed for id=%d pid=%d: %s", id, proc.pid, strerror(errno));
            }

            // Update the ProcInfo of this certain process
            proc.deadline = Clock::now() + 5s;
            proc.sigkill_sent = false;
        }

        // Track the current stage of the process and handle it
        void processStateMachine(int id) {
            // Check whether the given id is within _procs
            auto it = procs_.find(id);
            if (it == procs_.end()) {
                return;
            }

            // Get the ProcInfo of this process
            ProcInfo &proc = it->second;

            // Handle each state a process migth have
            switch (proc.stage) {
                // If it's running move on
                case Stage::running:
                    break;
                // If it's about to be terminated
                case Stage::stopping_process:
                    // If the process finished, move on
                    if (reapIfFinished(id, proc)) {
                        // Return if there's no command, that's supposed to be launched
                        if (proc.custom_stop_cmd.empty()) {
                            finishSequence(id);
                            return;
                        }

                        // Launch the given cancel command
                        const pid_t custom_pid = launchProcess(id, proc.custom_stop_cmd);
                        if (custom_pid < 0) {
                            finishSequence(id);
                            return;
                        }

                        // Reset the ProcInfo for this process
                        proc.pid = custom_pid;
                        proc.stage = Stage::running_stop_process;
                        proc.deadline = Clock::now() + 10s;
                        proc.sigkill_sent = false;

                        RCLCPP_INFO(get_logger(), "Started a cancel command for id=%d pid=%d", id, custom_pid);
                        return;
                    }

                    // Otherwise kill the process
                    sendSigkillIfDue(id, proc);
                    break;
                // If a cancel command is run, clean everything up
                case Stage::running_stop_process:
                    // Check whether the process already terminated
                    if (reapIfFinished(id, proc)) {
                        finishSequence(id);
                        return;
                    }

                    // Terminate the process after a while
                    if (Clock::now() >= proc.deadline) {
                        proc.stage = Stage::stopping_stop_process;
                        beginTermination(id, proc);
                    }
                    break;
                // If the cancel command was asked to terminate, enforce it does so
                case Stage::stopping_stop_process:
                    // Check whether the process already terminated
                    if (reapIfFinished(id, proc)) {
                        finishSequence(id);
                        return;
                    }

                    // Kill the process
                    sendSigkillIfDue(id, proc);
                    break;
            }
        }

        // Check whether a certain process alread stopped or not
        bool reapIfFinished(int id, ProcInfo &proc) {
            int status = 0;
            const pid_t result = waitpid(proc.pid, &status, WNOHANG);

            // Return failed, if the process is still running
            if (result == 0) {
                return false;
            }

            // Return succes, if the process exited successfully
            if (result == proc.pid) {
                if (WIFEXITED(status)) {
                    RCLCPP_INFO(get_logger(), "Child for id=%d exited with status %d", id, WEXITSTATUS(status));
                } else if (WIFSIGNALED(status)) {
                    RCLCPP_INFO(get_logger(), "Child for id=%d was terminated by signal %d", id, WTERMSIG(status));
                }
                return true;
            }

            // Handle upcoming errors
            if (result < 0) {
                // Something interrupted this call
                if (errno == EINTR) {
                    return false;
                }

                // Return success, if the child was already stopped
                if (errno == ECHILD) {
                    RCLCPP_WARN(get_logger(), "Child for id=%d was already reaped", id);
                    return true;
                }

                RCLCPP_ERROR(get_logger(), "waitpid() failed for id=%d: %s", id, strerror(errno));

            }

            // waitpid() shouldn't return the pid of another process
            RCLCPP_ERROR(get_logger(), "waitpid() returned unexpected pid=%d for id=%d (expected %d)", result, id, proc.pid);
            return false;
        }

        // Clean everythinng up and delete the process
        void finishSequence(int id) {
            // Return if this process doesn't exist
            auto it = procs_.find(id);
            if (it == procs_.end()) {
                return;
            }

            // Cancel the timer
            if (it->second.timer) {
                it->second.timer->cancel();
            }

            // Remove the process from procs_
            procs_.erase(it);
            RCLCPP_INFO(get_logger(), "Stop sequence finished for id=%d", id);
        }

        // Kill a process via SIGTERM
        void sendSigkillIfDue(int id, ProcInfo &proc) {
            if (!proc.sigkill_sent && Clock::now() >= proc.deadline) {
                RCLCPP_WARN(get_logger(), "SIGTERM did not stop id=%d pid=%d; sending SIGKILL", id, proc.pid);

                // Handle upcoming errors
                if (kill(-proc.pid, SIGKILL) < 0 && errno != ESRCH) {
                    RCLCPP_ERROR(get_logger(), "SIGKILL failed for id=%d pid=%d: %s", id, proc.pid, strerror(errno));
                }

                // Update the process information
                proc.sigkill_sent = true;
            }
        }

        std::unordered_map<int, ProcInfo> procs_; // id -> pid
        rclcpp::Subscription<penguin_interface_package::msg::Single>::SharedPtr launch_single_subscriber;
        rclcpp::Subscription<penguin_interface_package::msg::Single>::SharedPtr stop_single_subscriber;
};

int main(int argc, char **argv) {
    rclcpp::init(argc, argv);
    auto node = std::make_shared<PenGUInController>();
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}
