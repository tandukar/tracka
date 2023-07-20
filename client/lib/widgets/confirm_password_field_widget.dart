import 'package:flutter/material.dart';

import 'password_field_widget.dart';

class ConfirmPasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;

  const ConfirmPasswordFieldWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  State<ConfirmPasswordFieldWidget> createState() =>
      _ConfirmPasswordFieldWidgetState();
}

class _ConfirmPasswordFieldWidgetState
    extends State<ConfirmPasswordFieldWidget> {
  bool confirmPassText = true;

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
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
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
      validator: (confirmPass) {
        if (confirmPass != null && confirmPass != password) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
