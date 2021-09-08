import 'package:firebase_auth/firebase_auth.dart';
import 'package:immospot/models/house.dart';
import 'package:immospot/models/search.dart';

class StaticInfo {
  static FirebaseUser currentUser;
  static String userName = '';
//  static String playerId = '';
  static int isActive;

  static House staticHouse = House();
  static Search staticSearch = Search();
}
