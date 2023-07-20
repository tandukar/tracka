import 'dart:core';

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
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/loginBg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  SizedBox(
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
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
        ]),
      ),
    );
  }

  Widget buildButton() => ButtonWidget(
        text: 'Login',
        onClicked: () {
          final form = formKey.currentState!;

          if (form.validate()) {
            // ScaffoldMessenger.of(context)
            //   ..removeCurrentSnackBar()
            //   ..showSnackBar(SnackBar(
            //     content: Text('Your email is $email'),
            //   ));
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
