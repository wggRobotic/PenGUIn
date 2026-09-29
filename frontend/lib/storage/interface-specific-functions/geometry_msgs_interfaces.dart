import 'package:frontend/storage/interface-specific-functions/builtin_interfaces.dart';

class GeometryMsgsInterfaces {
  String getTwistRequest(double x, double y) {
    return """{
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
    }""";
  }

  String getTwistStampedRequest(double x, double y) {
    return """{
      "header": {
        "stamp": ${BuiltinInterfaces().getTimeRequest()},
        "frame_id": "base_link",
      },
      "twist": ${getTwistRequest(x, y)}
    }""";
  }

  String getPose2DRequest(double x, double y, double theta) {
    return """{
      "x": $x,
      "y": $y,
      "theta": $theta
    }""";
  }
}
