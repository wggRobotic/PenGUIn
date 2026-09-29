class StdMsgsInterfaces {
  String getFloat64Request(double data) {
    return """{
      "data": $data
    }""";
  }
}