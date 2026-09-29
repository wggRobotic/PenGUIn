class StdMsgsInterfaces {
  String getFloat64Request(double data) {
    return """{
      "op": "publish",
      "topic": "/quac/gripper_width"
      "type": "std_msgs/msg/Float64",
      "msg": {
        "data": $data
      }
    }""";
  }
}