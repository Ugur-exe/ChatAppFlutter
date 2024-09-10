import 'package:bloc/bloc.dart';
import 'package:chatappwithflutter/model/user_model.dart';
import 'package:chatappwithflutter/ui/main/view/main_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial()) {
    _listenToUsers(); // Anlık veri dinlemeyi başlat
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // Firestore'dan kullanıcıları dinleme fonksiyonu
  void _listenToUsers() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      final List<UserModel> userList = snapshot.docs
          .map((doc) {
            final data = doc.data();
            return UserModel(
              email: data['email'],
              nameSurname: data['nameSurname'],
              userId: data['userId'],
              status: data['status'],
            );
          })
          .where((user) => user.userId != _currentUserId)
          .toList(); // Filtreleme işlemi

      emit(MainLoaded(users: userList));
    }, onError: (e) {
      emit(MainError(message: 'Kullanıcılar dinlenirken bir hata oluştu: $e'));
    });
  }

  void filterUsers(FilterType filter) {
    if (state is MainLoaded) {
      final List<UserModel> userList = (state as MainLoaded).users;

      if (filter == FilterType.all) {
        emit(MainLoaded(users: userList));
      } else if (filter == FilterType.unread) {
        final List<UserModel> unreadUsers = userList.where((user) {
          // Burada kullanıcıları "unread" kriterine göre filtreleyebilirsin.
          return true; // Örnek olarak tüm kullanıcıları döndürür, burada kendi şartını ekle.
        }).toList();

        emit(MainLoaded(users: unreadUsers));
      } else if (filter == FilterType.read) {
        final List<UserModel> readUsers = userList.where((user) {
          // Burada kullanıcıları "read" kriterine göre filtreleyebilirsin.
          return true; // Örnek olarak tüm kullanıcıları döndürür, burada kendi şartını ekle.
        }).toList();

        emit(MainLoaded(users: readUsers));
      } else if (filter == FilterType.pinned) {
        final List<UserModel> pinnedUsers = userList.where((user) {
          // Burada kullanıcıları "pinned" kriterine göre filtreleyebilirsin.
          return true; // Örnek olarak tüm kullanıcıları döndürür, burada kendi şartını ekle.
        }).toList();

        emit(MainLoaded(users: pinnedUsers));
      }
    }
  }
}
