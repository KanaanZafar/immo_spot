import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:immospot/chats/show_messages.dart';
import 'package:immospot/models/chatted_user.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  DatabaseReference dbref = FirebaseDatabase.instance.reference();

//  List<String> chattedUsers = List<String>();
  List<ChattedUser> chattedUsers = List<ChattedUser>();
  List<String> uids = List<String>();
  StreamSubscription streamSubscription;
  StreamSubscription subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (StaticInfo.isActive == 1) {
      readFirebase();
    }
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSubscription?.cancel();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constant.colorsList[3],
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20,
              vertical: MediaQuery.of(context).size.height / 75),
          child: StaticInfo.isActive == 1
              ? ListView.builder(
                  itemBuilder: (ctx, index) {
                    return userWid(chattedUsers[index]);
                  },
                  itemCount: chattedUsers.length,
                )
              : Center(
                  child: Text(
                    'Please activate your account first',
                    textScaleFactor: 1.25,
                    style: TextStyle(
                        color: Constant.colorsList[1],
                        fontWeight: Constant.fontweights[5]),
                  ),
                ),
        ),
      ),
    );
  }

  Widget userWid(ChattedUser chattedUser) {
    return GestureDetector(
      onTap: () async {
        String abc = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => ShowMessages(chattedUser.userUid,
                    chattedUser.userNname, chattedUser.playerId)));
        chattedUser.hasRead = 'yes';
        chattedUsers.sort((a, b) => a.hasRead.compareTo(b.hasRead));

        setState(() {});
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 150),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 30,
            vertical: MediaQuery.of(context).size.height / 75),
        decoration: BoxDecoration(
          color: Constant.colorsList[3],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Constant.colorsList[4], width: 1.5),
          boxShadow: [
            BoxShadow(
                color: Constant.colorsList[2].withOpacity(0.5),
                spreadRadius: 0.5,
                offset: Offset(0.5, 1.0),
                blurRadius: 2.5),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                chattedUser.hasRead == 'no'
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(
//                              bottom: MediaQuery.of(context).size.height / 50,
                              right: MediaQuery.of(context).size.width / 50),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Constant.colorsList[0],
                          ),
                          height: 10.0,
                          width: 10.0,
                        ),
                      )
                    : Container(),
                Text(
                  chattedUser.userNname,
                  textScaleFactor: 1.25,
                  style: TextStyle(
                      color: Constant.colorsList[1],
                      fontWeight: Constant.fontweights[3]),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward,
              color: Constant.colorsList[1],
            ),
          ],
        ),
      ),
    );
  }

  readFirebase() async {
    streamSubscription = dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.latestMessages)
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        ChattedUser chattedUser = ChattedUser();

        if (event.snapshot.value[Constant.latestMessages] != null) {
          chattedUser.latestMessageTime =
              event.snapshot.value[Constant.latestMessages];
          chattedUser.userUid = event.snapshot.key;
          chattedUser.hasRead = event.snapshot.value[Constant.hasRead];
          chattedUser.userNname = event.snapshot.value[Constant.name];
          chattedUsers.add(chattedUser);
          uids.add(event.snapshot.key);
          chattedUsers.sort((a, b) => a.hasRead.compareTo(b.hasRead));
          setState(() {});
        }
      }
    });

    subscription = dbref.child(Constant.users).onChildAdded.listen((event) {
      if (event.snapshot.key != StaticInfo.currentUser.uid) {
        if (event.snapshot.value[Constant.isActive] == 1) {
          if (!uids.contains(event.snapshot.key)) {
            ChattedUser chattedUser = ChattedUser();
            chattedUser.userUid = event.snapshot.key;
            chattedUser.userNname = event.snapshot.value[Constant.name];
            chattedUser.latestMessageTime = 0;
            chattedUser.hasRead = 'yes';
            chattedUser.playerId = event.snapshot.value[Constant.playerId];
            chattedUsers.add(chattedUser);
            setState(() {});
          }
        } else {
          if (uids.contains(event.snapshot.key)) {
            chattedUsers.removeWhere(
                (element) => element.userUid == event.snapshot.key);
          }
        }
      }
    });
  }
}
