import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immospot/buyer/buyer_landing.dart';
import 'package:immospot/models/house.dart';
import 'package:immospot/models/message.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';
import 'package:immospot/seller/seller_landing.dart';
import 'package:immospot/splash/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  int modeNum;

  Profile(this.modeNum);

  @override
  _ProfileState createState() => _ProfileState(modeNum);
}

class _ProfileState extends State<Profile> {
  int modeNum;

  _ProfileState(this.modeNum);

  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  StreamSubscription streamSubscription;
  StreamSubscription _streamSubscription;
  StreamSubscription subscription;
  StreamSubscription _subscription;
  List<String> urls = [
    'https://www.google.com/',
    'https://www.google.com/',
    'https://www.google.com/'
  ];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSubscription?.cancel();
    _streamSubscription?.cancel();
    subscription?.cancel();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constant.colorsList[3],
        key: scaffoldKey,
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 75),
          child: SingleChildScrollView(
            child: Column(
              children: [links(), midCon(), lastCon()],
            ),
          ),
        ),
      ),
    );
  }

  Widget midCon() {
    return outerCon(
      Column(
        children: [btn(0, "SELLER MODE"), btn(1, "BUYER MODE")],
      ),
    );
  }

  Widget lastCon() {
    return outerCon(Column(
      children: [
        btn(5, "LOGOUT"),
        btn(6,
            StaticInfo.isActive == 1 ? "DEACTIVE ACCOUNT" : "ACTIVATE ACCOUNT"),
        btn(7, "DELETE ACCOUNT"),
      ],
    ));
  }

  Widget outerCon(Widget childWid) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Constant.colorsList[0],
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
              color: Constant.colorsList[2].withOpacity(0.5),
              spreadRadius: 0.5,
              offset: Offset(0.5, 1.0),
              blurRadius: 2.5),
        ],
      ),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 50,
          horizontal: MediaQuery.of(context).size.width / 20),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20,
          vertical: MediaQuery.of(context).size.height / 50),
      child: childWid,
    );
  }

  Widget reqbtn(int btnNum, String btnName) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 100),
      child: RaisedButton(
        onPressed: () {},
        color: Constant.colorsList[3],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Constant.colorsList[4], width: 1.5),
        ),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 75),
        child: Text(
          btnName,
          style: textStyle(2, 3),
          textScaleFactor: 1.25,
        ),
      ),
    );
  }

  Widget links() {
    return outerCon(Column(
      children: [
        btn(2, "Privacy Policy"),
        btn(3, "Terms & Conditions"),
        btn(4, "FAQ")
      ],
    ));
  }

  TextStyle textStyle(int clrNum, int fNum) {
    return TextStyle(
        color: Constant.colorsList[clrNum],
        fontWeight: Constant.fontweights[fNum],
        fontSize: 20);
  }

  Widget chuss(int btnNum, String btnName) {
    return MaterialButton(
      onPressed: () {},
      child: Text(
        btnName,
        style: textStyle(2, 3),
      ),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 75,
          horizontal: MediaQuery.of(context).size.width / 35),
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Constant.colorsList[4])),
    );
  }

  Widget btn(int btnNum, String btnName) {
    return GestureDetector(
      onTap: () async {
        if (btnNum == 0 || btnNum == 1) {
          if (modeNum != btnNum) {
            modeNum = btnNum;
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await sharedPreferences.setInt(Constant.modeNum, modeNum);
            if (modeNum == 0) {
              DataSnapshot dataSnapshot = await dbref
                  .child(Constant.users)
                  .child(StaticInfo.currentUser.uid)
                  .child(Constant.myHouses)
                  .once();
//      print('key: ${dataSnapshot.key}');

//      print('val: ${dataSnapshot.value}');
              if (dataSnapshot.value != null) {
                Map map = dataSnapshot.value;
//      print('--- ${map.keys.toList()}');
                String houseKey = map.keys.toList()[0];
//     print('houseKey: ${houseKey}');

                DataSnapshot dataSnapshot1 =
                    await dbref.child(Constant.houses).child(houseKey).once();
//        print('000 ${dataSnapshot1.value}');
                if (dataSnapshot1.value != null) {
                  StaticInfo.staticHouse = House.fromMap(dataSnapshot1.value);
                }

//        print(StaticInfo.staticHouse.toString());
              }
            }
            setState(() {
//              modeNum = btnNum;
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        modeNum == 1 ? BuyerLanding() : SellerLanding()),
                (predicate) => false);
          }
        } else if (btnNum > 1 && btnNum < 5) {
          _launchURL(urls[btnNum - 2]);
        } else if (btnNum == 5) {
          navigateToLogin();
        } else if (btnNum == 6) {
//          deleteAccount();
          deactivateAccount();
        } else if (btnNum == 7) {
//          deleteAccount();
          showAlertDialog(true);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 50),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 100),
        decoration: BoxDecoration(
          color: Constant.colorsList[modeNum == btnNum ? 4 : 3],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: modeNum == btnNum
                  ? Colors.transparent
                  : Constant.colorsList[4],
              width: 1.5),
          boxShadow: [
            BoxShadow(
                color: Constant.colorsList[2].withOpacity(0.5),
                spreadRadius: 0.25,
                offset: Offset(0.5, 1.0),
                blurRadius: 1.125),
          ],
        ),
        child: Center(
          child: modeNum == btnNum
              ? RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: btnName,
                        style: TextStyle(
                            color: Constant.colorsList[3],
                            fontSize: 20,
                            fontWeight: Constant.fontweights[2]),
                      ),
                      TextSpan(
                        text: "  (ACTIVE)",
                        style: TextStyle(
                            color: Constant.colorsList[3],
                            fontWeight: Constant.fontweights[2],
                            fontSize: 15),
                      ),
                    ],
                  ),
                )
              : Text(
                  btnName,
                  style: textStyle(2, 2),
//                  textScaleFactor: 1.25,
                ),
        ),
      ),
    );
  }

  deleteAccount() async {
    deleteChats();
    subscription = dbref.child(Constant.users).onChildAdded.listen((event) {});
    _streamSubscription = dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.myHouses)
        .onValue
        .listen((event) async {
      if (event.snapshot.value == null) {
        await dbref
            .child(Constant.users)
            .child(StaticInfo.currentUser.uid)
            .remove();
        navigateToLogin();
      }
    });
    streamSubscription =
        dbref.child(Constant.houses).onChildAdded.listen((event) async {
      if (event.snapshot.value[Constant.owner] == StaticInfo.currentUser.uid) {
        House house = House.fromMap(event.snapshot.value);
        StorageReference storageReference =
            FirebaseStorage().ref().child(Constant.houses).child(house.houseId);
        for (int i = 0; i < house.picturesList.length; i++) {
          await storageReference.child("${i}").delete();
        }
        await dbref
            .child(Constant.users)
            .child(StaticInfo.currentUser.uid)
            .child(Constant.myHouses)
            .child(house.houseId)
            .remove();
        await dbref.child(Constant.houses).child(house.houseId).remove();
      }
    });
  }

  navigateToLogin() async {
    await FirebaseAuth.instance.signOut();
    StaticInfo.currentUser = null;
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (ctx) => WelcomeScreen()), (route) => false);
  }

  showAlertDialog(bool askingPermission) {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(color: Constant.colorsList[0], width: 1.5),
      ),
      title: Text(
        askingPermission == false ? "Clearing your data" : "Are you sure ?",
        style: textStyle(2, 4),
        textScaleFactor: 1.25,
      ),
      content: askingPermission == false
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please Wait',
                  style: textStyle(2, 2),
