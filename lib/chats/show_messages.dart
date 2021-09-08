import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immospot/models/message.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';
import 'package:http/http.dart' as http;

class ShowMessages extends StatefulWidget {
  String userUid;
  String userName;
  String playerId;

  ShowMessages(this.userUid, this.userName, this.playerId);

  @override
  _ShowMessagesState createState() =>
      _ShowMessagesState(userUid, userName, playerId);
}

class _ShowMessagesState extends State<ShowMessages> {
  String userUid;
  String userName;
  String playerId;

  _ShowMessagesState(this.userUid, this.userName, this.playerId);

  TextEditingController textEditingController = TextEditingController();
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (playerId == null) {
      getPlayerId();
    }

    manipulateFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: Center(
            child: reqAppBar(),
          ),
          preferredSize: Size.fromHeight(87.5),
        ),
        body: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                controller: _scrollController,
                query: dbref.child(Constant.chats),
                sort: ((a, b) => a.value[Constant.sendingtime]
                    .compareTo(b.value[Constant.sendingtime])),
                itemBuilder: (ctx, dataSnapshot, anim, index) {
                  if ((dataSnapshot.value[Constant.sender] ==
                              StaticInfo.currentUser.uid ||
                          dataSnapshot.value[Constant.sender] == userUid) &&
                      (dataSnapshot.value[Constant.receiver] == userUid ||
                          dataSnapshot.value[Constant.receiver] ==
                              StaticInfo.currentUser.uid)) {
                    Message message = Message.fromMap(dataSnapshot.value);
                    return messageWid(message);
                  }
                  return Container();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: reqField(),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle(int fNum) {
    return TextStyle(
        color: Constant.colorsList[1], fontWeight: Constant.fontweights[fNum]);
  }

  Widget reqAppBar() {
    return Card(
      elevation: 7.0,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leadingIcon(false),
            Text(
              userName,
              style: textStyle(3),
              textScaleFactor: 2.0,
            ),
//          leadingIcon(true)
            Container(), Container(), Container(),
          ],
        ),
      ),
    );
  }

  Widget leadingIcon(bool isFaltu) {
    return Container(
      decoration: isFaltu
          ? BoxDecoration(color: Colors.transparent)
          : BoxDecoration(
              color: Constant.colorsList[3],
              shape: BoxShape.circle,
              border: Border.all(color: Constant.colorsList[4], width: 1.25),
            ),
      child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isFaltu ? Colors.transparent : Constant.colorsList[1],
          ),
          onPressed: isFaltu == true
              ? null
              : () {
                  Navigator.pop(context);
                }),
    );
  }

  Widget reqField() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 50,
//          vertical: MediaQuery.of(context).size.height / 200,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Constant.colorsList[3],
        border: Border(top: BorderSide(color: Constant.colorsList[1])),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 100),
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Type your message here',
            suffix: FloatingActionButton(
              onPressed: playerId != null
                  ? () {
//               if(playerId !){}
                      sendMessage();
                    }
                  : null,
              backgroundColor: Constant.colorsList[4],
              child: Icon(
                Icons.send,
                color: Constant.colorsList[3],
              ),
            ),
          ),
          textAlign: TextAlign.center,
          maxLines: null,
        ),
      ),
    );
  }

  sendMessage() async {
    int tempTime = DateTime.now().millisecondsSinceEpoch;
    if (textEditingController.text != '') {
      Message message = Message();
      message.messageId = dbref.push().key;
      message.sender = StaticInfo.currentUser.uid;
      message.receiver = userUid;
      message.sendingtime = tempTime;
      message.body = textEditingController.text.trim();
      await sendNoti(message.body);
      await dbref
          .child(Constant.chats)
          .child(message.messageId)
          .set(message.toMap());
    }
    await dbref
        .child(Constant.users)
        .child(userUid)
        .child(Constant.latestMessages)
        .child(StaticInfo.currentUser.uid)
        .set({
      Constant.latestMessages: tempTime,
      Constant.hasRead: 'no',
      Constant.name: StaticInfo.userName,
//      Consta
    });
//    await sendNoti();
    setState(() {
      textEditingController.text = '';
    });
  }

  manipulateFirebase() async {
//  dbref.child(Constant.users).ch

    dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.latestMessages)
        .child(userUid)
        .update({Constant.hasRead: 'yes'});
    await Future.delayed(Duration(milliseconds: 1000));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 3),
      curve: Curves.ease,
    );
  }

  Widget messageWid(Message message) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20),
      child: Align(
        alignment: message.sender == StaticInfo.currentUser.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 100),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 35,
              vertical: MediaQuery.of(context).size.height / 75),
          decoration: BoxDecoration(
            color: Constant.colorsList[3],
            border: Border.all(
              color: Constant.colorsList[
                  message.sender == StaticInfo.currentUser.uid ? 4 : 0],
            ),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: Constant.colorsList[2].withOpacity(0.5),
                  spreadRadius: 0.5,
                  offset: Offset(0.5, 1.0),
                  blurRadius: 2.5),
            ],
          ),
          child: Center(
              child: Text(
            message.body,
            style: textStyle(2),
            textScaleFactor: 1.125,
          )),
        ),
      ),
    );
  }

  sendNoti(String msg) async {
    print('userUid: ${playerId}');
    http.Response res = await http.post(
      'https://onesignal.com/api/v1/notifications',
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization":
            "Basic NDk5MTRiMDQtYTRjNC00NGVmLWE4YWQtMDNkYzlkNmQ5ZDE0"
      },
      body: json.encode({
        'app_id': "24d8e239-cc7a-46e1-b549-1964ea5d19d0",
        'contents': {"en": "${msg}"},
        "include_player_ids": ["${playerId}"],
      }),
    );
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
//    print('statusCode: ${res.statusCode}');
//    print('res: ${res.body}');
//    print('====== ${res.statusCode} and ${res.body}');
  }

  getPlayerId() {
    dbref
        .child(Constant.users)
        .child(userUid)
        .child(Constant.playerId)
        .once()
        .then((dataSnapshot) {
      playerId = dataSnapshot.value;
    });
  }
}
