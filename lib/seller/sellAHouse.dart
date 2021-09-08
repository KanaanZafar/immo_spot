import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immospot/models/house.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';
import 'package:immospot/seller/seller_landing.dart';
import 'package:immospot/seller/show_map.dart';
import 'package:location/location.dart';
import 'package:string_validator/string_validator.dart';
import 'package:toast/toast.dart';

class SellAHouse extends StatefulWidget {
  House house;
  bool fromLandingPage;

  SellAHouse(this.house, this.fromLandingPage);

  @override
  _SellAHouseState createState() => _SellAHouseState(house, fromLandingPage);
}

class _SellAHouseState extends State<SellAHouse> {
  House house;
  bool fromLandingPage;

  _SellAHouseState(this.house, this.fromLandingPage);

  BoxDecoration greenBorder = BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      border: Border.all(
        color: Constant.colorsList[4],
        width: 1.75,
      ),
      color: Constant.colorsList[3]);

  List<File> filesList = List<File>.generate(8, (generator) => null);

  List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          6, (generator) => TextEditingController());

  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.0),
    borderSide: BorderSide(color: Constant.colorsList[4], width: 1.75),
  );
  List<int> pics = List<int>();
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Address first;
  Coordinates coordinates;
  List<Address> addresses;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool processing = false;
  DatabaseReference dbref = FirebaseDatabase.instance.reference();
  bool changesMade = false;
  bool screenLoaded = false;
  String processingString = '';

