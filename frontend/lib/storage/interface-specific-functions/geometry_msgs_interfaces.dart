import 'package:frontend/storage/interface-specific-functions/builtin_interfaces.dart';

class GeometryMsgsInterfaces {
  String getTwistRequest(double x, double y) {
    return """{
      "op": "publish",
      "topic": "/cmd_vel"
      "type": "geometry_msgs/msg/Twist",
      "msg": {
        "twist": {
          "linear": {
            "x": x,
            "y": 0,
            "z": 0,
          },
          "angular": {
            "x": 0,
            "y": 0,
            "z": y
          }
        }
      }
    }""";
  }

  String getTwistStampedRequest(double x, double y) {
    return """{
      "op": "publish",
      "topic": "/quac/cmd_vel_pilot",
      "type": "geometry_msgs/msg/TwistStamped",
      "msg": {
        "header": {
          "stamp": ${BuiltinInterfaces().getTimeRequest()},
          "frame_id": "base_link",
        },
        "twist": {
          "linear": {
            "x": x,
            "y": 0,
            "z": 0,
          },
          "angular": {
            "x": 0,
            "y": 0,
            "z": y
          }
        }
      },
    }""";
  }

  String getPose2DRequest(double x, double y, double theta) {
    return """{
      "op": "publish",
      "topic": "/quac/ee_pose",
      "type": "geometry_msgs/msg/Pose2D",
      "msg": {
        "x": $x,
        "y": $y,
        "theta": $theta
      }
    }""";
  }
}
