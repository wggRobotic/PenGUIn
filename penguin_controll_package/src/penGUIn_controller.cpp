#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"
#include <string>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>

using namespace std::placeholders;

class PenGUInController : public rclcpp::Node {
public:
    PenGUInController() : Node("penguin_controller") {
        launch_single_subscriber = this->create_subscription<std_msgs::msg::String>(
            "penGUIn/start_single",
            10,
            std::bind(&PenGUInController::launchSingleNodeCallBack, this, std::placeholders::_1)
        );
        RCLCPP_INFO(this->get_logger(), "Launch Subscriber has been started");
    }

private:
    void launchSingleNodeCallBack(const std_msgs::msg::String::SharedPtr msg) {
        const std::string cmd = msg->data;

        pid_t pid = fork();
        if (pid < 0) {
            RCLCPP_INFO(this->get_logger(), "ERROR: Fork failed");
            return;
        }

        // Run via shell
        if (pid == 0) {
            const char* argv[] = {"bash", "-lc", cmd.c_str(), nullptr};
            execv("/bin/bash", (char* const*)argv);
            _exit(127);
        }

        // Wait for the result
        int status = 0;
        (void)waitpid(pid, &status, 0);

        int rc = -1;
        if (WIFEXITED(status)) rc = WEXITSTATUS(status);
        RCLCPP_INFO(this->get_logger(), "ros2 run exit code: %d", rc);
    }

    rclcpp::Subscription<std_msgs::msg::String>::SharedPtr launch_single_subscriber;
};

int main(int argc, char **argv) {
    rclcpp::init(argc, argv);
    auto node = std::make_shared<PenGUInController>();
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}
