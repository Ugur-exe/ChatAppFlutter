import 'package:chatappwithflutter/core/util/appColor.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackgroundColor,
      body: SingleChildScrollView(
        child: _bodyWidget(),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Align(
          child: _backButton(),
          alignment: Alignment.topLeft,
        ),
        _imageWidget(),
        const SizedBox(height: 50),
        _textWidget("Register", 36, FontWeight.bold, const EdgeInsets.all(5)),
        _textWidget(
            "To fully use your application, you need to register:",
            20,
            FontWeight.normal,
            const EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 15)),
        const SizedBox(height: 50),
        _textfieldWidget(
            fullName, "Name and Surname", TextInputType.text, false),
        _textfieldWidget(email, "Email", TextInputType.emailAddress, false),
        _textfieldWidget(
            password, "Password", TextInputType.visiblePassword, true),
        const SizedBox(height: 25),
        _registerButton(),
      ],
    );
  }

  Widget _backButton() {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        size: 25,
        color: Colors.black,
        Icons.arrow_back_ios_sharp,
      ),
    );
  }

  Widget _imageWidget() {
    return SizedBox(
      width: 150,
      height: 150,
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

  Widget _textfieldWidget(TextEditingController controller, String hintText,
      TextInputType textInputType, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscureText,
        style: const TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.normal),
          filled: true, // İç rengini etkinleştirmek için
          fillColor: AppColors.inputColor, // İç dolgu rengi
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.red), // Kenarlık çizgi rengi
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
                color: Colors.white), // Varsayılan kenarlık çizgi rengi
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
                color: Colors.white,
                width: 4), // Odaklanıldığında kenarlık çizgi rengi ve kalınlığı
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            "Sign Up",
            style:
                TextStyle(fontSize: 24, color: AppColors.loginBackgroundColor),
          ),
        ),
      ),
    );
  }
}
