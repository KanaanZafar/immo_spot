import 'package:immospot/res/constants.dart';

class House {
  String houseId;
  int postingTime;
  List<dynamic> picturesList;
  double lat;
  double lang;
  String city;
  int price;
  int bedrooms;
  String address;
  String name;
  String phoneNum;
  String email;
  String isSold;
  String owner;
  double rating;
  int totalRatings;

  House(
      {this.houseId,
      this.postingTime,
      this.picturesList,
      this.lat,
      this.lang,
      this.city,
      this.price,
      this.bedrooms,
      this.address,
      this.name,
      this.phoneNum,
      this.email,
      this.isSold,
      this.owner,
      this.rating,
      this.totalRatings});

  House.fromMap(Map<dynamic, dynamic> map) {
    var a;
    this.houseId = map[Constant.houseId];
    this.postingTime = map[Constant.postingTime];
    this.picturesList = map[Constant.picturesList];
    this.lat = map[Constant.lat];
    this.lang = map[Constant.lang];
    this.city = map[Constant.city];
    this.price = map[Constant.price];
    this.bedrooms = map[Constant.bedrooms];
    this.address = map[Constant.address];
    this.name = map[Constant.name];
    this.phoneNum = map[Constant.phoneNum];
    this.email = map[Constant.email];
    this.isSold = map[Constant.isSold];
    this.owner = map[Constant.owner];
//    this.rating = map[Constant.rating];
    a = map[Constant.rating];
    this.rating = a / 1;
    this.totalRatings = map[Constant.totalRatings];
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.houseId: this.houseId,
      Constant.postingTime: this.postingTime,
      Constant.picturesList: this.picturesList,
      Constant.lat: this.lat,
      Constant.lang: this.lang,
      Constant.city: this.city,
      Constant.price: this.price,
      Constant.bedrooms: this.bedrooms,
      Constant.address: this.address,
      Constant.name: this.name,
      Constant.phoneNum: this.phoneNum,
      Constant.email: this.email,
      Constant.isSold: this.isSold,
      Constant.owner: this.owner,
      Constant.rating: this.rating,
      Constant.totalRatings: this.totalRatings
    };
  }

  @override
  String toString() {
    return 'House{houseId: $houseId, postingTime: $postingTime, picturesListLen: ${picturesList.length}, lat: $lat, lang: $lang, city: $city, price: $price, bedrooms: $bedrooms, address: $address, name: $name, phoneNum: $phoneNum, email: $email, isSold: $isSold, owner: $owner, rating: $rating, totalRatings: $totalRatings}';
  }
}
