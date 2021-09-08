class ChattedUser {
  String userUid;
  String userNname;
  String hasRead;
  int latestMessageTime;
  String playerId;

  ChattedUser(
      {this.userUid, this.userNname, this.hasRead, this.latestMessageTime, this.playerId});

  @override
  String toString() {
    return 'ChattedUser{userUid: $userUid, userNname: $userNname, hasRead: $hasRead, latestMessageTime: $latestMessageTime}';
  }
}
