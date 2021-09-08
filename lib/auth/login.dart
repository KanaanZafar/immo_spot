import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:immospot/auth/sign_up.dart';
import 'package:immospot/buyer/buyer_landing.dart';
import 'package:immospot/models/house.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';
import 'package:immospot/seller/seller_landing.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';

class Login extends StatefulWidget {
  int modeNum;

  Login(this.modeNum);

  @override
  _LoginState createState() => _LoginState(modeNum);
}

class _LoginState extends State<Login> {
  int modeNum;

  _LoginState(this.modeNum);

  BoxDecoration greenBorder;
  bool passwordHidden = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    greenBorder = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17.5),
      border: Border.all(color: Constant.colorsList[4], width: 2.0),
    );
  }

  List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          2, (generator) => TextEditingController());
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(
        color: Constant.colorsList[2],
      ));
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool processing = false;
  bool forgotPasswordTapped = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Constant.wallpaperAsset), fit: BoxFit.cover),
        ),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  backIcon(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 13,
                  ),
                  seller(),
//                Expanded(child: Container()),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  whiteCon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget seller() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 50),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 75),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.grey.withOpacity(0.5),
              Colors.black.withOpacity(0.2),
              Colors.grey.withOpacity(0.5),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.2, 0.4, 1.0]),
      ),
      child: Center(
        child: Text(
          modeNum == 0 ? 'BUYER' : 'SELLER',
          style: textStyle(3, 5),
          textScaleFactor: 1.75,
        ),
      ),
    );
  }

  TextStyle textStyle(int clrNum, int fNum) {
    return TextStyle(
        color: Constant.colorsList[clrNum],
        fontWeight: Constant.fontweights[fNum]);
  }

  Widget backIcon() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 75,
            horizontal: MediaQuery.of(context).size.width / 30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Constant.colorsList[3],
          border: Border.all(color: Constant.colorsList[4], width: 1.5),
        ),
        child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Constant.colorsList[2],
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }

  Widget whiteCon() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
//     height: double.infinity,
      width: MediaQuery.of(context).size.width,
