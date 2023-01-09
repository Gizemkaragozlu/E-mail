import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullname = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.purple),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.purple),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Chat",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Konuşmak için lütfen giriş yapın!",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    Image.asset("assets/fullpassword.png"),
                    TextFormField(
                      decoration: textInpuDecoration.copyWith(
                          labelText: "Ad",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.purple,
                          )),
                      onChanged: ((val) {
                        setState(() {
                          fullname = val;
                        });
                      }),
                      validator: (val) {
                        if (val!.isNotEmpty) {
                          return null;
                        } else {
                          return "Ad kısmı boş olamaz!";
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInpuDecoration.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.purple,
                          )),
                      onChanged: ((val) {
                        setState(() {
                          email = val;
                          print(email);
                        });
                      }),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      decoration: textInpuDecoration.copyWith(
                        labelText: "Şifre",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.purple,
                        ),
                      ),
                      validator: (val) {
                        if (val!.length < 6) {
                          return "En az 6 karakter girilmelidir!";
                        } else {
                          return null;
                        }
                      },
                      onChanged: ((val) {
                        setState(() {
                          password = val;
                          print(password);
                        });
                      }),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const Text(
                          "Kayıt ol", //Kayıt olma butonu
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          RegisterPage();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(TextSpan(
                      text: "Zaten hesabınız var mı?",
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Giriş Yap",
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextScreen(context, const LoginPage());//registerpage
                              })
                      ],
                    ))
                  ],
                ),
              ),
            ),
    );
  }

  // ignore: non_constant_identifier_names
  Register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullname, email, password)
          .then((value) async {
        if (value = true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullname);
          nextScreenReplace(context, const LoginPage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            LoginPage();
            _isLoading = false;
          });
        }
      });
    }
  }
}
