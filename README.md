# PenGUIn
**PenGUIn is a custom frontend for** the **ros2** framework, which is **used to manage configured nodes, introspect the ros2 communication, control the robots** and more.
Therefore we use the Rosbridge WebSocket server, which is supposed to be run on the robot, to enable the communication between Flutter and ros2.

### Overview
- [Installation](#Installation)
- [Usage](#Usage)
    - [Running the Rosbridge](#Running-the-ROSbridge)
    - [Running the control node](#Running-the-control-node)
    - [Running the frontend](#Running-the-Frontend)
- [Configuration](#Configuration)
    - [Configure nodes](#Configure-nodes)
    - [Configure analytics](#Configure-analytics)
    - [Configure controls](#configure-controls)
    - [Configure logs](#configure-logs)
- [Troubleshooting](#Troubleshooting)
- [How it works](#How-it-works)
    - [Communication between the Robot and PenGUIn](#Communication-between-the-Robot-and-PenGUIn)
    - [Camera image](#Camera-image)

### Installation
1. Install the required [ROSbridge WebSocket server](https://github.com/RobotWebTools/rosbridge_suite) as follows:
```
sudo apt-get install ros-<rosdistro>-rosbridge-server
```
2. Install these dependencies required for the camera stream:
```
sudo apt install libmpv-dev mpv libmimalloc2.0
sudo apt install libmimalloc-dev // Note: This is just required by developers!
```
3. Download all attached `.tar.xz` files from the [release page](https://github.com/wggRobotic/PenGUIn/releases/)
4. Unzip the `PenGUIn-v2.0.0-linux.tar.xz` archive within e.g. your projects folder *(It's highly recommended to move the extracted folder as a whole. Otherwise the frontend won't be able to launch!)*
6. Do the same for `PenGUIn-v2.0.0-packages.tar.xz` archive
7. Navigate into the extracted folder and run `colcon build` once

*Note: We currently don't support any other plattforms then linux.*

### Usage
###### Running the Rosbridge
Since the installation already includes a launch file, you can run the bridge as follows:
```
source /opt/ros/<rosdistro>/setup.bash
ros2 launch rosbridge_server rosbridge_websocket_launch.xml
```
*The default port is 9090.*

###### Running the control node
1. Navigate to the folder where you'd extracted the `PenGUIn-v2.0.0-packages.tar.xz` archive
2. If necessary run `colcon build` once again
3. Source the environment as follows: `source install/setup.bash`
4. Then launch the control node using this command: `ros2 run penguin_controll_package penGUIn_controller`

###### Running the frontend
1. Navigate to the folder where you'd extracted the `PenGUIn-v2.0.0-linux.tar.xz`
2. Double click on the file called "penGUIn" in order to launch the frontend

### Configuration
###### Configure nodes
In order to add a node, which you want to launch and introspect via PenGUIn, to the list of available nodes, navigate to the installation folder of the frontend and look for `/config`.
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
        "function": {                  // Define a function used to provide the input
            "tag": "",                      // One of the supported functions
            "type": "",                     // The full type of the interface
            "topic": ""                     // The topic that's used
        }
    },
    "horizontalSliders": [
        {
            "label": "",               // Set a label for the slider
            "function": {              // Define a function used to provide the input
                "tag": "",                  // The topic that's used
                "type": "",                 // The topic that's used
                "topic": ""                 // The topic that's used
            },
            "centered": false          // If true the sliders 0 coordinate is centred, otherwise it's left-sided
        }
    ],
    "verticalSliders": [
        {
            "label": "",               // Set a label for the slider
            "function": {              // Define a function used to provide the input
                "tag": "",                  // One of the supported functions
                "type": "",                 // The full type of the interface
                "topic": ""                 // The topic that's used
            },
            "centered": false          // If true the sliders 0 coordinate is centred, otherwise it's left-sided
        }
    ],
    "cameras": [
        {
            "label": "",               // Set a label for a camera
            "port": "",                // Configure the port of the RTSP stream
            "endpoint": ""             // Configure the exact endpoint of the RTSP stream
        }
    ],
    "robot-ip": "127.0.0.1"            // The IP address of the robot
}
```
Further information about the tags of all available functions can be found [here](AVAILABLE-CONTROL-FUNCTIONS.md).

###### Configure logs
Since there might be a lot of irrelevant log entries, you might also want to hide certain sources as follows:
```
[
    "/path/file.cpp",                   // Ignore a certain file
    "/path/*"                           // Ignore a certain directory
]
```

### Troubleshooting
###### "Service /ros_api/node_details does not exist"
This is a known bug, which is caused by a wrong configuration causing rosapi to be unable to retrieve information about a certain node. Since rosapi can't handle this, it keeps crashing.
So in order to fix this **check your node configuration** and **restart the WebSocket server**.
*(This is no frontend bug, but a rosapi bug. Please don't open an issue about this.)*

###### Unable to launch the frontend
If you've moved the frontend to another location, check whether you moved the subfolders too, because without those subfolders, the frontend might not launch due to a **lack of dependencies**.
In order to fix this **reinstall the frontend** where you want it and copy the whole `/config` folder into the archiv after unzipping it.

### How it works
##### Communication between the Robot and PenGUIn
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

##### Camera image
The camera image is streamed via RTSP. Therefore we us this ros2 package: https://github.com/wggRobotic/ros2-camera-stream-package. However this is basically how it works:
```
ros2-camera-stream-package
|
| RTSP Stream
|
PenGUIn (and MediaKit)
```
However, if you want to test this without using the package from above, try these CMD commands:
```
sudo apt install gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-dev pkg-config
curl -L https://raw.githubusercontent.com/GStreamer/gst-rtsp-server/master/examples/test-launch.c -o test-launch.c
gcc test-launch.c -o test-launch $(pkg-config --cflags --libs gstreamer-rtsp-server-1.0)

./test-launch '( videotestsrc is-live=true ! video/x-raw,width=640,height=480,framerate=15/1 ! videoconvert ! x264enc tune=zerolatency speed-preset=ultrafast ! rtph264pay name=pay0 pt=96 )'
```
Further ressources: [MediaKit](https://pub.dev/packages/media_kit)

