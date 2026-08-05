#include "rclcpp/rclcpp.hpp"
#include "interface_package/msg/single.hpp"
#include "std_msgs/msg/int32.hpp"
#include <string>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/prctl.h>
#include <signal.h>
#include <unistd.h>
#include <vector>
#include <chrono>

using namespace std::placeholders;
using namespace std::chrono_literals;

class PenGUInController : public rclcpp::Node {
    public:
        PenGUInController() : Node("penguin_controller") {
            // Subscribe to a topic and launch a node
            launch_single_subscriber = this->create_subscription<interface_package::msg::Single>(
                "penGUIn/start_single",
                10,
                std::bind(&PenGUInController::launchSingleNodeCallBack, this, std::placeholders::_1)
            );
            stop_single_subscriber = this->create_subscription<std_msgs::msg::Int32>(
                "penGUIn/stop_single",
                10,
                std::bind(&PenGUInController::stopSingleNodeCallBack, this, std::placeholders::_1)
            );
            RCLCPP_INFO(this->get_logger(), "All subscribers have been started");
        }
    private:
        struct ProcInfo {
            pid_t pid;
            bool alive;
            int repetitions;
        };

        void launchSingleNodeCallBack(const interface_package::msg::Single::SharedPtr msg) {
            std::string cmd = msg ->cmd;
            int id = msg->id;
            RCLCPP_WARN(this->get_logger(), "Id: %i", id);

            if (cmd.empty()) {
                RCLCPP_WARN(this->get_logger(), "ERROR: Unprocessable values");
                return;
            }

            // Return if a prozess with the same id already exists
            if (procs.count(id) && procs[id].alive) {
                RCLCPP_WARN(this->get_logger(), "Prozess with id '%i' already running", id);
                return;
            }

            pid_t ppid_before_fork = getpid();
            pid_t pid = fork();
            if (pid < 0) {
                RCLCPP_ERROR(get_logger(), "Fork failed");
                return;
            }

            if (pid == 0) {
                // Child process
                // Make sure all prozesses stop after this node being stopped
                prctl(PR_SET_PDEATHSIG, SIGTERM);
                
                // Check if this node already exited
                if (getppid() != ppid_before_fork) {
                    exit(1);
                }
                
                // Apply a certain process group
                setpgid(0, 0);

                const char* argv[] = {"bash", "-lc", cmd.c_str(), nullptr};
                execv("/bin/bash", (char* const*)argv);
                _exit(127);
            } else {
                // Parent process
                procs[id] = ProcInfo{pid, true, 0};
                RCLCPP_INFO(get_logger(), "Started id='%i' pid=%d", id, pid);
            }
        }

        void stopSingleNodeCallBack(const std_msgs::msg::Int32::SharedPtr msg) {
            int id = msg->data;

            // Find the process using the id
            auto it = procs.find(id);
            // If it's no longer running return
            if (it == procs.end() || !it->second.alive) {
                RCLCPP_WARN(this->get_logger(), "No running process for id=%i", id);
                return;
            }

            // Reset timer counter
            it->second.repetitions = 0;

            // Cancel old timer
            cancelTimer(id);

            // Kill the process (Strg + C)
            pid_t pid = it->second.pid;
            RCLCPP_INFO(this->get_logger(), "Stopping id=%i pid=%d", id, pid);
            kill(-pid, SIGINT);

            // Check whether it stopped every 100ms
            auto timer = this->create_wall_timer(
                std::chrono::milliseconds(100),
                [this, id, pid]() {
                    // Make sure the process exists
                    auto it2 = procs.find(id);
                    if (it2 == procs.end()) {
                        cancelTimer(id);
                        return;
                    }

                    // Cancel this timer if the process stopped
                    if (!checkRunningState(id, pid)) {
                        cancelTimer(id);
                    } else {
                        it2->second.repetitions += 1;

                        // After 1s kill the process
                        if (it2->second.repetitions >= 10) {
                            RCLCPP_WARN(this->get_logger(), "SIGINT didn't stop id=%i -> SIGKILL", id);
                            kill(-pid, SIGKILL);
                            (void)waitpid(pid, nullptr, 0);
                            procs[id].alive = false;
                            cancelTimer(id);
                        }
                    }
                }
            );
            pending_stop_kill_timers[id] = timer;
        }

        bool checkRunningState(int id, pid_t pid) {
            int status = 0;
            pid_t w = waitpid(pid, &status, WNOHANG);
            // Handle the waitpid Output
            if (w == 0) {
                // It didn't stop yet
                return true;
            } else if (w == pid) {
                // Check the childs exit status
                if (WIFEXITED(status)) {
                    RCLCPP_INFO(this->get_logger(), "Child exited with status %d", WEXITSTATUS(status));
                } else if (WIFSIGNALED(status)) {
                    RCLCPP_INFO(this->get_logger(), "Child killed by signal %d", WTERMSIG(status));
                }
                // It successfully stopped
                procs[id].alive = false;
                return false;
            } else {
                // Throw an error and finish
                RCLCPP_ERROR(this->get_logger(), "ERROR: Wait pid returned %d\n for child %i with the pid %i",  w, id, pid);
                procs[id].alive = false;
                return false;
            }
        }

        void cancelTimer(int id) {
            auto old = pending_stop_kill_timers.find(id);
            if (old != pending_stop_kill_timers.end() && old->second) {
                old->second->cancel();
                pending_stop_kill_timers.erase(old);
            }
        }

        std::unordered_map<int, ProcInfo> procs; // id -> pid
        rclcpp::Subscription<interface_package::msg::Single>::SharedPtr launch_single_subscriber;
        rclcpp::Subscription<std_msgs::msg::Int32>::SharedPtr stop_single_subscriber;
        std::unordered_map<int, rclcpp::TimerBase::SharedPtr> pending_stop_kill_timers;
        rclcpp::TimerBase:: SharedPtr reap_timer;
};

int main(int argc, char **argv) {
    rclcpp::init(argc, argv);
    auto node = std::make_shared<PenGUInController>();
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}

