import 'dart:convert';

class Quac {
  String getQuacDrivingRequest(double x, double y) {
    return jsonEncode({
      "op": "publish",
      "topic": "/quac/cmd_vel_pilot",
      "type": "geometry_msgs/msg/TwistStamped",
      "msg": {
        "header": { // TODO: Use the correct time stamp (if necessary) => ros2 system time!
          "stamp": {
            "sec": 0,
            "nanosec": 0
          },
          "frame_id": "base_link" // TODO: Use the required root link for quac
        },
        "twist": {
          "linear": {
            "x": x,
            "y": 0,
            "z": 0
          },
          "angular": {
            "x": 0,
            "y": 0,
            "z": y
          }
        }
      }
    });
  }
}

// TODO: Implement functions returning the correct request for the WebSocket Server