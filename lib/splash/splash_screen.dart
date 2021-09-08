import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immospot/buyer/buyer_landing.dart';
import 'package:immospot/models/house.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';
import 'package:immospot/seller/seller_landing.dart';
import 'package:immospot/splash/welcome.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();

//    Future.delayed(Duration(milliseconds: 3000), () {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Constant.wallpaperAsset), fit: BoxFit.fill),
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              height: 175.0,
//              padding: EdgeInsets.symmetric(
//                  vertical: MediaQuery.of(context).size.height / 100,
//                  horizontal: MediaQuery.of(context).size.width / 50),
              width: 175.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Constant.logoAsset,
                      height: 100.0,
                      width: 100.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Image.asset(
                      Constant.nameAsset,
                      width: 125.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkUser() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await OneSignal.shared.init("24d8e239-cc7a-46e1-b549-1964ea5d19d0",
        iOSSettings: {
          OSiOSSettings.autoPrompt: true,
          OSiOSSettings.inAppLaunchUrl: true
        });

//    print('------------- Player ID ${playerId}');

//    OSPermissionSubscriptionState status =
//    await OneSignal.shared.getPermissionSubscriptionState();
//    String playerId = status.subscriptionStatus.userId;

    /* if ((await OneSignal.shared.getTags())['subscribe'] == null) {
      await OneSignal.shared.sendTag('subscribe', 'true');
    } else {
      if ((await OneSignal.shared.getTags())['subscribe'] == 'false') {
        await OneSignal.shared.sendTag('subscribe', 'false');
      } else {
        await OneSignal.shared.sendTag('subscribe', 'true');
      }
    } */
    await OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DatabaseReference dbref = FirebaseDatabase.instance.reference();
    if (user != null) {
      var status = await OneSignal.shared.getPermissionSubscriptionState();

      var playerId = status.subscriptionStatus.userId;
      StaticInfo.currentUser = user;
      await dbref
          .child(Constant.users)
          .child(StaticInfo.currentUser.uid)
          .once()
          .then((dataSnapshot) {
        StaticInfo.userName = dataSnapshot.value[Constant.name];
        StaticInfo.isActive = dataSnapshot.value[Constant.isActive];
      });

      await dbref
          .child(Constant.users)
          .child(StaticInfo.currentUser.uid)
          .update({Constant.playerId: playerId});
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
//      await Future.delayed(Duration(milliseconds: 500));
    } else {
//      await Future.delayed(Duration(milliseconds: 3500));
    }
// Navigator.pushAndRemoveUntil(context, newRoute, predicate)
    int modeNumber;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (await sharedPreferences.getInt(Constant.modeNum) != null) {
      modeNumber = await sharedPreferences.getInt(Constant.modeNum);
    }

//    print('--- ${modeNumber}');

    if (StaticInfo.currentUser == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => WelcomeScreen()),
          (predicate) => false);
    } else {
      if (modeNumber != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (ctx) =>
                    modeNumber == 0 ? BuyerLanding() : SellerLanding()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => WelcomeScreen()),
            (predicate) => false);
      }
    }
  }
}
