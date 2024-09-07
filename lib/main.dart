import 'package:chatappwithflutter/core/util/router.dart';
import 'package:chatappwithflutter/firebase_options.dart';
import 'package:chatappwithflutter/service/firebase/user_status/cubit/user_status_cubit.dart';
import 'package:chatappwithflutter/ui/chat/cubit/cubit/chat_cubit_cubit.dart';
import 'package:chatappwithflutter/ui/chat/view/chat_view.dart';
import 'package:chatappwithflutter/ui/login/cubit/login_cubit.dart';
import 'package:chatappwithflutter/ui/main/cubit/main_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  late UserStatusCubit _userStatusCubit;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userStatusCubit = UserStatusCubit();

    _userStatusCubit.getStatusInfo('online');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String localTime() {
    String minute = DateTime.now().minute.toString();
    String hour = DateTime.now().hour.toString();
    return 'Last seen $hour:$minute';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print('Uygulama arka plana alındı ');
      _userStatusCubit.getStatusInfo(localTime());
    } else if (state == AppLifecycleState.resumed) {
      print('Uygulama tekrar açıldı');
      _userStatusCubit.getStatusInfo('online');
    } else if (state == AppLifecycleState.detached) {
      print('Uygulama tamamen kapatıldı');
      _userStatusCubit.getStatusInfo(localTime());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MainCubit(),
        ),
        BlocProvider(
          create: (_) => LoginCubit(),
        ),
        BlocProvider(
          create: (_) => ChatCubitCubit(),
        ),
        BlocProvider.value(
          value: _userStatusCubit,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return AppRouter().getPage('/mainView');
              } else {
                return AppRouter().getHomePage();
              }
            },
          ),
        ),
      ),
    );
  }
}
