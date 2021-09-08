import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immospot/buyer/show_pictures.dart';
import 'package:immospot/chats/show_messages.dart';
import 'package:immospot/models/house.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';

class HouseDetails extends StatefulWidget {
//  Widget reqAppBar;
  House house;
  bool isSaved;
  int distance;

  HouseDetails(
      //this.reqAppBar,
      this.house,
      this.isSaved,
      this.distance);

  @override
  _HouseDetailsState createState() => _HouseDetailsState(
      //reqAppBar,
      house,
      isSaved,
      distance);
}

class _HouseDetailsState extends State<HouseDetails> {
//  Widget reqAppBar;
  House house;
  bool isSaved;
  int distance;

  _HouseDetailsState(
      //this.reqAppBar,
      this.house,
      this.isSaved,
      this.distance);

  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, house);
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: PreferredSize(
              child: reqAppBar(), preferredSize: Size.fromHeight(87.5)),
          body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 50,
                horizontal: MediaQuery.of(context).size.width / 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  housePics(),
                  secCon(),
                  contactDetails(),
                  rateThisHouse()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyle(int fNum) {
    return TextStyle(
      color: Constant.colorsList[1],
      fontWeight: Constant.fontweights[fNum],
    );
  }

  Widget housePics() {
    return outerCon(
        true,
        Column(
          children: [
            Text(
              'HOUSE PICTURES',
              style: textStyle(4),
              textScaleFactor: 1.125,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: picsRow(),
            ),
          ],
        ));
  }

  Widget secCon() {
    return outerCon(
        false,
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 100),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                  onTap: () async {
//                    print('tapped');
                    if (isSaved) {
                      await dbref
                          .child(Constant.users)
                          .child(StaticInfo.currentUser.uid)
                          .child(Constant.savedHouses)
                          .child(house.houseId)
                          .remove();
                    } else {
                      await dbref
                          .child(Constant.users)
                          .child(StaticInfo.currentUser.uid)
                          .child(Constant.savedHouses)
                          .update({house.houseId: house.houseId});
                    }
                    setState(() {
                      isSaved = !isSaved;
                    });
                  },
                  child: reqMiniCol(
//                    Icon(
//                      isSaved ? Icons.visibility_off : Icons.visibility,
//                      color: Constant.colorsList[2],
//                    ),
                      Image.asset(
                        isSaved ? Constant.blackFilled : Constant.blackHeart,
//                      height: MediaQuery.of(context).size.height / 30,
//                      width: MediaQuery.of(context).size.height / 30,
                        height: 25.0, width: 25.0,
                      ),
                      Text(
                        isSaved ? 'saved' : 'not saved',
                        style: textStyle(2),
                      )),
                ),
                reqMiniCol(
                    Row(
                      children: [
                        Icon(
                          Icons.star_border,
                          color: Constant.colorsList[2],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 50,
                        ),
                        Text(
                          '${house.rating}',
                          style: textStyle(2),
                        ),
                      ],
                    ),
                    Text('${house.totalRatings} ratings')),
                reqMiniCol(
                    Icon(
                      Icons.location_on,
                      color: Constant.colorsList[2],
                    ),
                    Text(distance != null ? '${distance} KM' : ''))
              ]),
              SizedBox(
                height: MediaQuery.of(context).size.height / 100,
              ),
