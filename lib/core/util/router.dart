import 'package:chatappwithflutter/ui/chat/view/chat_view.dart';
import 'package:chatappwithflutter/ui/login/view/login_view.dart';
import 'package:chatappwithflutter/ui/main/view/main_view.dart';
import 'package:chatappwithflutter/ui/register/view/register_view.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class AppRouter {
  // Ana sayfayı platforma göre yönlendiriyoruz
  Widget getHomePage() {
    if (Platform.isAndroid) {
      return LoginView();
    } else if (Platform.isIOS) {
      return const IosHomePage();
    } else {
      return LoginView();
    }
  }

  // Farklı sayfaları yönlendirmek için bir method
  Widget getPage(String routeName) {
    switch (routeName) {
      case '/register':
        return const RegisterView();
      case '/mainView':
        return const MainView();
      case '/chatView':
        return const ChatView();
      default:
        return LoginView();
    }
  }
}

// iOS ana sayfası
class IosHomePage extends StatelessWidget {
  const IosHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iOS Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppRouter().getPage('/second'),
              ),
            );
          },
          child: const Text('Go to Second Page'),
        ),
      ),
    );
  }
}
