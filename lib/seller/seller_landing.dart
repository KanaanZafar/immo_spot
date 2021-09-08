import 'package:flutter/material.dart';
import 'package:immospot/chats/chat.dart';
import 'package:immospot/profile/profile.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';
import 'package:immospot/seller/my_houses.dart';
import 'package:immospot/seller/sellAHouse.dart';

class SellerLanding extends StatefulWidget {
  @override
  _SellerLandingState createState() => _SellerLandingState();
}

class _SellerLandingState extends State<SellerLanding> {
  List pages = [
    SellAHouse(StaticInfo.staticHouse, true),
    MyHouses(),
    Chat(),
    Profile(0)
  ];
  int currentSelectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(87.5),
          child: AppBar(
            backgroundColor: Constant.colorsList[3], //centerTitle: true,
            flexibleSpace: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Constant.logoAsset,
                    height: 62.5,
                    width: 62.5,
                  ),
                  Image.asset(
                    Constant.nameAsset,
                    height: 45.0,
                    width: 200.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Card(
          elevation: 21.0,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 10),
            child: BottomNavigationBar(
              currentIndex: currentSelectedPage,
              backgroundColor: Colors.white,
              elevation: 0.0,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Colors.transparent,
//              icon: Icon(Icons.build),
                  title: Text(''),
                  icon:
                      currentSelectedPage == 0 ? activeOne(0) : inActiveIcon(0),
//            activeIcon: activeOne(0),
                ),
                BottomNavigationBarItem(
                  title: Text(''),
                  icon:
                      currentSelectedPage == 1 ? activeOne(1) : inActiveIcon(1),
//            activeIcon: activeOne(1),
//            activeIcon: Text('shiye'),
                ),
                BottomNavigationBarItem(
                  title: Text(''),
                  icon:
                      currentSelectedPage == 2 ? activeOne(2) : inActiveIcon(2),
//            activeIcon: activeOne(2),
                ),
                BottomNavigationBarItem(
                  title: Text(''),
                  icon:
                      currentSelectedPage == 3 ? activeOne(3) : inActiveIcon(3),
//            activeIcon: activeOne(2),
                ),
              ],
              onTap: (index) {
                setState(() {
                  currentSelectedPage = index;
                });
              },
            ),
          ),
        ),
        body: pages[currentSelectedPage],
//    )
      ),
    );
  }

  Widget inActiveIcon(int itemNum) {
    return Image.asset(
      itemNum == 0
          ? Constant.homeAsset
          : itemNum == 1
              ? Constant.starAsset
              : itemNum == 2 ? Constant.chatAsset : Constant.personAsset,
      height: MediaQuery.of(context).size.height / 30,
      width: MediaQuery.of(context).size.height / 30,
    );
  }

  Widget activeOne(int itemNum) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Constant.colorsList[4], width: 1.25)),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 75),
      child: inActiveIcon(itemNum),
    );
  }
}
