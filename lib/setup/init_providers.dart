import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:radoncinservice/models/user_model.dart';

import 'init_app.dart';

class InitProviders extends StatelessWidget {
  const InitProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        final String? uid = snapshot.data?.uid;
        final bool emailVerified = snapshot.data?.emailVerified ?? false;
        if (uid != null && emailVerified)
          return MultiProvider(
              providers: [
                StreamProvider<UserEntity>(
                  create: (context) => UserEntity().streamUser(uid),
                  initialData: UserEntity(userId: uid),
                  catchError: (BuildContext context, err) {
                    print(err);
                    return UserEntity(userId: uid);
                  },
                ),
              ],
              child: Consumer<UserEntity>(
                builder: (context, user, child) {
                  return InitApp(key: Key('Init App $uid'));
                },
                //child: InitApp(key: Key('Init App $uid'))),
              ));

        return InitApp(key: Key('No auth app'));
      },
    );
  }
}
