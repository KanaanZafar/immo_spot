import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:immospot/models/house.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';

//import 'package:immospot/seller/edit_house.dart';
import 'package:immospot/seller/sellAHouse.dart';

class MyHouses extends StatefulWidget {
  @override
  _MyHousesState createState() => _MyHousesState();
}

class _MyHousesState extends State<MyHouses> {
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  List<String> housesKeys = List<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    readFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constant.colorsList[3],
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 75,
              horizontal: MediaQuery.of(context).size.width / 35),
          child: FirebaseAnimatedList(
            query: dbref.child(Constant.houses),
            sort: (a, b) => b.value[Constant.postingTime]
                .compareTo(a.value[Constant.postingTime]),
            itemBuilder: (ctx, dataSnapshot, anim, index) {
              House house = House.fromMap(dataSnapshot.value);

              if (house.owner == StaticInfo.currentUser.uid)
                return houseWid(house);
            },
          ),
        ),
      ),
    );
  }

  Widget houseWid(House house) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => SellAHouse(house, false),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 75),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 65,
            horizontal: MediaQuery.of(context).size.width / 25),
        height: MediaQuery.of(context).size.height / 5.25,
        decoration: BoxDecoration(
          color: Constant.colorsList[3],
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Constant.colorsList[0], width: 1.5),
          boxShadow: [
            BoxShadow(
                color: Constant.colorsList[2].withOpacity(0.5),
                spreadRadius: 0.5,
                offset: Offset(0.5, 1.0),
                blurRadius: 2.5),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                house.isSold == 'true' ? 'SOLD' : 'ON SALE',
                style: textStyle(5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 9,
                    width: MediaQuery.of(context).size.height / 9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
//                    color: Colors.red,
                      image: DecorationImage(
                          image: NetworkImage(
                            house.picturesList[0],
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 20,
                          ),
                          Text(
                            "${house.rating}",
                            style: textStyle(2),
                          textScaleFactor: 1.25, ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/10),
                        child: Icon(
                          Icons.star,
                          color: Constant.colorsList[1],
                        ),
                      ),
                      Text(
                        "${house.totalRatings} ratings",
                        style: textStyle(1),
                     textScaleFactor: 1.25,  ),
                    ],
                  ),
                  Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle textStyle(int fNum) {
    return TextStyle(
        color: Constant.colorsList[1], fontWeight: Constant.fontweights[fNum]);
  }

/*  readFirebase() {
    /* dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.myHouses)
        .once()
        .then((dataSnapshot) {
      print('==== ${dataSnapshot.value}');
//      Map map = dataSnapshot.value;

        });
 */
    dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.myHouses)
        .onChildAdded
        .listen((event) {
//          if(event.snapshot.){}
//      print('---- ${event.snapshot.value}');

      if (mounted) {
        housesKeys.add(event.snapshot.value);
        setState(() {});
      }
    });
  } */
}
