import 'package:chatappwithflutter/model/user_model.dart';
import 'package:chatappwithflutter/repository/firebase/allUserRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseGetAllUsers implements AllUsersGetService {
  @override
  void getUsers(String chatId, List<User> userList) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    

  }
}
