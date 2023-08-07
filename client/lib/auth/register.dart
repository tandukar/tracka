// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:core';

import 'package:client/baseApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../widgets/button_widget.dart';
import '../widgets/email_field_widget.dart';
import '../widgets/password_field_widget.dart';
import 'login.dart';

final Dio _dio = Dio();

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegisterPage(
      formKey: GlobalKey<FormState>(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const RegisterPage({Key? key, required this.formKey}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool confirmPassText = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('Register InitState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/registerBg.png"),
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
                          SizedBox(height: 10),
                          Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 33,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 30),
                          usernameFieldWidget(),
                          SizedBox(height: 20),
                          EmailFieldWidget(controller: emailController),
                          SizedBox(height: 20),
                          PasswordFieldWidget(controller: passwordController),
                          SizedBox(height: 20),
                          confirmPasswordFieldWidget(context),
                          SizedBox(height: 30),
                          buildButton(),
                          SizedBox(height: 15),
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

  TextFormField usernameFieldWidget() {
    return TextFormField(
      controller: usernameController,
      decoration: InputDecoration(
        hintText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (userName) {
        if (userName != null && userName.isEmpty) {
          return 'Please enter your username';
        }
        // Regular expression to check for at least two words separated by a space
        RegExp regex = RegExp(r'^\w+\s+\w+.*$');

        if (!regex.hasMatch(userName!.trim())) {
          return 'Username should contain at least two words';
        }

        return null;
      },
    );
  }

  TextFormField confirmPasswordFieldWidget(BuildContext context) {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: confirmPassText,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              confirmPassText = !confirmPassText;
            });
          },
          icon: Icon(confirmPassText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      validator: (pass) => pass != null && pass != passwordController.text
          ? 'Passwords do not match'
          : null,
    );
  }

  Widget buildButton() => ButtonWidget(
        text: 'Register',
        onClicked: () {
          final form = widget.formKey.currentState!;

          if (form.validate()) {
            final username = usernameController.text;
            final email = emailController.text;
            final password = passwordController.text;
            final confirmPassword = confirmPasswordController.text;

            print('Username: $username');
            print('Email: $email');
            print('Password: $password');
            print('Confirm Password: $confirmPassword');

            register();
          }
        },
      );

  void register() async {
    var regBody = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };
    print(regBody);

    try {
      final response = await _dio.post(
        '$baseApi/auth/register',
        options: Options(headers: {"Content-Type": "application/json"}),
        data: jsonEncode(regBody),
      );
      print(response.data);
      // if 200 status
      if (response.statusCode == 200) {
        print('Registered successfully');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      // if 400 status
      // if (response.statusCode == 400) {
      //   print('Bad request');
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text('Error'),
      //         content: Text('Email already exists, try logging in'),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: Text('OK'),
      //           ),
      //         ],
      //       );
      //     },
      //   );
      // }
    } on DioException catch (e) {
      print(e);
      // if (e.response!.statusCode == 400) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Text('Email already exists',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                    textAlign: TextAlign.center),
                content: Text('Try logging in instead',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center),
                actions: [
                  TextButton(
                    child: Center(child: Text('OK')),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
      // }
    }
  }

  Widget buildNoAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already have an account?', style: TextStyle(fontSize: 16)),
          TextButton(
            child: Text('Login', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      );
}
