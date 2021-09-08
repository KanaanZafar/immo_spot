import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immospot/auth/login.dart';
import 'package:immospot/buyer/buyer_landing.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';

import 'package:immospot/seller/seller_landing.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int itemSelected = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Constant.wallpaperAsset), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Container(
                width: MediaQuery.of(context).size.width,
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
                    'WELCOME',
                    style: textStyle(3, 5),
                    textScaleFactor: 1.75,
                  ),
                ),
              ),
              bottomCon()
            ],
          ),
        ),
      ),
    );
  }

  TextStyle textStyle(int clrNum, int fNum) {
    return TextStyle(
//        color: isWhite ? Colors.white : Colors.black,

        color: Constant.colorsList[clrNum],
        fontWeight: Constant.fontweights[fNum]);
  }

  Widget bottomCon() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "I WANT TO",
            textScaleFactor: 1.25,
            style: textStyle(2, 5),
          ),
          Row(
//            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[circleWid(0), circleWid(1)],
          ),
          itemSelected > -1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    RaisedButton(
                      onPressed: () {
                        if (StaticInfo.currentUser == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => Login(itemSelected)));
                        } else {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => itemSelected == 0
                                      ? BuyerLanding()
                                      : SellerLanding()),
                              (predicate) => false);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: Constant.colorsList[4],
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 75,
                        horizontal: MediaQuery.of(context).size.width / 10,
                      ),
                      child: Center(
                        child: Text(
                          "CONTINUE",
                          style: textStyle(3, 1),
                        ),
                      ),
                    ),
                    Container(),
                  ],
                )
              : Text(
                  'SELECT AN OPTION TO CONTINUE',
                  style: textStyle(1, 1),
                ),
          Container(),
        ],
      ),
    );
  }

//brown,grey,black,white,greem
  Widget circleWid(int itemNum) {
    return GestureDetector(
      onTap: () {
        setState(() {
          itemSelected = itemNum;
        });
      },
      child: Container(
        padding: EdgeInsets.all(itemNum == 0 ? 20.0 : 16.5),
//     height: 200.0,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 40),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Constant.colorsList[2].withOpacity(0.2),
                spreadRadius: 3.0,
                offset: Offset(0.5, 1.0),
                blurRadius: 6.0),
          ],
          border: Border.all(
            color: Constant.colorsList[itemNum == itemSelected ? 4 : 1],
            width: 2.0,
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset(
                itemNum == 0 ? Constant.keyAsset : Constant.dollarAsset,
                height: 20.0,
//              width: 20.0, fit: BoxFit.cover,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                itemNum == 0 ? 'BUY' : 'SELL',
                style: textStyle(1, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
