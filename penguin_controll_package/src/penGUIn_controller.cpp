#include "rclcpp/rclcpp.hpp"
#include "interface_package/msg/single.hpp"
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
        RCLCPP_INFO(this->get_logger(), "Launch Subscriber has been started");
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

    std::unordered_map<int, ProcInfo> procs; // id -> pid
    rclcpp::Subscription<interface_package::msg::Single>::SharedPtr launch_single_subscriber;
};

int main(int argc, char **argv) {
    rclcpp::init(argc, argv);
    auto node = std::make_shared<PenGUInController>();
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}

