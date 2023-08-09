// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:client/shared_preferences_util.dart';
import 'package:client/trackaMainPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../baseApi.dart';
import '../widgets/button_widget.dart';
import '../widgets/email_field_widget.dart';
import '../widgets/password_field_widget.dart';
import 'register.dart';

final Dio _dio = Dio();
String loggedInUserId = '';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      formKey: GlobalKey<FormState>(),
    );
  }
}

class LoginPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const LoginPage({Key? key, required this.formKey}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // print('Login InitState');
    sharedPreferencesUtil();
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
            key: widget.formKey,
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
          final form = widget.formKey.currentState!;

          if (form.validate()) {
            login();
          }
        },
      );

  void login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show an error message if email or password is empty.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text("Error", style: TextStyle(color: Colors.red))),
            content: Text("Please provide your email and password"),
            actions: [
              Center(
                child: TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        },
      );
      return;
    }

    // Show a loading indicator while making the login request.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final Map<String, String> regBody = {
      "email": email,
      "password": password,
    };

    try {
      final response = await _dio.post(
        '$baseApi/auth/login',
        options: Options(headers: {"Content-Type": "application/json"}),
        data: jsonEncode(regBody),
      );

      Navigator.pop(context); // Close the loading dialog.

      if (response.statusCode == 200) {
        final String token = response.data['token'];
        if (token.isNotEmpty) {
          // Save the token to shared preferences.
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('jwtToken', token);

          // Navigate to the main page after successful login.
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scaffold(body: TrackaMain())));
        } else {
          // Handle case when token extraction fails.
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(
                    child: Text("Error", style: TextStyle(color: Colors.red))),
                content: Text("Token extraction failed"),
                actions: [
                  Center(
                    child: TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              );
            },
          );
        }
      } else {
        // Handle case when response status code is not 200.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text("Error", style: TextStyle(color: Colors.red))),
              content: Text("Login failed. Please check your credentials."),
              actions: [
                Center(
                  child: TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle network error or other exceptions.
      Navigator.pop(context); // Close the loading dialog.

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text("Error", style: TextStyle(color: Colors.red))),
            content: Text("An error occurred. Please try again later."),
            actions: [
              Center(
                child: TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        },
      );
    }
  }

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
