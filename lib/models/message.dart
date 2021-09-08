import 'package:immospot/res/constants.dart';

class Message {
  String messageId;
  String body;
  int sendingtime;
  String sender;
  String receiver;

  Message(
      {this.messageId,
      this.body,
      this.sendingtime,
      this.sender,
      this.receiver});

  Message.fromMap(Map<dynamic, dynamic> map) {
    this.messageId = map[Constant.messageId];
    this.body = map[Constant.body];
    this.sendingtime = map[Constant.sendingtime];
    this.sender = map[Constant.sender];
    this.receiver = map[Constant.receiver];
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.messageId: this.messageId,
      Constant.body: this.body,
      Constant.sendingtime: this.sendingtime,
      Constant.sender: this.sender,
      Constant.receiver: this.receiver
    };
  }

  @override
  String toString() {
    return 'Message{messageId: $messageId, body: $body, sendingtime: $sendingtime, sender: $sender, receiver: $receiver}';
  }
}
