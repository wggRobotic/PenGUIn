class GeometryMsgsInterfaces {
  Map<String, dynamic> getTwistRequest(double x, double y) {
    return {
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
    };
  }

  Map<String, dynamic> getTwistStampedRequest(double x, double y) {
    // Get the time stamp
    final now = DateTime.now().toUtc();
    final totalMicroseconds = now.microsecondsSinceEpoch;

    // Assemble the request and return it
    return {
      "header": {
        "stamp": {
          "sec": totalMicroseconds ~/ 1000000,
          "nanosec": (totalMicroseconds % 1000000) * 1000
        },
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
    };
  }

  Map<String, dynamic> getPose2DRequest(double x, double y, double theta) {
    return {
      "x": x,
      "y": y,
      "theta": theta
    };
  }
}
