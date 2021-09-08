import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:immospot/buyer/house_details.dart';
import 'package:immospot/models/house.dart';
import 'package:immospot/models/search.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';

class SearchResults extends StatefulWidget {
  Search search;
  Coordinates coordinates;

  SearchResults(this.search, this.coordinates);

  @override
  _SearchResultsState createState() => _SearchResultsState(search, coordinates);
}

class _SearchResultsState extends State<SearchResults> {
  Search search;
  Coordinates coordinates;

  _SearchResultsState(this.search, this.coordinates);

  DatabaseReference dbref = FirebaseDatabase.instance.reference();

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    readFirebase();

//    print('---- ${search.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constant.colorsList[3],
        appBar: PreferredSize(
          child: reqAppBar(),
          preferredSize: Size.fromHeight(87.5),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 50,
              horizontal: MediaQuery.of(context).size.width / 25),
          child: Column(
            children: [
              firstCon(),
              Expanded(
                child: FirebaseAnimatedList(
                    sort: (a, b) => b.value[Constant.postingTime]
                        .compareTo(a.value[Constant.postingTime]),
                    query: dbref.child(Constant.houses),
                    itemBuilder: (ctx, dataSnapshot, anim, index) {
//                    int isActive;

                      String city = dataSnapshot.value[Constant.city];
                      int beds = dataSnapshot.value[Constant.bedrooms];
                      int price = dataSnapshot.value[Constant.price];

                      if (city
                          .toLowerCase()
                          .contains(search.city.toLowerCase())) {
                        if (search.beds <= 0) {
                          if (search.startingPrice <= 0) {
                            if (search.endingPrice <= 0) {
                              House house = House.fromMap(dataSnapshot.value);
                              return FutureBuilder(
                                  future: checkIfDeactivateOrNot(house.owner),
                                  builder: (ctx, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.data == 0) {
                                      return Container();
                                    }
                                    return houseWid(house);
                                  });
                            } else {
                              if (price < search.endingPrice) {
                                House house = House.fromMap(dataSnapshot.value);
                                return FutureBuilder(
                                    future: checkIfDeactivateOrNot(house.owner),
                                    builder: (ctx, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data == 0) {
                                        return Container();
                                      }
                                      return houseWid(house);
                                    });
                              }
                              return Container();
                            }
                          } else {
                            if (search.endingPrice <= 0) {
                              if (price > search.startingPrice) {
                                House house = House.fromMap(dataSnapshot.value);
                                return FutureBuilder(
                                    future: checkIfDeactivateOrNot(house.owner),
                                    builder: (ctx, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data == 0) {
                                        return Container();
                                      }
                                      return houseWid(house);
                                    });
                              }
                              return Container();
                            } else {
                              if (price >= search.startingPrice &&
                                  price <= search.endingPrice) {
                                House house = House.fromMap(dataSnapshot.value);
                                return FutureBuilder(
                                    future: checkIfDeactivateOrNot(house.owner),
                                    builder: (ctx, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data == 0) {
                                        return Container();
                                      }
                                      return houseWid(house);
                                    });
                              }
                              return Container();
                            }
                          }
                        } else {
                          if (beds == search.beds) {
                            if (search.startingPrice <= 0) {
                              if (search.endingPrice <= 0) {
                                House house = House.fromMap(dataSnapshot.value);
                                return FutureBuilder(
                                    future: checkIfDeactivateOrNot(house.owner),
                                    builder: (ctx, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.data == 0) {
                                        return Container();
                                      }
                                      return houseWid(house);
                                    });
                              } else {
                                if (price < search.endingPrice) {
                                  House house =
                                      House.fromMap(dataSnapshot.value);
                                  return FutureBuilder(
                                      future:
                                          checkIfDeactivateOrNot(house.owner),
                                      builder: (ctx, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data == 0) {
                                          return Container();
                                        }
                                        return houseWid(house);
                                      });
                                }
                                return Container();
                              }
                            } else {
                              if (search.endingPrice <= 0) {
                                if (price > search.startingPrice) {
                                  House house =
                                      House.fromMap(dataSnapshot.value);
                                  return FutureBuilder(
                                      future:
                                          checkIfDeactivateOrNot(house.owner),
                                      builder: (ctx, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data == 0) {
                                          return Container();
                                        }
                                        return houseWid(house);
                                      });
                                }
                                return Container();
                              } else {
                                if (price >= search.startingPrice &&
                                    price <= search.endingPrice) {
                                  House house =
                                      House.fromMap(dataSnapshot.value);
                                  return FutureBuilder(
                                      future:
                                          checkIfDeactivateOrNot(house.owner),
                                      builder: (ctx, snapshot) {
                                        if (!snapshot.hasData ||
                                            snapshot.data == 0) {
                                          return Container();
                                        }
                                        return houseWid(house);
                                      });
                                }
                                return Container();
                              }
                            }
                          }
                          return Container();
                        }
                      }
                      /*   if (city
                              .toLowerCase()
                              .contains(search.city.toLowerCase()) ||
                          (beds == search.beds &&
                              price > search.startingPrice)) {
                        if (search.endingPrice > 0) {
                          if (price < search.endingPrice) {
                            House house = House.fromMap(dataSnapshot.value);
                            return FutureBuilder(
                                future: checkIfDeactivateOrNot(house.owner),
                                builder: (ctx, snapshot) {
                                  if (!snapshot.hasData || snapshot.data == 0) {
                                    return Container();
                                  }
                                  return houseWid(house);
                                });
                          } else {
                            return Container();
                          }
                        } else {
                          House house = House.fromMap(dataSnapshot.value);
                          return FutureBuilder(
                              future: checkIfDeactivateOrNot(house.owner),
                              builder: (ctx, snapshot) {
                                if (!snapshot.hasData || snapshot.data == 0) {
                                  return Container();
                                }
                                return houseWid(house);
                              });
                        }
                      } */
                      return Container();
                      House house = House.fromMap(dataSnapshot.value);

                      return FutureBuilder(
                          future: checkIfDeactivateOrNot(house.owner),
                          builder: (ctx, snapshot) {
                            if (!snapshot.hasData || snapshot.data == 0) {
                              return Container();
                            }
//                          print();
                            return houseWid(house);
                          });
