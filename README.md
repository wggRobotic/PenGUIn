# PenGUIn
PenGUIn is a custom frontend for the ros2 framework, which is used to launch all available nodes and control the
values of the topics and services of our ros2 projects.

### Overview
- [Installation](#Installation)
- [Usage](#Usage)
    - [Running the ROSbridge](#Running-the-ROSbridge)
- [Configuration](#Configuration)
    - [Configure nodes](#Configure-nodes)
    - [Configure topics](#Configure-topics)
    - [Configure services](#Configure-services)
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

###### Running the Frontend
TODO

### Configuration
###### Configure nodes
In order to add a node, which you want to launch via this frontend, to the list of available node, navigate to the install folder of the frontend and look for `/config`.
Inside this folder open the `nodes_config.json` file and edit it like this:
```
{
    "nodes": [
        {
            "executableName": "",    // The executable name of your node
            "packageName": "",       // The package name
            "description": "",       // Optional: A short description
            "documentationLink": "", // Optional: A link to the official documentation
            "isSelected": "true/false"         // Optional: Whether it will be selected or not
        }
    ]
}

```

###### Configure topics
TODO

###### Configure services
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
Further ressources:
- [Running Rosbridge](https://wiki.ros.org/rosbridge_suite/Tutorials/RunningRosbridge#Running_Rosbridge)
- [Rosbridge documentation](https://github.com/RobotWebTools/rosbridge_suite/blob/ros1/ROSBRIDGE_PROTOCOL.md)
- [Rosapi documentation](https://github.com/RobotWebTools/rosbridge_suite/tree/ros2/rosapi)

