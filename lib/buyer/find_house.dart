import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:immospot/buyer/search_results.dart';
import 'package:immospot/res/constants.dart';
import 'package:immospot/res/static_info.dart';
import 'package:immospot/seller/show_map.dart';
import 'package:location/location.dart';
import 'package:string_validator/string_validator.dart';

class FindHouse extends StatefulWidget {
  @override
  _FindHouseState createState() => _FindHouseState();
}

class _FindHouseState extends State<FindHouse> {
  BoxDecoration greenBorder = BoxDecoration(
    color: Constant.colorsList[3],
    border: Border.all(color: Constant.colorsList[4], width: 1.5),
    borderRadius: BorderRadius.circular(25.0),
  );
  List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          3, (index) => TextEditingController());
  List<String> hintTexts = ['City', 'Number of Bedrooms', 'From', 'To'];

  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Constant.colorsList[4]));
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Address first;
  Coordinates coordinates;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//  List<Address> addresses;
  bool proceeding = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    print('===== ${StaticInfo.staticSearch}');

    controllers[0].text =
        StaticInfo.staticSearch.beds == null || StaticInfo.staticSearch.beds < 1
            ? ""
            : StaticInfo.staticSearch.beds.toString();
    controllers[1].text = StaticInfo.staticSearch.startingPrice == null ||
            StaticInfo.staticSearch.startingPrice < 1
        ? ''
        : StaticInfo.staticSearch.startingPrice.toString();
    controllers[2].text = StaticInfo.staticSearch.endingPrice == null ||
            StaticInfo.staticSearch.endingPrice < 1
        ? ''
        : StaticInfo.staticSearch.endingPrice.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Constant.colorsList[3],
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 50,
              horizontal: MediaQuery.of(context).size.width / 15),
          child: Center(
            child: Form(
              key: formKey,
              child: proceeding == false
                  ? SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.75),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(),
                            Text(
                              "LETS FIND THE BEST\nHOUSE FOR YOU",
                              textAlign: TextAlign.center,
                              style: textStyle(2, 3),
                              textScaleFactor: 1.5,
                            ),
                            fieldsCol(),
                            btn(),
                            Container(),
                          ],
                        ),
                      ),
                    )
                  : CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Constant.colorsList[4]),
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
        fontWeight: Constant.fontweights[fNum]);
  }

  Widget outerCon(bool isMiniCon, Widget wid) {
    double heightTotal = MediaQuery.of(context).size.height;
    double widthTotal = MediaQuery.of(context).size.width;
    return Container(
      decoration: greenBorder,
      width: isMiniCon ? widthTotal / 3 : widthTotal,
      margin: EdgeInsets.symmetric(vertical: heightTotal / 100),
      padding: EdgeInsets.symmetric(
          vertical: heightTotal / 75, horizontal: widthTotal / 30),
      child: wid,
    );
  }

  Widget fieldsCol() {
    return Column(
      children: [
//        reqField(0),
        cityField(),
        reqField(0),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 100),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "       Price Range",
              style: textStyle(2, 2),
              textScaleFactor: 1.125,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [miniCon(1), miniCon(2)],
        ),
      ],
    );
  }

  Widget miniCon(int fieldNum) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      child: reqField(fieldNum),
    );
  }

  Widget reqField(int conNum) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 150),
      child: TextFormField(
        controller: controllers[conNum],
        decoration: InputDecoration(
          border: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          errorBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          focusedErrorBorder: outlineInputBorder,
          hintText: hintTexts[conNum + 1],
          hintStyle: textStyle(2, 2),
//     errorStyle:
          fillColor: Constant.colorsList[3],
          filled: true,
          contentPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 20),
        ),
        validator: (txt) {
          /* if (conNum == 0) {
            if (isNumeric(txt)) {
              controllers[0].text = '';
            }
          } else {
            if (!isNumeric(txt)) {
              controllers[conNum].text = '';
            }
          } */
          if (!isNumeric(txt)) {
            controllers[conNum].text = '';
          }
        },
        keyboardType: conNum == 0 ? TextInputType.text : TextInputType.number,
        style: textStyle(2, 2),
        textAlign: conNum <= 1 ? TextAlign.start : TextAlign.center,
        onFieldSubmitted: (txt) {
          /* if (conNum == 0) {
            if (isNumeric(txt)) {
              StaticInfo.staticSearch.beds = int.parse(txt);
            }
          } else if (conNum == 1) {
            if (formKey.currentState.validate()) {}
          } */
          if (isNumeric(txt)) {
            if (conNum == 0) {
              StaticInfo.staticSearch.beds = int.parse(txt);
            } else if (conNum == 1) {
              StaticInfo.staticSearch.startingPrice = int.parse(txt);
            } else {
              StaticInfo.staticSearch.endingPrice = int.parse(txt);
            }
//            print('----- ${StaticInfo.staticSearch}');
          }
        },
      ),
    );
  }

  Widget btn() {
    return RaisedButton(
      onPressed: () async {
        /*     if (coordinates != null) {
//          navigation();
          proceed();
        } else {
          setState(() {
            proceeding = true;
          });
          await locRelatedBakcHodi();
          if (coordinates != null) {
//            navigation();
            proceed();
          }
        }
 */
        if (StaticInfo.staticSearch.city == null) {
          showSnackBar("Please select the city first");
        } else {
          proceed();
        }
      },
      color: Constant.colorsList[4],
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            "SEARCH",
            style: textStyle(3, 3),
            textScaleFactor: 1.25,
          ),
        ),
      ),
    );
  }

  proceed() {
    formKey.currentState.validate();
//    Search search = Search();
//    search.city = first.locality != null ? first.locality : first.adminArea;
//    search.beds =
//        controllers[0].text == '' ? -1 : int.parse(controllers[1].text);
//    search.startingPrice =
//        controllers[1].text == '' ? -1 : int.parse(controllers[2].text);
//    search.endingPrice =
//        controllers[2].text == '' ? -1 : int.parse(controllers[3].text);

//    StaticInfo.staticSearch = search;
    StaticInfo.staticSearch.beds =
        controllers[0].text == '' ? -1 : int.parse(controllers[0].text);
    StaticInfo.staticSearch.startingPrice =
        controllers[1].text == '' ? -1 : int.parse(controllers[1].text);

    StaticInfo.staticSearch.endingPrice =
        controllers[2].text == '' ? -1 : int.parse(controllers[2].text);
//    print('----- ${StaticInfo.staticSearch}');
    setState(() {
      proceeding = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) =>
                SearchResults(StaticInfo.staticSearch, coordinates)));
  }

  locRelatedBakcHodi() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        setState(() {
          proceeding = false;
        });
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
  }

  Widget cityField() {
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
//        if (changesMade != true) changesMade = true;
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
            color: Constant.colorsList[3],
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Constant.colorsList[4])),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 150),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20, vertical: 15.0),
        child: Text(
//          first == null
//              ? '${hintTexts[0]}'
//              : '${first.locality == null ? first.adminArea : first.locality}',
          "${StaticInfo.staticSearch.city == null ? hintTexts[0] : StaticInfo.staticSearch.city}",
          style: textStyle(2, 2),
        ),
      ),
    );
  }

  navigation() async {
    Coordinates abc = await Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => ShowMap(coordinates)));
    if (abc != null) {
      List<Address> addresses =
          await Geocoder.local.findAddressesFromCoordinates(abc);

      first = addresses.first;
      StaticInfo.staticSearch.city =
          first.locality == null ? first.adminArea : first.locality;

      setState(() {});
    }
  }

  showSnackBar(String txt) {
    SnackBar snackBar = SnackBar(content: Text(txt));
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