//                          return houseWid(house);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<int> checkIfDeactivateOrNot(String houseOwner) async {
    DataSnapshot dataSnapshot = await dbref
        .child(Constant.users)
        .child(houseOwner)
        .child(Constant.isActive)
        .once();
//if(dataSnapshot.value){}
    return dataSnapshot.value;
  }

  Future<bool> initalizeBool(String houseId) async {
    DataSnapshot dataSnapshot = await dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.savedHouses)
        .child(houseId)
        .once();
    if (dataSnapshot.value == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<int> calculateDistance(double lat, double lang) async {
    double dist = await Geolocator().distanceBetween(
        coordinates.latitude, coordinates.longitude, lat, lang);
    dist = dist / 1000;
    return dist.toInt();
  }

  Widget houseWid(House house) {
    bool isSaved;
    int totalDistance;
    return GestureDetector(
      onTap: () async {
        House abc = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => HouseDetails(house, isSaved, totalDistance)));
      },
      child: outerCon(
          false,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: initalizeBool(house.houseId),
                builder: (ctx, asyncSnapShot) {
                  if (!asyncSnapShot.hasData) {
                    return Container();
                  }
                  isSaved = asyncSnapShot.data;
                  return GestureDetector(
                    onTap: () async {
                      if (asyncSnapShot.data == false) {
                        await dbref
                            .child(Constant.users)
                            .child(StaticInfo.currentUser.uid)
                            .child(Constant.savedHouses)
                            .update({house.houseId: house.houseId});
                      } else {
                        await dbref
                            .child(Constant.users)
                            .child(StaticInfo.currentUser.uid)
                            .child(Constant.savedHouses)
                            .child(house.houseId)
                            .remove();
                      }
                      setState(() {
                        isSaved = asyncSnapShot.data;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          asyncSnapShot.data == false
                              ? Constant.skinHeart
                              : Constant.skinFilled,
                          height: MediaQuery.of(context).size.width / 10,
                          width: MediaQuery.of(context).size.width / 10,
                        ),
                        Text(
                          asyncSnapShot.data == false ? 'save' : 'saved',
                          style: textStyle(1),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Container(
//                height: MediaQuery.of(context).size.height / 9,
//                width: MediaQuery.of(context).size.height / 9,
                height: MediaQuery.of(context).size.width / 5,
                width: MediaQuery.of(context).size.width / 5,
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
                      Icon(
                        Icons.star_border,
                        color: Constant.colorsList[2],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 35,
                      ),
                      Text(
                        '${house.rating}',
                        style: textStyle(1),
                        textScaleFactor: 1.25,
                      ),
                    ],
                  ),
                  Text(
                    house.totalRatings < 2
                        ? '${house.totalRatings} rating'
                        : '${house.totalRatings} ratings',
                    style: textStyle(2),
                    textScaleFactor: 1.125,
                  ),
                ],
              ),
              FutureBuilder(
                future: calculateDistance(house.lat, house.lang),
                builder: (ctx, snapShot) {
                  if (!snapShot.hasData) {
                    return Container();
                  }
                  totalDistance = snapShot.data;
                  return Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Constant.colorsList[2],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 100,
                      ),
                      Text(
                        '${snapShot.data} KM',
                        style: textStyle(2),
                      ),
                    ],
                  );
                },
              ),
            ],
          )),
    );
  }

/*
  checkSave(String houseId) async {
    DataSnapshot dataSnapshot = await dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.savedHouses)
        .child(houseId)
        .once();
    if (dataSnapshot.value != null) {
      return true;
    } else {
      return false;
    }
  } */

  Widget firstCon() {
    return outerCon(
        true,
        Center(
          child: Table(
            columnWidths: {
              0: FractionColumnWidth(.4),
              1: FractionColumnWidth(.6)
            },
            children: [
              tableRow("CITY:", search.city),
              tableRow("BEDROOMS:",
                  search.beds == -1 ? '0' : search.beds.toString()),
              tableRow("PRICE RANGE:",
                  "${search.startingPrice == -1 ? 0 : search.startingPrice} - ${search.endingPrice == -1 ? 0 : search.endingPrice}")
            ],
          ),
        ));
  }

  TableRow tableRow(String txt0, String txt1) {
    return TableRow(children: [
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 200),
        child: Text(
          txt0,
          style: textStyle(4),
          textScaleFactor: 1.25,
          textAlign: TextAlign.end,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 50,
            top: MediaQuery.of(context).size.height / 200,
            bottom: MediaQuery.of(context).size.height / 200),
        child: Text(
          txt1,
          style: textStyle(1),
          textScaleFactor: 1.125,
          textAlign: TextAlign.start,
        ),
      ),
    ]);
  }

  TextStyle textStyle(int fNum) {
    return TextStyle(
        color: Constant.colorsList[2], fontWeight: Constant.fontweights[fNum]);
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
                  Navigator.pop(context);
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
