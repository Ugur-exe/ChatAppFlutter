abstract class UserStatus {
  Future getStatusInfo(String status) async {}
  Future readStatusInfo(String receiverId) async {}
}
