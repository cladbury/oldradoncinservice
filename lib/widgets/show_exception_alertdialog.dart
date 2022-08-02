import 'package:radoncinservice/widgets/show_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required String exception,
}) =>
    showAlertDialog(context,
        title: title,
        content: exception,
        defaultActionText: 'Dismiss',
        cancelActionText: "Cancel");

String _message(Exception exception) {
  if (exception is FirebaseAuthException) {
    return exception.message!;
  }
  return exception.toString();
}
