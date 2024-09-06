import 'package:chatappwithflutter/model/user_model.dart';

abstract class AllUsersGetService {
  void getUsers(
    String chatId,
    List<User> userList,
  );
}