//           richText("City", house.city),
//            richText('Bedrooms', "${house.bedrooms}")
              Table(
//                border: TableBorder.all(color: Colors.red),
                columnWidths: {
                  0: FractionColumnWidth(.3),
                  1: FractionColumnWidth(.775),
                },

                children: [
                  tableRow('City:', house.city),
                  tableRow('Bedrooms:', '${house.bedrooms}'),
                  tableRow('Asking Price:', "${house.price}"),
                  tableRow('Address:', house.address)
                ],
              )
            ],
          ),
        ));
  }

  TableRow tableRow(String txt0, String txt1) {
    return TableRow(children: [
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 300),
        child: Text(
          "${txt0}",
          textScaleFactor: 1.125,
          style: textStyle(5),
          textAlign: TextAlign.end,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 300,
            horizontal: MediaQuery.of(context).size.width / 50),
        child: Text(
          "${txt1}",
          textScaleFactor: 1.125,
          style: textStyle(1),
          textAlign: TextAlign.start,
        ),
      ),
    ]);
  }

  Widget reqMiniCol(Widget firstWid, Widget secWid) {
    return Column(
      children: [
        firstWid,
        SizedBox(
          height: MediaQuery.of(context).size.height / 100,
        ),
        secWid
      ],
    );
  }

  Widget picsRow() {
    List<Widget> tmp = List<Widget>();
    for (int i = 0; i < house.picturesList.length; i++) {
      tmp.add(reqpic(i));
    }
    return Row(
      children: tmp,
    );
  }

  Widget reqpic(int picNum) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) =>
                    ShowPictures(reqAppBar(), house.picturesList, picNum)));
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 10.5,
        width: MediaQuery.of(context).size.height / 10.5,
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 50),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(
                house.picturesList[picNum],
              ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget contactDetails() {
    return outerCon(
      false,
      Column(
        children: [
          Text(
            'CONTACT DETAILS',
            style: textStyle(4),
            textScaleFactor: 1.25,
          ),
          Table(
            columnWidths: {
              0: FractionColumnWidth(.2),
              1: FractionColumnWidth(.8)
            },
            children: [
              tableRow('Name:', house.name),
              tableRow('Number:', house.phoneNum),
              tableRow('Email:', house.email)
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 100,
          ),
          house.owner != StaticInfo.currentUser.uid
              ? RaisedButton(
                  onPressed: () async {
                    if (StaticInfo.isActive == 1) {
                      String userName = '';
                      String playerId = '';
                      await FirebaseDatabase.instance
                          .reference()
                          .child(Constant.users)
                          .child(house.owner)
//                          .child(Constant.name)
                          .once()
                          .then((dataSnapshot) {
                        userName = dataSnapshot.value[Constant.name];
                        playerId = dataSnapshot.value[Constant.playerId];
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  ShowMessages(house.owner, userName, playerId)));
                    } else {
                      showSnackBar("Please activate your account first");
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                          color: Constant.colorsList[1], width: 1.25)),
                  color: Constant.colorsList[3],
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 75),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(),
                        Container(),
                        Text(
                          'SEND MESSAGE',
                          style: textStyle(1),
                          textScaleFactor: 1.125,
                        ),
                        Icon(
                          Icons.send,
                          color: Constant.colorsList[1],
                        ),
                        Container()
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget rateThisHouse() {
    return outerCon(
        false,
        Column(
          children: [
            Text(
              'RATE THIS HOUSE',
              style: textStyle(4),
              textScaleFactor: 1.25,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 500,
            ),
            FutureBuilder(
              future: checkprevRating(),
              builder: (ctx, snapShot) {
                if (!snapShot.hasData) {
                  return Container();
                }
                List<Widget> tmp = List<Widget>.generate(
                    5,
                    (index) => reqIcon(
                        snapShot.data - 1 >= index ? false : true, index));
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: tmp,
                );
              },
            ),
          ],
        ));
  }

  Widget reqIcon(bool isHalf, int iconNum) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 100),
      child: IconButton(
          icon: Icon(
            isHalf ? Icons.star_border : Icons.star,
            size: MediaQuery.of(context).size.height / 20,
            color: Constant.colorsList[2],
          ),
          onPressed: () async {
            int prevRating = await checkprevRating();
            if (prevRating < 1) {
              house.totalRatings = house.totalRatings + 1;
              await dbref
                  .child(Constant.houses)
                  .child(house.houseId)
                  .update({Constant.totalRatings: house.totalRatings});
            }
            if (house.totalRatings < 2) {
              house.rating = (iconNum + 1).toDouble();
            } else {
              house.rating = house.rating + iconNum + 1;
              house.rating = house.rating / 2;
            }
            await dbref
                .child(Constant.houses)
                .child(house.houseId)
                .update({Constant.rating: house.rating});

            await dbref
                .child(Constant.users)
                .child(StaticInfo.currentUser.uid)
                .child(Constant.ratedHouses)
                .update({house.houseId: (iconNum + 1).toDouble()});

            setState(() {});
          }),
    );
  }

  Widget outerCon(bool is1st, Widget wid) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          vertical: is1st ? totalHeight / 50 : totalHeight / 100),
      padding: EdgeInsets.symmetric(
          vertical: totalHeight / 75, horizontal: totalWidth / 25),
      decoration: BoxDecoration(
          color: Constant.colorsList[3],
          border:
              Border.all(color: Constant.colorsList[is1st ? 0 : 4], width: 1.5),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
                color: Constant.colorsList[2].withOpacity(0.5),
                spreadRadius: 0.5,
                offset: Offset(0.5, 1.0),
                blurRadius: 2.5),
          ]),
      child: wid,
    );
  }

  Future<int> checkprevRating() async {
    DataSnapshot dataSnapshot = await dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.ratedHouses)
        .child(house.houseId)
        .once();
    if (dataSnapshot.value == null) {
      return -1;
    } else {
      return dataSnapshot.value;
    }
  }

  showSnackBar(String msg) {
    SnackBar snackBar = SnackBar(content: Text(msg));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget reqAppBar() {
    return AppBar(
      backgroundColor: Constant.colorsList[3],
      flexibleSpace: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Constant.colorsList[3],
                shape: BoxShape.circle,
                border: Border.all(color: Constant.colorsList[4]),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Constant.colorsList[1],
                ),
                onPressed: () {
                  Navigator.pop(context, house);
                },
              ),
            ),
            Row(
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
//                   Container()
            Container(
              color: Colors.transparent,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.transparent,
                  ),
                  onPressed: null),
            ),
          ],
        ),
      ),
    );
  }
}
