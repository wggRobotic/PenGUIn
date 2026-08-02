# PenGUIn
PenGUIn is a custom frontend for the ros2 framework, which is used to launch all available nodes and control the
values of the topics and services of our ros2 projects.

### Overview
- [Installation](#Installation)
- [Usage](#Usage)
    - [Running the ROSbridge](#Running-the-ROSbridge)
- [How it works](#How-it-works)

### Installation
1. Install the [Rosbridge](https://github.com/RobotWebTools/rosbridge_suite) by running this command:
```
sudo apt-get install ros-<rosdistro>-rosbridge-server
```
2. Download the frontend as well as the launch node package from the release page
3. Move the launch node package to your ros2 workspace and build your workspace
4. Unzip the frontend build, move into the new folder and launch the frontend build

### Usage
###### Running the ROSbridge
Since the install already includes a launch file, you can run the bridge as follows:
```
source /opt/ros/<rosdistro>/setup.bash
ros2 launch rosbridge_server rosbridge_websocket_launch.xml
```
*The default port is 9090.*
###### Running the launch node
TODO

####### Running the Frontend
TODO

### How it works
This is how the communication between your robot and the frontend works:
```
ros2 nodes
|
| DDS
|
WebSocket server (ROSbridge)
|
| JSON
|
Frontend
```

