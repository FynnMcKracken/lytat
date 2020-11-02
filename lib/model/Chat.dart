enum ChatStates {
  normal,
  highlighted
}

class Chat {
  const Chat({this.name, this.message, this.lastSeen, this.timeoutStart, this.timeoutEnd, this.state: ChatStates.normal});

  final String name;
  final String message;
  final String lastSeen;
  final DateTime timeoutStart;
  final DateTime timeoutEnd;
  final ChatStates state;

  double getProgress(DateTime now) {
    Duration durationTimeout = this.timeoutStart.difference(this.timeoutEnd);
    Duration durationNow = this.timeoutStart.difference(now.toUtc());
    return durationNow.inMilliseconds / durationTimeout.inMilliseconds;
  }
}