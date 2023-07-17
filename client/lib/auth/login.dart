import 'package:flutter/material.dart';

import 'dart:core';
import '../widgets/password_field_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/email_field_widget.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/logRegBg.png"), fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Card(
                        elevation: 10,
                        color: Colors.white.withOpacity(0.97),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 15),
                              EmailFieldWidget(controller: emailController),
                              SizedBox(height: 20),
                              PasswordFieldWidget(
                                  controller: passwordController),
                              SizedBox(height: 20),
                              buildButton(),
                              SizedBox(height: 20),
                              buildNoAccount(),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            )),
      ),
    );
  }

  Widget buildButton() => ButtonWidget(
        text: 'Login',
        onClicked: () {
          final form = formKey.currentState!;

          if (form.validate()) {
            final email = emailController.text;
            final password = passwordController.text;

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content:
                    Text('Your email is $email\nYour password is $password'),
              ));
          }
        },
      );

  Widget buildNoAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don\'t have an account?'),
          TextButton(
            child: Text('Register'),
            onPressed: () {},
          ),
        ],
      );
}
