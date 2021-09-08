import 'package:flutter/material.dart';
import 'package:immospot/buyer/favorites.dart';
import 'package:immospot/buyer/find_house.dart';
import 'package:immospot/chats/chat.dart';
import 'package:immospot/profile/profile.dart';
import 'package:immospot/res/constants.dart';

class BuyerLanding extends StatefulWidget {
  @override
  _BuyerLandingState createState() => _BuyerLandingState();
}

class _BuyerLandingState extends State<BuyerLanding> {
  List pages = [FindHouse(), Favorites(), Chat(), Profile(1)];
  int currentSelectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constant.colorsList[3],
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
                  Image.asset(Constant.nameAsset, width: 200.0, height: 45.0,),
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
                  title: Text(''),
                  icon:
                      currentSelectedPage == 0 ? activeOne(0) : inActiveIcon(0),
                ),
                BottomNavigationBarItem(
                  title: Text(''),
                  icon:
                      currentSelectedPage == 1 ? activeOne(1) : inActiveIcon(1),
                ),
                BottomNavigationBarItem(
                  title: Text(''),
                  icon:
                      currentSelectedPage == 2 ? activeOne(2) : inActiveIcon(2),
                ),
                BottomNavigationBarItem(
                  title: Text(''),
                  icon:
                      currentSelectedPage == 3 ? activeOne(3) : inActiveIcon(3),
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
      ),
    );
  }

  Widget inActiveIcon(int itemNum) {
    /* return Icon(
      itemNum == 0
          ? Icons.home
          : itemNum == 1
              ? Icons.star
              : itemNum == 2 ? Icons.chat_bubble : Icons.person,
      color: Constant.colorsList[2],
    ); */
    return Image.asset(itemNum == 0
        ? Constant.homeAsset
        : itemNum == 1
            ? Constant.blackHeart
            : itemNum == 2 ? Constant.chatAsset : Constant.personAsset,
      height: MediaQuery.of(context).size.height/30,
      width: MediaQuery.of(context).size.height/30,
//fit: BoxFit.fill,
    );
  }

  Widget activeOne(int itemNum) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Constant.colorsList[4], width: 1.25)),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height /75),
      child: inActiveIcon(itemNum),
    );
  }
}