//  DatabaseReference dbref = FirebaseDatabase.instance.reference();
//  StorageReference storageReference = FirebaseStorage().ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//  print('++++ ${StaticInfo.staticHouse.toString()}');
    if (house != null && house.houseId != null) {
      coordinates = Coordinates(house.lat, house.lang);
      controllers[0].text = '${house.price}';
      controllers[1].text = '${house.bedrooms}';
      controllers[2].text = '${house.address}';
      controllers[3].text = '${house.name}';
      controllers[4].text = '${house.phoneNum}';
      controllers[5].text = '${house.email}';
      fillsmallVariables();
    } else {
      setState(() {
        screenLoaded = true;
      });
    }
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return screenLoaded == true
        ? WillPopScope(
            onWillPop: fromLandingPage == true
                ? null
                : () {
                    dealMovingBack();
                  },
            child: SafeArea(
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Constant.colorsList[3],
                appBar: fromLandingPage != true
                    ? PreferredSize(
                        child: AppBar(
                          backgroundColor: Constant.colorsList[3],
//                  leading: ,
                          flexibleSpace: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
//                          margin: EdgeInsets.only(top: 10.0, left: 10.0),
                                  decoration: BoxDecoration(
                                    color: Constant.colorsList[3],
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Constant.colorsList[4]),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Constant.colorsList[1],
                                    ),
                                    onPressed: () {
                                      dealMovingBack();
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
                                    Image.asset(Constant.nameAsset, height: 45.0, width: 200.0,),
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
                        ),
                        preferredSize: Size.fromHeight(87.5),
                      )
                    : PreferredSize(
                        child: Container(),
                        preferredSize: Size.fromHeight(0.1)),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 75,
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            attachPics(),
                            cityAndZip(),
                            askingPrice(),
                            totalBedRooms(),
                            houseAddress(),
                            contactInfo(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 12),
                              child: processing == false
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(),
                                        house.houseId == null
                                            ? btn(0, "POST HOUSE")
                                            : Column(
                                                children: [
                                                  btn(
                                                      1,
                                                      house.isSold == 'false'
                                                          ? "MARK AS SOLD"
                                                          : "MARK AS UNSOLD"),
                                                  btn(2, "DELETE HOUSE"),
                                                  btn(0, "UPDATE POST")
                                                ],
                                              ),
                                        Container()
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          processingString,
                                          style: textStyle(3),
                                          textScaleFactor: 1.25,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20,
                                        ),
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Constant.colorsList[4]),
                                        )
                                      ],
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  TextStyle textStyle(int fNum) {
    return TextStyle(
        color: Constant.colorsList[2], fontWeight: Constant.fontweights[fNum]);
  }

  Widget outerCon(Widget childWid) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Constant.colorsList[0],
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
              color: Constant.colorsList[2].withOpacity(0.5),
              spreadRadius: 0.5,
              offset: Offset(0.5, 1.0),
              blurRadius: 2.5),
        ],
      ),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 50,
          horizontal: MediaQuery.of(context).size.width / 20),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20,
          vertical: MediaQuery.of(context).size.height / 50),
      child: childWid,
    );
  }

  Widget attachPics() {
    List<Widget> tmp = List<Widget>();
    for (int i = 0; i < 8; i++) {
      tmp.add(picCircle(i));
    }

    return outerCon(
      Column(
        children: <Widget>[
          reqTxt('Attach Pictures'),
          spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tmp,
            ),
          )
        ],
      ),
    );
  }

  Widget picCircle(int cirNum) {
    return GestureDetector(
      onTap: () {
        getImage(cirNum);
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 12.5,
        width: MediaQuery.of(context).size.height / 12.5,
        margin: EdgeInsets.only(
            left: cirNum == 0 ? 0.1 : MediaQuery.of(context).size.width / 50,
            right: cirNum == 7 ? 0.1 : MediaQuery.of(context).size.width / 50),
        decoration: filesList[cirNum] == null
            ? house.houseId != null && house.picturesList.length > cirNum
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                          house.picturesList[cirNum],
                        ),
                        fit: BoxFit.cover),
                  )
                : BoxDecoration(
                    shape: BoxShape.circle,
                    color: Constant.colorsList[3],
                    border: Border.all(
                      color: Constant.colorsList[4],
                    ),
                  )
            : BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: FileImage(
                      filesList[cirNum],
                    ),
                    fit: BoxFit.cover),
              ),
        child: filesList[cirNum] != null
            ? Container()
            : house.houseId != null && house.picturesList.length > cirNum
                ? Container()
                : Center(
                    child: Icon(
                      Icons.add,
                      color: Constant.colorsList[4],
                    ),
                  ),
      ),
    );
  }

  navigation() async {
    Coordinates abc = await Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => ShowMap(coordinates)));
    if (abc != null) {
      coordinates = abc;
//            first = coordinates.
//            addresses = setState(() {});
      await fillsmallVariables();
    }
  }

  Widget cityAndZip() {
    return GestureDetector(
      onTap: () async {
        if (coordinates != null) {
          navigation();
        } else {
          await locRelatedBakcHodi();
          if (coordinates != null) {
            navigation();
          }
        }
        if (changesMade != true) changesMade = true;
        setState(() {});
      },
      child: outerCon(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              reqTxt('   City'),
              spacer(),
              Container(
                decoration: greenBorder,
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width / 4.75,
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: MediaQuery.of(context).size.width / 40,
                ),
                child: Text(
                  first == null
                      ? ''
                      : "${first.locality == null ? first.adminArea : first.locality}",
                  style: textStyle(0),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget askingPrice() {
    return outerCon(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              reqTxt("   Asking Price"),
              spacer(),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: reqField(0),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              reqTxt("  Currency"),
              spacer(),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 40,
                    vertical: 17.5),
                decoration: greenBorder,
                child: Text('EURO'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget totalBedRooms() {
    return outerCon(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        reqTxt(
          "   Total Bedrooms",
        ),
        spacer(),
        reqField(1),
      ],
    ));
  }

  Widget houseAddress() {
    return outerCon(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        reqTxt("   House Address"),
        spacer(),
        reqField(2),
      ],
    ));
  }

  Widget contactInfo() {
    return outerCon(Column(
      children: <Widget>[
        Text(
          'CONTACT INFORMATION',
          textScaleFactor: 1.25,
          style: textStyle(5),
        ),
//        reqTxt("CONTACT INFORMATION"),
        spacer(),
        miniCol(3, "   Full Name"),
        miniCol(4, "   Phone Number"),
        miniCol(5, "   Email"),
      ],
    ));
  }

  Widget btn(int btnNum, String btnName) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 100),
      child: RaisedButton(
        onPressed: () async {
          if (btnNum == 0) {
            await pics.sort((a, b) => a.compareTo(b));
            if (formKey.currentState.validate()) {
              if (coordinates != null) {
                if (pics.length > 2 || house.houseId != null) {
                  postHouse();
                } else {
                  showSnackBar("Atleast insert 3 pictures");
                }
              } else {
                showSnackBar("Please enter your city");
              }
            }
          } else if (btnNum == 1) {
//            house.isSold = 'true';
            setState(() {
              processingString = 'Marking';
              processing = true;
            });
            //mark as sold
            await dbref.child(Constant.houses).child(house.houseId).update(
                {Constant.isSold: house.isSold == 'false' ? "true" : "false"});
            setState(() {
              house.isSold = house.isSold == 'false' ? 'true' : 'false';
              StaticInfo.staticHouse.isSold = house.isSold;
              processing = false;
            });
          } else {
//            house.picturesList.forEach((element) {
//              element = '';
//            });
            setState(() {
              processingString = 'Deleting';
              processing = true;
            });
            await dbref.child(Constant.houses).child(house.houseId).remove();
            await dbref
                .child(Constant.users)
                .child(StaticInfo.currentUser.uid)
                .child(Constant.myHouses)
                .child(house.houseId)
                .remove();
//         await stor
            /*       StorageReference storageReference = FirebaseStorage()
                .ref()
                .child(Constant.houses)
//        .child(house.owner)
                .child("${house.houseId}");
//            await storageReference.delete();
            Directory dir = Directory(storageReference.path);
            dir.delete();
   */
            StorageReference storageReference = FirebaseStorage()
                .ref()
                .child(Constant.houses)
//        .child(house.owner)
                .child("${house.houseId}");
            for (int i = 0; i < house.picturesList.length; i++) {
              await storageReference.child("${i}").delete();
            }

            StaticInfo.staticHouse = null;
            StaticInfo.staticHouse = House();
            setState(() {
              processing = false;
            });

            if (fromLandingPage != true) {
              Navigator.pop(context);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (ctx) => SellerLanding()),
                  (a) => false);
            }
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Constant.colorsList[4],
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 50,
//          horizontal: MediaQuery.of(context).size.width / 6,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Center(
            child: Text(
              btnName,
              textScaleFactor: 1.5,
              style: TextStyle(
                color: Constant.colorsList[3],
                fontWeight: Constant.fontweights[5],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget miniCol(int fieldNum, String headingName) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height / 200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          reqTxt(headingName),
          reqField(fieldNum),
        ],
      ),
    );
  }

  Widget reqField(int conNum) {
    return TextFormField(
      controller: controllers[conNum],
      decoration: InputDecoration(
        fillColor: Constant.colorsList[3],
        filled: true,
        border: outlineInputBorder,
        disabledBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        errorBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
        hintText: "",
//        errorStyle: textStyle(1),
      ),
      keyboardType: conNum == 0 || conNum == 1
          ? TextInputType.number
          : conNum == 4
              ? TextInputType.phone
              : conNum == 5 ? TextInputType.emailAddress : TextInputType.text,
      onChanged: (txt) {
        if (changesMade != true) {
          changesMade = true;
//          setState(() {});
        }
      },
      validator: (txt) {
        if (changesMade != true) {
          changesMade = true;
//          setState(() {});
        }
        if (conNum == 0 || conNum == 1) {
          if (!isNumeric(txt)) {
            return "Numbers only please";
          }
        } else if (conNum == 2 || conNum == 3) {
          if (txt == '') {
            return "Please fill these fields";
          }
        } else if (conNum == 4) {
           if (isNumeric(txt)) {
          } else {
            return "Invalid phone number";
          }
        } else {
          if (!isEmail(txt)) {
            return "Invalid Email Address";
          }
        }
      },
      maxLines: conNum == 2 ? null : 1,
    );
  }

  Widget spacer() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 50,
    );
  }

  Widget reqTxt(String txt) {
    return Text(
      txt,
      textScaleFactor: 1.25,
      style: textStyle(2),
    );
  }

  locRelatedBakcHodi() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
    if (_permissionGranted == PermissionStatus.granted) {
      _locationData = await location.getLocation();
//        print('++ ${_locationData}');
      coordinates =
          Coordinates(_locationData.latitude, _locationData.longitude);
      fillsmallVariables();
//        print("+++++  ${first.addressLine} ");
    } else {
//        print('not granted');
    }
  }

  fillsmallVariables() async {
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
//    print(
//        'firstmap: ${first.toMap()}');

    controllers[2].text = first.addressLine;
    if (screenLoaded != true) {
      screenLoaded = true;
    }
    setState(() {});
  }

  getImage(int fileNum) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (!pics.contains(fileNum)) {
        pics.add(fileNum);
      }
      setState(() {
        filesList[fileNum] = image;
        if (changesMade != true) {
          changesMade = true;
        }
      });
    }
  }

  postHouse() async {
    setState(() {
      processingString = house.houseId == null ? 'Posting' : 'Updating';
      processing = true;
    });
    House tempHouse = House();
//    tempHouse.houseId = DateTime.now().millisecondsSinceEpoch;
    tempHouse.picturesList = List<String>();

    if (house.houseId == null) {
      tempHouse.houseId = dbref.push().key;
      tempHouse.postingTime = DateTime.now().millisecondsSinceEpoch;
      tempHouse.owner = StaticInfo.currentUser.uid;
      tempHouse.isSold = "false";
    } else {
      tempHouse.houseId = house.houseId;
      tempHouse.postingTime = house.postingTime;
      tempHouse.owner = house.owner;
      tempHouse.isSold = house.isSold;
      for (int i = 0; i < house.picturesList.length; i++) {
        tempHouse.picturesList.add(house.picturesList[i].toString());
      }
    }
//StaticInfo.staticHouse.houseId =

    tempHouse.lat = coordinates.latitude;
    tempHouse.lang = coordinates.longitude;
    tempHouse.price = int.parse(controllers[0].text);
    tempHouse.city = first.locality == null ? first.adminArea : first.locality;
    tempHouse.bedrooms = int.parse(controllers[1].text);
    tempHouse.address = controllers[2].text;
    tempHouse.name = controllers[3].text;
    tempHouse.phoneNum = controllers[4].text;
    tempHouse.email = controllers[5].text;
    tempHouse.rating = 0.0;
    tempHouse.totalRatings = 0;
//    StaticInfo.staticHouse = tempHouse;
    StorageReference storageReference = FirebaseStorage()
        .ref()
        .child(Constant.houses)
//        .child(house.owner)
        .child("${tempHouse.houseId}");

    if (house.houseId == null) {
      inserting(storageReference, tempHouse);
    } else {
      editing(storageReference, tempHouse);
//      print('--- ${tempHouse.picturesList}');
    }
  }

  showSnackBar(String chithi) {
    SnackBar snackBar = SnackBar(
      content: Text(chithi),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(
      msg,
      context,
      duration: duration,
      gravity: gravity,
    );
  }

//showToast("Show Long Toast", duration: Toast.LENGTH_LONG)),
//showToast("Show Bottom Toast", gravity: Toast.BOTTOM)),

  inserting(StorageReference storageReference, House tempHouse) async {
    for (int i = 0; i < pics.length; i++) {
//      print('i: ${i} and ${pics[i]}');

      StorageUploadTask uploadTask = await storageReference
//          .child("${house.houseId}")
          .child("${i}")
          .putFile(filesList[pics[i]]);

      await uploadTask.onComplete;
      String uploadUrl = await storageReference
//         .child("Constant.games")
//         .child(tempGameId)
          .child("${i}")
          .getDownloadURL();
      tempHouse.picturesList.add(uploadUrl);
    }

    StaticInfo.staticHouse = tempHouse;
//    StaticInfo.staticHouse = House.fromMap(tempHouse.toMap());
    await dbref
        .child(Constant.houses)
        .child(tempHouse.houseId)
        .set(tempHouse.toMap());
    await dbref
        .child(Constant.users)
        .child(StaticInfo.currentUser.uid)
        .child(Constant.myHouses)
        .update({tempHouse.houseId: tempHouse.houseId});
    showToast("House Posted", duration: Toast.LENGTH_LONG);
    /* for (int n = 0; n < 8; n++) {
      filesList[n] = null;
    }

    controllers.forEach((element) {
      element.text = '';
    });
    first = null;
    coordinates = null; */

    setState(() {
      processing = false;
    });

    print('===== ${StaticInfo.staticHouse.toString()}');
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (ctx) => SellerLanding()), (a) => false);
  }

  editing(StorageReference storageReference, House tempHouse) async {
    int len = tempHouse.picturesList.length;
    for (int i = 0; i < pics.length; i++) {
      int num = len > pics[i] ? pics[i] : tempHouse.picturesList.length;
      StorageUploadTask uploadTask =
          await storageReference.child("${num}").putFile(filesList[pics[i]]);

      await uploadTask.onComplete;
      String uploadUrl =
          await storageReference.child("${num}").getDownloadURL();

      if (len > pics[i]) {
        tempHouse.picturesList[pics[i]] = uploadUrl;
      } else {
        tempHouse.picturesList.add(uploadUrl);
      }
    }
    StaticInfo.staticHouse = tempHouse;
//    StaticInfo.staticHouse = House.fromMap(tempHouse.toMap());
    await dbref
        .child(Constant.houses)
        .child(tempHouse.houseId)
        .update(tempHouse.toMap());
    showToast("House Details Updated", duration: Toast.LENGTH_LONG);
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      processing = false;
    });
    if (fromLandingPage != true) {
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (ctx) => SellerLanding()), (a) => false);
    }
  }

  showAlertDialog() {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Are you sure?",
        style: textStyle(2),
        textScaleFactor: 1.25,
      ),
      content: Text(
        "You want to exit?",
        style: textStyle(2),
        textScaleFactor: 1.125,
      ),
      backgroundColor: Constant.colorsList[3],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17.5),
        side: BorderSide(color: Constant.colorsList[0], width: 4.0),
      ),
      actions: [
        dialogBtn(true),
        dialogBtn(false),
      ],
    );
    showDialog(
        context: context,
        builder: (ctx) {
          return alertDialog;
        });
  }

  Widget dialogBtn(bool isNo) {
    return RaisedButton(
      onPressed: () async {
        if (isNo) {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          await pics.sort((a, b) => a.compareTo(b));
          if (formKey.currentState.validate()) {
            if (coordinates != null) {
              if (pics.length > 2 || house.houseId != null) {
                postHouse();
              } else {
                showSnackBar("Atleast insert 3 pictures");
              }
            } else {
              showSnackBar("Please enter your city");
            }
          }
        }
      },
      color: Constant.colorsList[4],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 75,
          horizontal: MediaQuery.of(context).size.width / 30),
      child: Text(isNo ? "No" : "Yes",
          style: TextStyle(
              color: Colors.white,
              fontWeight: Constant.fontweights[3]) //textStyle(3),
          ),
    );
  }

  dealMovingBack() {
    if (changesMade != true) {
      Navigator.pop(context);
    } else {
      showAlertDialog();
    }
  }
}
