import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatStates {
  normal,
  highlighted
}

Chat parseDocument(DocumentSnapshot document) {
  String nickname = document.data()['nickname'];
  return Chat(
      name: nickname,
      message: "test123",
      lastSeen: "never"
  );
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

