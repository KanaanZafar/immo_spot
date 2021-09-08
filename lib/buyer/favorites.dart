import 'package:after_init/after_init.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:immospot/buyer/house_details.dart';
import 'package:immospot/models/house.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';
import 'package:location/location.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> with AfterInitMixin<Favorites> {
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  List<House> housesList = List<House>();
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  int totalDistance;
  List<dynamic> houseIds = List<dynamic>();

//  Address first;
  Coordinates coordinates;

//  List<Address> addresses;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFirebase();
    locRelatedBakcHodi();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('deactivate called');
  }

  @override
  void didInitState() {
    // TODO: implement didInitState
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Constant.colorsList[3],
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 50,
            horizontal: MediaQuery.of(context).size.width / 25),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
//            return Text('${housesList[index].houseId}');
            return houseWid(housesList[index]);
          },
          itemCount: housesList.length,
        ),
      ),
    ));
  }

  readFirebase() {
    bakchodi();
    dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.savedHouses)
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        dbref
            .child(Constant.houses)
            .child(event.snapshot.value)
            .once()
            .then((dataSnapshot) {
          if (dataSnapshot.value != null) {
            House _house = House.fromMap(dataSnapshot.value);
//            housesList.add(House.fromMap(dataSnapshot.value));

            if (_house.isSold != 'true') {
              housesList.add(_house);
              setState(() {});
            } else {
              dbref
                  .child(Constant.users)
                  .child(Constant.savedHouses)
                  .child(event.snapshot.value)
                  .remove();
            }
          } else {
            dbref
                .child(Constant.users)
                .child(Constant.savedHouses)
                .child(event.snapshot.value)
                .remove();
          }
        });
      }
    });
  }

  bakchodi() {
    dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.savedHouses)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map map = event.snapshot.value;
        houseIds = map.keys.toList();
      } else {
        houseIds.clear();
      } //      keys = houseIds;
      //      print('keys: ${keys}');
    });
  }

  TextStyle textStyle(int fNum) {
    return TextStyle(
        color: Constant.colorsList[2], fontWeight: Constant.fontweights[fNum]);
  }

  Widget houseWid(House house) {
    return GestureDetector(
      onTap: () async {
        if (totalDistance != null)
          house = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => HouseDetails(house, true, totalDistance)));
//     if(){}
        if (!houseIds.contains(house.houseId)) {
          housesList.remove(house);
        }
        setState(() {});
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 100),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 75,
            horizontal: MediaQuery.of(context).size.width / 25),
        decoration: BoxDecoration(
            color: Constant.colorsList[3],
            border: Border.all(color: Constant.colorsList[4], width: 1.5),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: Constant.colorsList[2].withOpacity(0.5),
                  spreadRadius: 0.5,
                  offset: Offset(0.5, 1.0),
                  blurRadius: 2.5),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                /*  await dbref
                    .child(Constant.users)
                    .child(StaticInfo.currentUser.uid)
                    .child(Constant.savedHouses)
                    .child(house.houseId)
                    .remove();
                housesList.remove(house);
                setState(() {}); */
              },
              child: Column(
                children: [
//                Icon(
//                  Icons.visibility,
//                  color: Constant.colorsList[0],
//                ),
//                      SizedBox(height: MediaQuery.of(context).size.height/100,),
                  Image.asset(
                    Constant.skinFilled,
                    height: MediaQuery.of(context).size.width / 15,
                    width: MediaQuery.of(context).size.width / 15,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 200,
                  ),
                  Text(
                    'saved',
                    style: textStyle(1),
                  ),
                ],
              ),
            ),
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
            coordinates != null
                ? FutureBuilder(
                    future: calculateDistance(house.lat, house.lang),
                    builder: (ctx, snapShot) {
                      if (!snapShot.hasData) {
                        return Container();
                      }
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
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Constant.colorsList[2],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 100,
                      ),
                      Text(
                        'Allow Location',
                        style: textStyle(2),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<int> calculateDistance(double lat, double lang) async {
    double dist = await Geolocator().distanceBetween(
        coordinates.latitude, coordinates.longitude, lat, lang);
    dist = dist / 1000;
    totalDistance = dist.toInt();
//    return dist.toInt();
    return totalDistance;
  }

  locRelatedBakcHodi() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
//        setState(() {
//          proceeding = false;
//        });
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
    if (_permissionGranted == PermissionStatus.granted) {
      _locationData = await location.getLocation();
      coordinates =
          Coordinates(_locationData.latitude, _locationData.longitude);
    }
    setState(() {});
  }
}
