import 'package:flutter/material.dart';

bool passText = true;
String password = '';

bool isPasswordValid(String password) {
  // Password must be at least 8 characters long
  if (password.length < 8) {
    return false;
  }

  // Password must contain at least one uppercase letter
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return false;
  }

  // Password must contain at least one lowercase letter
  if (!password.contains(RegExp(r'[a-z]'))) {
    return false;
  }

  // Password must contain at least one digit
  if (!password.contains(RegExp(r'[0-9]'))) {
    return false;
  }

  // Password is valid
  return true;
}

class PasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const PasswordFieldWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);

    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        obscureText: passText,
        decoration: InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                passText = !passText;
              });
            },
            icon: Icon(passText ? Icons.visibility : Icons.visibility_off),
          ),
        ),
        validator: (pass) => pass != null && !isPasswordValid(pass)
            ? 'Enter a valid password'
            : null,
      );
}
