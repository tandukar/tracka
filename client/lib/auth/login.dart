import 'dart:core';

import 'package:client/shared_preferences_util.dart';
import 'package:flutter/material.dart';

import '../trackaMainPage.dart';
import '../widgets/button_widget.dart';
import '../widgets/email_field_widget.dart';
import '../widgets/password_field_widget.dart';
import 'register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

final formKey = GlobalKey<FormState>();
final emailController = TextEditingController();
//
final passwordController = TextEditingController();
bool passText = true;
//
final email = emailController.text;
final password = passwordController.text;
//

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('This is from login initState: _$userIdKey');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/loginBg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.22),
                SizedBox(
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Column(
                        children: [
                          SizedBox(height: 120),
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 33,
                              fontWeight: FontWeight.w700,
                              color: Colors.teal[500],
                            ),
                          ),
                          SizedBox(height: 30),
                          EmailFieldWidget(controller: emailController),
                          SizedBox(height: 20),
                          PasswordFieldWidget(controller: passwordController),
                          SizedBox(height: 50),
                          buildButton(),
                          SizedBox(height: 30),
                          buildNoAccount(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton() => ButtonWidget(
        text: 'Login',
        onClicked: () {
          final form = formKey.currentState!;

          if (form.validate()) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TrackaMain()));
          }
        },
      );

  Widget buildNoAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don\'t have an account?', style: TextStyle(fontSize: 16)),
          TextButton(
            child: Text('Register', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Register()));
            },
          ),
        ],
      );
}
