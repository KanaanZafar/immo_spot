import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';

class ShowMap extends StatefulWidget {
  Coordinates coordinates;

  ShowMap(this.coordinates);

  @override
  _ShowMap createState() => _ShowMap(coordinates);
}

class _ShowMap extends State<ShowMap> {
  Coordinates coordinates;

  _ShowMap(this.coordinates);

  GoogleMapController _controller;
  Geolocator _geolocator;
  CameraPosition _initialPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _geolocator = Geolocator();
    _getCurrentLocation();
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _confirm,
      ),
      body: SafeArea(
        child: _initialPosition == null
            ? Container()
            : Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: (controller) async {
                _controller = controller;
              },
              markers: Set<Marker>.of(markers.values),
              initialCameraPosition: _initialPosition,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: SearchMapPlaceWidget(
                      apiKey: 'AIzaSyDXP1uTckgFndfm8ebIYGLOYJ1lhvrfBMo',
//                            apiKey: "AIzaSyB5bAilKJqzkK33LxT8bEo7VVqKQ5-HLhE",
                      // The language of the autocompletion
                      language: 'en',
                      // The position used to give better recomendations. In this case we are using the user position
                      strictBounds: false,
                      onSelected: (Place place) async {
                        final geolocation = await place.geolocation;
                        _controller.animateCamera(CameraUpdate.newLatLng(
                            geolocation.coordinates));
                        _controller.animateCamera(
                            CameraUpdate.newLatLngBounds(
                                geolocation.bounds, 0));
                      },
                    ),
                  ),
                  Card(
                    elevation: 10,
                    child: (IconButton(
                      icon: Icon(Icons.my_location),
                      onPressed: _getMyLocation,
                    )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onCameraMove(position) {
    MarkerId id = MarkerId(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());
    final Marker marker = Marker(
      markerId: id,
      position: position.target,
    );
    if (mounted)
      setState(() {
        markers.clear();
        markers[id] = marker;
      });
  }

  _getCurrentLocation() async {
    _initialPosition = CameraPosition(
      target: LatLng(coordinates.latitude, coordinates.longitude),
    );
    MarkerId id = MarkerId(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());
    final Marker marker = Marker(
        markerId: id,
//      position: LatLng(currentLocation.latitude, currentLocation.longitude),
        position: LatLng(coordinates.latitude, coordinates.longitude));

//    print('----- ${currentLocation} and ${_initialPosition}');
    setState(() {
      markers.clear();
      markers[id] = marker;
    });
  }

  _getMyLocation() async {
    var position = await _geolocator.getCurrentPosition();
    await _controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(
          position.latitude,
          position.longitude,
        ),
        15));
  }

  _confirm() async {
    try {
      var point = markers.values.toList()[0].position;
      var places = await _geolocator.placemarkFromCoordinates(
          point.latitude, point.longitude);
      coordinates = Coordinates(point.latitude, point.longitude);
      if (places.length == 0)
        Navigator.pop(context);
      else {
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pop(context, coordinates);
      }
    } catch (e) {
      print('------- ${e}');
    }
  }
}
