import 'package:radoncinservice/widgets/ui_widgets.dart';
import 'package:flutter/material.dart';

class SignInButton extends UIButton {
  SignInButton({
    required String text, // this lets you know what is required
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) : super(
          child: Text(text, style: TextStyle(color: textColor, fontSize: 15)),
          color: color,
          onPressed: onPressed,
        );
}
