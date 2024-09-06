import 'package:bloc/bloc.dart';
import 'package:chatappwithflutter/repository/firebase/user_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'user_status_state.dart';

class UserStatusCubit extends Cubit<UserStatusState> implements UserStatus {
  UserStatusCubit() : super(UserStatusInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<void> getStatusInfo(String status) async {
    try {
      String userId = _auth.currentUser?.uid ?? '';

      if (userId.isNotEmpty) {
        await _firestore.collection('users').doc(userId).update({
          'status': status,
        });

        emit(UserStatusUpdated(userStatus: status));
      }
    } catch (e) {
      emit(UserStatusError(
          errorMessage: 'Status güncellenirken hata oluştu: $e'));
    }
  }

  @override
  Future<void> readStatusInfo(String receiverId) async {
    try {
      if (receiverId.isNotEmpty) {
        _firestore.collection('users').doc(receiverId).snapshots().listen(
          (DocumentSnapshot snapshot) {
            if (snapshot.exists) {
              String status = snapshot.get('status') ?? 'unknown';
              emit(UserStatusLoaded(userStatus: status));
            } else {
              emit(UserStatusError(errorMessage: 'Kullanıcı bulunamadı.'));
            }
          },
          onError: (error) {
            emit(UserStatusError(
                errorMessage: 'Status bilgisi alınırken hata oluştu: $error'));
          },
        );
      } else {
        emit(UserStatusError(errorMessage: 'Geçersiz kullanıcı ID.'));
      }
    } catch (e) {
      emit(UserStatusError(
          errorMessage: 'Status bilgisi alınırken hata oluştu: $e'));
    }
  }
}
