import 'package:auto_size_text/auto_size_text.dart';
import 'package:radoncinservice/authorization/email_sign_in_page.dart';
import 'package:radoncinservice/widgets/show_exception_alertdialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../constants/color_constant.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = false;

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    return Scaffold(
        backgroundColor: colorTheme,
        body: _buildBody(context),
        resizeToAvoidBottomInset: false);
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 75),
            Container(
              child: _buildHeader(context),
            ),
            SizedBox(height: 10),
            EmailSignInPage(
              key: Key("Email Sign In Page"),
            ),
            //EmailSignInPageAnon(key: Key("Email Sign In Page")),
            SizedBox(height: 100),

            /* Text(
              '0.0.2',
              textAlign: TextAlign.center,
              style: theme.textTheme.caption.copyWith(color: colorGrey),
            ), */
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    ThemeData theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          AutoSizeText(
            'Welcome to',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: theme.textTheme.headline2?.copyWith(color: colorWhite),
          ),
          AutoSizeText(
            'Oncpatient Companion',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: theme.textTheme.headline1?.copyWith(color: colorWhite),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
