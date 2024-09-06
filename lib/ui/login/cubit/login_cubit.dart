import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ); 
          emit(AuthAuthenticated(user: userCredential.user));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: e.message ?? 'An unknown error occurred'));
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    emit(LoginInitial());
  }
}
