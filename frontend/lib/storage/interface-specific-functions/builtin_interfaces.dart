class BuiltinInterfaces {
  Map<String, dynamic> getTimeRequest() {
    // Get the current time stamp
    final now = DateTime.now().toUtc();
    final totalMicroseconds = now.microsecondsSinceEpoch;

    // Return the required JSON header
    return {
      "stamp": {
        "sec": totalMicroseconds ~/ 1000000,
        "nanosec": (totalMicroseconds % 1000000) * 1000
      }
    };
  }
}