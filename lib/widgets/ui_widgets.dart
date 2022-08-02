import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:radoncinservice/constants/color_constant.dart';

class UIButton extends StatelessWidget {
  const UIButton({
    required this.child,
    required this.color,
    this.height: 50,
    this.borderRadius: 5.0,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: child,
        ),
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class FormSubmitButton extends UIButton {
  FormSubmitButton({
    required String text,
    required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorWhite,
              fontSize: 18,
            ),
          ),
          height: 44.0,
          color: colorTheme,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}

class EmptyContent extends StatelessWidget {
  const EmptyContent(
      {this.title = 'Empty',
      this.message = 'Add a new item to get started',
      Key? key})
      : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: theme.textTheme.bodyText1),
          Text(message, style: theme.textTheme.bodyText1),
        ],
      ),
    );
  }
}
