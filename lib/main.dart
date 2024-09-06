import 'package:chatappwithflutter/core/router.dart';
import 'package:chatappwithflutter/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              // Kullanıcı giriş yapmışsa ana sayfaya yönlendirin
              return AppRouter().getPage('/mainView'); // Ana ekran
            } else {
              // Kullanıcı giriş yapmamışsa giriş sayfasına yönlendirin
              return AppRouter().getHomePage(); // Giriş ekranı
            }
          },
        ),
      ),
    );
  }
}
