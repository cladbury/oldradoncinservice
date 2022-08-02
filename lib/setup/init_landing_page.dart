import 'package:flutter/foundation.dart';
//import 'package:oncpatient/authorization/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:oncpatient/screens/web_home_page.dart';
import 'package:provider/provider.dart';
import 'package:radoncinservice/authorization/sign_in_page.dart';
import 'package:radoncinservice/screens/web_home_page.dart';

class GetLandingPage extends StatelessWidget {
  const GetLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user?.emailVerified ?? false)
      return WebHomePage();
    //HomePage();
    //if(user!=null && user.emailVerified ==false)
    //return ConfirmEmail();
    else
      //return WebHomePage();
      return SignInPage();
    //  key: Key('Sign In Page'),
    //);
  }
}
