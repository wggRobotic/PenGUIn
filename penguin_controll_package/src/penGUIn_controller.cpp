#include "rclcpp/rclcpp.hpp"
#include "interface_package/msg/single.hpp"
#include "std_msgs/msg/int32.hpp"
#include <string>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>

using namespace std::placeholders;

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
        RCLCPP_INFO(this->get_logger(), "All subscriber has been started");
    }

private:
    struct ProcInfo {
        pid_t pid;
        bool alive;
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

        pid_t pid = fork();
        if (pid < 0) {
            RCLCPP_ERROR(get_logger(), "Fork failed");
            return;
        }

        if (pid == 0) {
            // Apply a certain process group
            setpgid(0, 0);

            const char* argv[] = {"bash", "-lc", cmd.c_str(), nullptr};
            execv("/bin/bash", (char* const*)argv);
            _exit(127);
        }

        // Parent
        procs[id] = ProcInfo{pid, true};
        RCLCPP_INFO(get_logger(), "Started id='%i' pid=%d", id, pid);
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

        // Kill the process (Strg + C)
        pid_t pid = it->second.pid;
        RCLCPP_INFO(this->get_logger(), "Stopping id=%i pid=%d", id, pid);
        kill(-pid, SIGINT);
    }

    std::unordered_map<int, ProcInfo> procs; // id -> pid
    rclcpp::Subscription<interface_package::msg::Single>::SharedPtr launch_single_subscriber;
    rclcpp::Subscription<std_msgs::msg::Int32>::SharedPtr stop_single_subscriber;
};

int main(int argc, char **argv) {
    rclcpp::init(argc, argv);
    auto node = std::make_shared<PenGUInController>();
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}

// TODO: Make sure a stopped node can be launched again
