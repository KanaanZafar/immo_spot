import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:immospot/res/constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:string_validator/string_validator.dart';

class SignUp extends StatefulWidget {
  Widget backIcon;
  Widget seller;

  SignUp(this.backIcon, this.seller);

  @override
  _SignUpState createState() => _SignUpState(backIcon, seller);
}

class _SignUpState extends State<SignUp> {
  Widget backIcon, seller;

  _SignUpState(this.backIcon, this.seller);

  List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          3, (generator) => TextEditingController());
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(
        color: Constant.colorsList[2],
      ));

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  bool passwordHidden = true;
  bool processing = false;

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
          key: scaffoldkey,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  backIcon,
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 13,
                  ),
                  seller,
//                Expanded(child: Container()),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 30,
                  ),

                  whiteCon()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyle(int clrNum, int fNum) {
    return TextStyle(
      color: Constant.colorsList[clrNum],
      fontWeight: Constant.fontweights[fNum],
    );
  }

  Widget join() {
    return Text(
      'JOIN',
      style: textStyle(2, 4),
      textScaleFactor: 1.75,
    );
  }

  Widget centralCon() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 50,
          horizontal: MediaQuery.of(context).size.width / 20),
      decoration: BoxDecoration(
        border: Border.all(color: Constant.colorsList[4], width: 2.0),
        borderRadius: BorderRadius.circular(17.5),
      ),
      child: Column(
        children: <Widget>[
          reqField(0),
          reqField(1),
          reqField(2),
          processing == false
              ? btn()
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 200),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Signing Up',
                          style: textStyle(1, 5),
                          textScaleFactor: 1.25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 30,
                        ),
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Constant.colorsList[4]),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget reqField(int conNum) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 200),
      child: TextFormField(
        controller: controllers[conNum],
        decoration: InputDecoration(
          border: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          errorBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          focusedErrorBorder: outlineInputBorder,
          hintText: conNum == 0 ? 'Name' : conNum == 1 ? 'Email' : 'Password',
          prefixIcon: Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 50),
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 100),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Constant.colorsList[4]),
            ),
            child: Icon(
              conNum == 0
                  ? Icons.person
                  : conNum == 1 ? Icons.local_post_office : Icons.lock,
              color: Constant.colorsList[2],
            ),
          ),
          suffixIcon: conNum < 2
              ? Icon(
                  Icons.remove_red_eye,
                  color: Colors.transparent,
                )
              : IconButton(
                  icon: Icon(
                    passwordHidden == true
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Constant.colorsList[2],
                  ),
                  onPressed: () {
                    setState(() {
                      passwordHidden = !passwordHidden;
                    });
                  },
                ),
          hintStyle: textStyle(2, 1),
          errorStyle: textStyle(2, 1),
        ),
        style: textStyle(2, 1),
        obscureText: conNum < 2 ? false : passwordHidden,
        validator: (txt) {
          if (conNum == 0) {
            if (txt == '') {
              return "Please enter your name";
            }
          } else if (conNum == 1) {
            if (!isEmail(txt)) {
              return "Invalid Email Address";
            }
          } else if (conNum == 2) {
            if (txt.length < 6) {
              return "Password must be of atleast 6 characters";
            }
          }
        },
      ),
    );
  }

  Widget whiteCon() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width,
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
        children: <Widget>[join(), centralCon(), lastText()],
      ),
    );
  }

  Widget btn() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 200),
      child: RaisedButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            dealSignUp();
          }
        },
        color: Constant.colorsList[4],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 75),
        child: Center(
          child: Text(
            "SIGNUP",
            style: textStyle(3, 5),
            textScaleFactor: 1.375,
          ),
        ),
      ),
    );
  }

//  Widget tems(){}
  Widget lastText() {
    return GestureDetector(
      child: richText(),
      onTap: () {},
    );
  }

  Widget richText() {
    List<TextSpan> textSpans = List<TextSpan>.generate(2, (span) {
      return TextSpan();
    });
    textSpans[0] = TextSpan(
      text: "By signing up, you agree to our\n",
      style: TextStyle(color: Constant.colorsList[2], fontSize: 20.0),
//        style: textStyle(2, 1),
    );
    textSpans[1] = TextSpan(
      text: 'TERMS & CONDITIONS',
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

  dealSignUp() async {
    try {
      setState(() {
        processing = true;
      });
      AuthResult authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: controllers[1].text, password: controllers[2].text);
//  authResult.user.displayName = 'a';
//      await OneSignal.shared.sendTag(Constant.userUid, authResult.user.uid);
      //  await OneSignal.shared.sendTag('uid', '${authResult.user.uid}');
//      await OneSignal.shared.pl);
//      OSPermissionSubscriptionState status =
//          await OneSignal.shared.getPermissionSubscriptionState();
//      String playerId = status.subscriptionStatus.userId;
//      print('------------- Player ID ${playerId}');

//      await OneSignal.shared.ta('uid', '${authResult.user.uid}');

      dbref.child(Constant.users).child(authResult.user.uid).set({
        Constant.name: controllers[0].text,
        Constant.isActive: 1,
//        Constant.playerId: playerId
      });
      showSnackBar('Successfully signed up');
      await Future.delayed(Duration(milliseconds: 1500));
      setState(() {
        processing = false;
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
//     showSnackBar(chithi)
        processing = false;
      });

      if (e.toString() ==
          'PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)') {
        showSnackBar('Error: problem in network connection');
      } else if (e.toString() ==
          'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)') {
        showSnackBar('Error: Invalid email address');
      } else if (e.toString() ==
          'PlatformException(ERROR_WEAK_PASSWORD, The given password is invalid. [ Password should be at least 6 characters ], null)') {
        showSnackBar(
            'Error: Passowrd is weak or invalid . Password should be atleast 6 characters');
      } else if (e.toString() ==
          'PlatformException(error, Given String is empty or null, null)') {
        showSnackBar('Error: Please write in all the fields');
      } else if (e.toString() ==
          'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)') {
        showSnackBar('Error: Given email is already in use');
      } else {
        showSnackBar(e.toString());
      }
    }
  }

  showSnackBar(String chithi) {
    SnackBar snackBar = SnackBar(
      content: Text(chithi),
    );
    scaffoldkey.currentState.showSnackBar(snackBar);
  }
}
