class User {
  String userUid;
  String name;
  String hasRead;
  User({this.userUid, this.name, this.hasRead});

  @override
  String toString() {
    return 'User{userUid: $userUid, name: $name, hasRead: $hasRead}';
  }
}
