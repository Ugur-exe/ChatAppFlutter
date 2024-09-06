import 'package:chatappwithflutter/core/util/router.dart';
import 'package:chatappwithflutter/core/util/appColor.dart';
import 'package:chatappwithflutter/ui/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackgroundColor,
      body: BlocListener<LoginCubit, LoginState>(
        // BlocListener kullanarak durumları dinliyoruz
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Başarıyla giriş yapıldığında
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AppRouter().getPage('/mainView'),
                )); // Ana sayfaya yönlendir
          } else if (state is AuthError) {
            // Hata durumunda
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: _bodyWidget(context),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        _imageWidget(),
        const SizedBox(height: 50),
        _textWidget("Login", 36, FontWeight.bold, const EdgeInsets.all(5)),
        _textWidget(
            "To fully use our application, you need to log in:",
            20,
            FontWeight.normal,
            const EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 15)),
        const SizedBox(height: 50),
        _textfieldWidget(email),
        _textfieldWidget(password),
        Align(
          alignment: Alignment.topRight,
          child: _registerTextButton(context),
        ),
        _loginButton(context),
      ],
    );
  }

  Widget _imageWidget() {
    return SizedBox(
      width: 190,
      height: 190,
      child: Image.asset("assets/images/meetme.png"),
    );
  }

  Widget _textWidget(String text, double fonsize, FontWeight fontWeight,
      EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColors.textColor,
            fontSize: fonsize,
            fontWeight: fontWeight),
      ),
    );
  }

  Widget _textfieldWidget(TextEditingController controlller) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controlller,
        style: const TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        decoration: const InputDecoration(
          filled: true, // İç rengini etkinleştirmek için
          fillColor: AppColors.inputColor, // İç dolgu rengi
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.red), // Kenarlık çizgi rengi
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
                color: Colors.white), // Varsayılan kenarlık çizgi rengi
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
                color: Colors.white,
                width: 4), // Odaklanıldığında kenarlık çizgi rengi ve kalınlığı
          ),
        ),
      ),
    );
  }

  Widget _registerTextButton(context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppRouter().getPage('/register')));
        },
        child: const Text(
          textAlign: TextAlign.end,
          "Don't have an account? Sign up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            context.read<LoginCubit>().login(email.text, password.text);
          },
          child: const Text(
            "Login",
            style:
                TextStyle(fontSize: 24, color: AppColors.loginBackgroundColor),
          ),
        ),
      ),
    );
  }
}
