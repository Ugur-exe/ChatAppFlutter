import 'package:bloc/bloc.dart';
import 'package:chatappwithflutter/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial()) {
    _listenToUsers(); // Anlık veri dinlemeyi başlat
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore'dan kullanıcıları dinleme fonksiyonu
  void _listenToUsers() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      final List<UserModel> userList = snapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel(
          email: data['email'],
          nameSurname: data['nameSurname'],
          userId: data['userId'],
          status: data['status'],
        );
      }).toList();

      emit(MainLoaded(users: userList));
    }, onError: (e) {
      emit(MainError(message: 'Kullanıcılar dinlenirken bir hata oluştu: $e'));
    });
  }

  // Filtreleme işlemi
  void filterUsers(String filter) {
    if (state is MainLoaded) {
      final List<UserModel> userList = (state as MainLoaded).users;

      if (filter == 'All') {
        emit(MainLoaded(users: userList));
      } else if (filter == 'Unread') {
        final List<UserModel> unreadUsers = userList.where((user) {
          return true;
        }).toList();

        emit(MainLoaded(users: unreadUsers));
      }
    }
  }

  void createChatId(String receiverId, String senderId){
    
  }
}
