import 'dart:convert';

class GeometryMsgsInterfaces {
  String getTwistRequest(double x, double y) {
    return """{
      "linear": {
        "x": $x,
        "y": 0,
        "z": 0,
      },
      "angular": {
        "x": 0,
        "y": 0,
        "z": $y
      }
    }""";
  }

  String getTwistStampedRequest(double x, double y) {
    return jsonEncode({
      "op": "publish",
      "topic": "/quac/cmd_vel_pilot",
      "type": "geometry_msgs/msg/TwistStamped",
      "msg": {
        "header": {
          "stamp": getTimeStamp(),
          "frame_id": "base_link",
        },
        "twist": getTwistRequest(x, y)
      },
    });
  }

  String getTimeStamp() {
    final now = DateTime.now().toUtc();
    final totalMicroseconds = now.microsecondsSinceEpoch;

    return """{
      "stamp": {
        "sec": ${totalMicroseconds ~/ 1000000},
        "nanosec": ${(totalMicroseconds % 1000000) * 1000}
      }
    }""";
  }
}

// TODO: Implement functions returning the correct request for the WebSocket Server
