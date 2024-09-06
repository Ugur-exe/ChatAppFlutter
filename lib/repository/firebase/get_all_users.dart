import 'package:chatappwithflutter/model/user_model.dart';

abstract class AllUsersGetService {
  Future<void> getUsers(String chatId, List<UserModel> userList);
}
