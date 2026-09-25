# PenGUIn
PenGUIn is a custom frontend for the ros2 framework, which is used to launch all available nodes and control the
values of the topics and services of our ros2 projects.

### Overview
- [Installation](#Installation)
- [Usage](#Usage)
    - [Running the ROSbridge](#Running-the-ROSbridge)
    - [Running the control node](#Running-the-control-node)
    - [Running the Frontend](#Running-the-Frontend)
- [Configuration](#Configuration)
    - [Configure nodes](#Configure-nodes)
    - [Configure analytics](#Configure-analytics)
    - [Configure controls](#configure-controls)
- [Troubleshooting](#Troubleshooting)
- [How it works](#How-it-works)

### Installation
1. Install the [Rosbridge](https://github.com/RobotWebTools/rosbridge_suite) by running this command:
```
sudo apt-get install ros-<rosdistro>-rosbridge-server
```
2. Download the frontend from the [release page](https://github.com/wggRobotic/PenGUIn/releases/)
3. Unzip the archive and note the folder where you unzipped it
3. Move the launch node package to your ros2 workspace and build your workspace
4. Unzip the frontend build, move into the new folder and launch the frontend build
*When moving the frontend make sure to **move all included subdirectories** to the same location and **keep the structure the way it's been right after unzipping** the archive, because otherwise important assets and more can't be located.*
5. Download the archive with the packages from the [release page](https://github.com/wggRobotic/PenGUIn/releases/)
6. Move the archive into the `/src` folder your workspace and unzip it

### Usage
###### Running the ROSbridge
Since the install already includes a launch file, you can run the bridge as follows:
```
source /opt/ros/<rosdistro>/setup.bash
ros2 launch rosbridge_server rosbridge_websocket_launch.xml
```
*The default port is 9090.*
###### Running the control node
1. Clone the `penguin_controll_package` as well as the `penguin_interface_package` inside your ros2 workspace
2. After cloning the required packages, open a new terminal and run `colcon build`
3. Source the environment: `source install/setup.bash`
4. Then launch the control node using this command: `ros2 run penguin_controll_package penGUIn_controller`

###### Running the Frontend
1. Navigate to the install folder
2. Double click on the file called "frontend"

### Configuration
###### Configure nodes
In order to add a node, which you want to launch and introspect via this frontend, to the list of available node, navigate to the install folder of the frontend and look for `/config`.
Inside this folder open the `nodes_config.json` file and edit it like this:
```
[
    {
        "executableName": "",       // The executable name of your node
        "packageName": "",          // The package name
        "nodeName": "",             // Optional: The name of a node returned by `ros2 node list`, otherwise the executable name is used
        "description": "",          // Optional: A short description
        "documentationLink": "",    // Optional: A link to the official documentation
        "customCMD": "",            // Optional: Set a custom cmd, default is `ros2 run <pkg> <exe>`
        "isSelected": false         // Optional: Whether it will be selected by default or not
    }
]
```

###### Configure analytics
Since you need to configure each topic, service or action for the analytics part, navigate to the install folder of the frontend and open the `analytics.json` file within the `/config` folder.
This file is supposed to be configured as like this:
```
[
    {
        "type": "Topic",                // Define whether it's a topic/service/action
        "name": "name",                 // The name of the topic/service/action
        "description": "*optional*",    // Optional: A short description
        "category": "*optional*"        // Optional: Category for filtering
    }
]
```

###### Configure controls
Since we want to support as many robots as possible with this single UI, you'll have to configure your desired controls manually. Therefore navigate to the install folder and open the `controls_config.json` within the `/config` folder.
This file is supposed to be configured as follows:
```
{
    "joystick": {
        "xFunction": "",                // Define the function used to profide the input for the x-axis
        "yFunction": ""                 // Define the function used to profide the input for the y-axis
    },
    "horizontalSliders": [
        {
            "label": "",                // Set a label for the slider
            "function": "",             // Define a function used to provide the input
            "centered": false           // If true the sliders 0 coordinate is centred, otherwise it's left-sided
        }
    ],
    "verticalSliders": [
        {
            "label": "",                // Set a label for the slider
            "function": "",             // Define a function used to provide the input
            "centered": false           // If true the sliders 0 coordinate is centred, otherwise it's left-sided
        }
    ],
    "cameras": [
        {
            "label": "",                // Set a label for a camera
            "function": ""              // Define a function used to retrieve the camera image
        }
    ]
}
```
Further information about the tags of all available functions can be found [here](AVAILABLE-CONTROL-FUNCTIONS.md).

### Troubleshooting
###### "Service /ros_api/node_details does not exist"
This is a known bug, which is caused by a wrong configuration causing rosapi to be unable to retrieve information about a certain node. Since rosapi can't handle this, it keeps crashing.
So in order to fix this **check your node configuration** and **restart the WebSocket server**.
*(This is no frontend bug, but a rosapi bug. Please don't open an issue about this.)*

###### Unable to launch the frontend
If you've moved the frontend to another location, check whether you moved the subfolders too, because without those subfolders, the frontend might not launch.
In order to fix this **reinstall the frontend** where you want it and copy the whole `/config` folder into the archiv after unzipping it.

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