//      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(),
          forgotPasswordTapped != true
              ? Text(
                  "MEMBER",
                  style: textStyle(2, 4),
                  textScaleFactor: 1.75,
                )
              : Column(
                  children: <Widget>[
                    Text(
                      'RESET PASSWORD',
                      style: textStyle(2, 4),
                      textScaleFactor: 1.5,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 75,
                    ),
                    Text(
                      'Enter your email and we will send\nyou password reset instructions',
                      textAlign: TextAlign.center,
                      style: textStyle(2, 2),
                      textScaleFactor: 1.25,
                    ),
                  ],
                ),
          centralCon(),
          forgotPasswordTapped != true ? chorRasta() : Container(),
          Container(),
          Container()
        ],
      ),
    );
  }

  Widget centralCon() {
    return Container(
      decoration: greenBorder,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 15,
          vertical: MediaQuery.of(context).size.height / 50),
      child: Column(
        children: <Widget>[
          reqField(0),
          forgotPasswordTapped != true ? reqField(1) : Container(),
          GestureDetector(
            onTap: () {},
            child: Align(
              alignment: Alignment.centerRight,
              child: forgotPass(),
            ),
          ),
          processing == false
              ? btn()
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 100),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          forgotPasswordTapped != true
                              ? "Signing In"
                              : 'Sending',
                          style: textStyle(2, 5),
                          textScaleFactor: 1.25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 20,
                        ),
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Constant.colorsList[4]),
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget btn() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: Constant.colorsList[4],
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 75),
      child: Center(
        child: Text(
          forgotPasswordTapped != true ? "LOGIN" : "SEND",
          style: textStyle(3, 5),
          textScaleFactor: 1.375,
        ),
      ),
      onPressed: () {
        if (formKey.currentState.validate()) {
          if (forgotPasswordTapped != true) {
            dealSignIn();
          } else {
            passReset();
          }
        }
      },
    );
  }

  passReset() async {
    try {
      setState(() {
        processing = true;
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controllers[0].text);
      setState(() {
        processing = false;
      });
      showSnackBar('Password reset email sent.');
      await Future.delayed(Duration(milliseconds: 1250));
      setState(() {
//        processing = false;
        forgotPasswordTapped = !forgotPasswordTapped;
      });
    } catch (e) {
      print('=== ${e.toString()}');
      setState(() {
        processing = false;
      });
      showSnackBar(e.toString());
    }
  }

  Widget forgotPass() {
    return Padding(
//      padding: EdgeInsets.symmetric(
//          vertical: MediaQuery.of(context).size.height / 200),
      padding: EdgeInsets.only(
//          top: MediaQuery.of(context).size.height / 500,
          bottom: MediaQuery.of(context).size.height / 100),
      child: GestureDetector(
        onTap: () {
          setState(() {
            forgotPasswordTapped = !forgotPasswordTapped;
          });
        },
        child: Text(
          forgotPasswordTapped != true ? 'Forgot Password?' : 'show password',
          style: textStyle(2, 1),
        ),
      ),
    );
  }

  Widget reqField(int conNum) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 75),
      child: TextFormField(
        controller: controllers[conNum],
        decoration: InputDecoration(
          border: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          errorBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          focusedErrorBorder: outlineInputBorder,
          hintText: conNum == 0 ? 'Email' : 'Password',
          hintStyle: textStyle(2, 1),
          errorStyle: textStyle(2, 1),
          prefixIcon: Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 50),
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 100),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Constant.colorsList[4],
              ),
            ),
            child: Icon(
              conNum == 0 ? Icons.local_post_office : Icons.lock,
              color: Constant.colorsList[1],
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(passwordHidden == true
                ? Icons.visibility
                : Icons.visibility_off),
            color: conNum == 0 ? Colors.transparent : Constant.colorsList[1],
            onPressed: () {
              setState(() {
                passwordHidden = !passwordHidden;
              });
            },
          ),
        ),
        obscureText: conNum == 0 ? false : passwordHidden,
        style: textStyle(1, 1),
        validator: (txt) {
          if (conNum == 0) {
            if (!isEmail(txt)) {
              return 'Invalid Email Address';
            }
          } else if (conNum == 1) {
            if (txt.length < 6) {
              return 'Password must be of atleast 6 characters';
            }
          }
        },
      ),
    );
  }

  Widget chorRasta() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => SignUp(backIcon(), seller())));
      },
      child: Container(
        decoration: greenBorder,
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 50,
            horizontal: MediaQuery.of(context).size.width / 50),
        child: Center(
          child: richText(),
        ),
      ),
    );
  }

  Widget richText() {
    List<TextSpan> textSpans = List<TextSpan>.generate(2, (span) {
      return TextSpan();
    });
    textSpans[0] = TextSpan(
      text: "Not a member? Create account ",
      style: TextStyle(color: Constant.colorsList[2], fontSize: 20.0),
//        style: textStyle(2, 1),
    );
    textSpans[1] = TextSpan(
      text: 'Here',
      style: TextStyle(
          color: Constant.colorsList[4],
          fontWeight: FontWeight.bold,
          fontSize: 20.0),
//      style: textStyle(4, 5),
    );
    return RichText(
      text: TextSpan(children: textSpans),
      textAlign: TextAlign.center, //textScaleFactor: 1.5,
    );
  }

  dealSignIn() async {
    try {
      setState(() {
        processing = true;
      });
      AuthResult authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: controllers[0].text, password: controllers[1].text);
      StaticInfo.currentUser = authResult.user;
      await dbref
          .child(Constant.users)
          .child(authResult.user.uid)
          .once()
          .then((dataSnapshot) {
        StaticInfo.userName = dataSnapshot.value[Constant.name];
        StaticInfo.isActive = dataSnapshot.value[Constant.isActive];
      });
      OSPermissionSubscriptionState status =
          await OneSignal.shared.getPermissionSubscriptionState();
      String playerId = status.subscriptionStatus.userId;
      await dbref
          .child(Constant.users)
          .child(authResult.user.uid)
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

      setState(() {
        processing = false;
      });
      showSnackBar("Successfully Signed in");
//      await Future.delayed(Duration(milliseconds: 750));
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setInt(Constant.modeNum, modeNum);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (ctx) =>
                  modeNum == 0 ? BuyerLanding() : SellerLanding()),
          (predicate) => false);
    } catch (e) {
      setState(() {
        processing = false;
      });
      if (e.toString() ==
          'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)') {
        showSnackBar('Error: User not found');
      } else if (e.toString() ==
          'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)') {
        showSnackBar('Error: Wrong password');
      } else if (e.toString() ==
          'PlatformException(error, Given String is empty or null, null)') {
        showSnackBar('Error: Given fields are empty ');
      } else if (e.toString() ==
          'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)') {
        showSnackBar(
            'Error: Inavild email. The email addrees is badly formated');
      } else if (e.toString() ==
          'PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)') {
        showSnackBar('Error: Problem in network connection');
      } else {
        showSnackBar(e.toString());
      }
    }
  }

  showSnackBar(String msg) {
    SnackBar snackBar = SnackBar(content: Text(msg));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
