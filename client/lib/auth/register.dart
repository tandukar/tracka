import 'dart:core';

import 'package:flutter/material.dart';

import '../widgets/button_widget.dart';
// import '../widgets/confirm_password_field_widget.dart';
import '../widgets/email_field_widget.dart';
import '../widgets/password_field_widget.dart';
import 'login.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterPage();
  }
}

final formKey = GlobalKey<FormState>();
final emailController = TextEditingController();
//
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();
bool passText = true;
bool confirmPassText = true;
//
final email = emailController.text;
final password = passwordController.text;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/registerBg.png"),
        fit: BoxFit.fill,
      )),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.23),
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
      validator: (value) {
        if (value != null && value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget buildButton() => ButtonWidget(
        text: 'Register',
        onClicked: () {
          final form = formKey.currentState!;

          if (form.validate()) {
            // ScaffoldMessenger.of(context)
            //   ..removeCurrentSnackBar()
            //   ..showSnackBar(SnackBar(
            //     content: Text('Your email is $email'),
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          }
        },
      );

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