//                  textScaleFactor: 1.125,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 40,
                ),
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Constant.colorsList[4]),
                )
              ],
            )
          : Text(
              'You want to delete account ?',
              textScaleFactor: 1.125,
              style: textStyle(2, 2),
            ),
      actions: askingPermission == true
          ? [
              dialogBtn(true),
              dialogBtn(false),
            ]
          : [Container(), Container()],
    );

    if (askingPermission == false) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) {
            return alertDialog;
          });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return alertDialog;
          });
    }
  }

  Widget dialogBtn(bool isNo) {
    return RaisedButton(
      onPressed: () {
        Navigator.pop(context);
        if (isNo == false) {
          showAlertDialog(false);
          deleteAccount();
        }
      },
      color: Constant.colorsList[4],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 100,
          horizontal: MediaQuery.of(context).size.width / 50),
      child: Text(
        isNo ? 'No' : 'Yes',
        style: textStyle(3, 3),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showSnackBar("Error launching url");
    }
  }

  showSnackBar(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  deleteChats() {
    subscription =
        dbref.child(Constant.users).onChildAdded.listen((event) async {
      await dbref
          .child(Constant.users)
          .child(event.snapshot.key)
          .child(Constant.latestMessages)
          .child(StaticInfo.currentUser.uid)
          .remove();
    });
    _subscription =
        dbref.child(Constant.chats).onChildAdded.listen((event) async {
      Message message = Message();
      message = Message.fromMap(event.snapshot.value);
      if (message.receiver == StaticInfo.currentUser.uid ||
          message.sender == StaticInfo.currentUser.uid) {
        await dbref.child(Constant.chats).child(message.messageId).remove();
      }
    });
  }

  deactivateAccount() async {
    StaticInfo.isActive = StaticInfo.isActive == 0 ? 1 : 0;
    await dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .update({Constant.isActive: StaticInfo.isActive});
    setState(() {});
  }
}
