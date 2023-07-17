import 'package:flutter/material.dart';

import 'dart:core';
import '../TrackaMainPage.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/logRegBg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 3),
                    Expanded(
                      child: Card(
                        elevation: 10,
                        color: Colors.white.withOpacity(0.97),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 30),
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 33,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 30),
                              EmailFieldWidget(controller: emailController),
                              SizedBox(height: 20),
                              PasswordFieldWidget(
                                  controller: passwordController),
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
        ),
      ),
    );
  }

  Widget buildButton() => ButtonWidget(
        text: 'Login',
        onClicked: () {
          final form = formKey.currentState!;

          if (form.validate()) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text('Your email is $email'),
              ));
            //
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TrackaMain()));
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
