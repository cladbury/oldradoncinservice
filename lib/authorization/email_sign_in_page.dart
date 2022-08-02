import 'package:radoncinservice/constants/color_constant.dart';
import 'package:radoncinservice/models/user_model.dart';
import 'package:radoncinservice/setup/init_landing_page.dart';
import 'package:radoncinservice/widgets/show_alert_dialog.dart';
import 'package:radoncinservice/widgets/show_exception_alertdialog.dart';
import 'package:radoncinservice/widgets/ui_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FormType {
  register,
  login,
  reset,
}

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage>
    with AutomaticKeepAliveClientMixin {
  // workaround for https://github.com/flutter/flutter/issues/49952
  late ModalRoute _mountRoute;
  final _formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  bool _isLoading = false;
  bool _checked = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String _email = '';
  String _password = '';
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isInitLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> submit() async {
    if (validateAndSave()) {
      setState(() {
        _isLoading = true;
      });

      switch (_formType) {
        case FormType.login:
          await login();
          break;

        case FormType.register:
          await register();
          break;

        case FormType.reset:
          await sendPasswordResetEmail();
          break;

        default:
          await login();
          break;
      }

      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  Future<void> submitAnon() async {
    setState(() {
      _isLoading = true;
    });
    print('logging in');
    await loginAnon();

    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> register() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((UserCredential value) async {
        if (value != null) {
          await UserEntity(
            userId: value.user?.uid,
            //firstName: '',
            //lastName: '',
            correctAnswers: [],
            incorrectAnswers: [],
          ).addToFirestore().then((_) => print('user added'));
        }

        if (!(value.user?.emailVerified ?? false)) {
          await value.user!.sendEmailVerification();
          if (mounted)
            await showAlertDialogClickable(
              context,
              title: 'Verify Email',
              cancelActionText: "Cancel",
              content: Container(
                height: 100,
                child: Column(
                  children: [
                    Text('Please verify your email address'),
                    //Xtext(text: 'Please verify your email address'),
                    SizedBox(height: 20),
                    FlatButton(
                      onPressed: resendVerification,
                      child: Text(
                        'Resend verification email',
                        style: TextStyle(color: colorTheme),
                      ),
                    ),
                  ],
                ),
              ),
              defaultActionText: 'Dismiss',
            ); //.then(
          //  (value) => Provider.of<User>(context, listen: false).reload(),
          //);
        }
      }).whenComplete(() async {
        if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => GetLandingPage(),
              ),
            );
          }
        }
      });
    } catch (e) {
      print(e);
      if (mounted)
        showExceptionAlertDialog(
          context,
          title: 'Login failed',
          exception: e.toString(),
        );
    }
  }

  Future<void> resendVerification() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((value) async {
        value.user?.sendEmailVerification();
      });
    } catch (e) {
      print(e);
      if (mounted)
        showExceptionAlertDialog(
          context,
          title: 'Unable to resend verification email',
          exception: e.toString(),
        );
    }
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((value) async {
        if (!(value.user?.emailVerified ?? false)) if (mounted)
          await showAlertDialogClickable(
            context,
            title: 'Verify Email',
            cancelActionText: "Cancel",
            content: Container(
              height: 100,
              child: Column(
                children: [
                  Text('Please verify your email address'),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: resendVerification,
                    child: Text(
                      'Resend verification email',
                      style: TextStyle(color: colorTheme),
                    ),
                  ),
                ],
              ),
            ),
            defaultActionText: 'Dismiss',
          ).then((value) => Provider.of<User>(context, listen: false).reload());
      }).whenComplete(() {
        if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => GetLandingPage(),
              ),
            );
          }
        }
      });
    } catch (e) {
      print(e);
      if (mounted)
        showExceptionAlertDialog(
          context,
          title: 'Login failed',
          exception: e.toString(),
        );
    }
  }

  Future<void> loginAnon() async {
    try {
      await FirebaseAuth.instance.signInAnonymously().then((value) {
        if (FirebaseAuth.instance.currentUser?.isAnonymous ?? false) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => GetLandingPage(),
              ),
            );
          }
        }
      });
    } catch (e) {
      print(e);
      if (mounted)
        showExceptionAlertDialog(
          context,
          title: 'Login failed',
          exception: e.toString(),
        );
    }
  }

  Future<void> sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _email,
      );
      print('Email Reset Sent');
    } catch (e) {
      if (mounted)
        showExceptionAlertDialog(
          context,
          title: 'Unable to send email',
          exception: e.toString(),
        );
    }
  }

  void _resetForm() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _formKey.currentState?.reset();
    moveToReset();
    print('Reset');
  }

  void _toggleFormType() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _formKey.currentState?.reset();

    if (_formType == FormType.login)
      moveToRegister();
    else
      moveToLogin();
  }

  void moveToReset() {
    setState(() {
      _checked = true;
      _formType = FormType.reset;
    });
  }

  void moveToRegister() {
    setState(() {
      _checked = false;
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    setState(() {
      _checked = true;
      _formType = FormType.login;
    });
  }

  List<Widget> _buildChildren() {
    final theme = Theme.of(context);

    if (_isInitLoading) return [Center(child: CircularProgressIndicator())];
    return [
      _buildEmailTextField(),
      if (_formType != FormType.reset) _buildPasswordTextField(),
      if (_formType == FormType.register)
        Column(
          children: [
            SizedBox(height: 8),
            _buildConfirmPasswordTextField(),
            SizedBox(height: 8)
          ],
        ),
      /* if (_formType == FormType.register)
        Row(
          children: [
            Container(
              width: 200,
              child: TextButton(
                onPressed: () {
                  //_showTerms();
                },
                child: FittedBox(
                  clipBehavior: Clip.hardEdge,
                  child: Text(
                    'I Agree to Terms & Conditions',
                    style: theme.textTheme.bodyText2?.copyWith(fontSize: 12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 1,
              ),
            ),
            Checkbox(
              value: _checked,
              onChanged: (bool? value) {
                setState(() {
                  _checked = value!;
                });
              },
            )
          ],
        ), */
      if (_formType == FormType.login)
        FlatButton(
          onPressed: !_isLoading ? _resetForm : null,
          child: Text(
            'Forgot Password?',
            style: theme.textTheme.subtitle1?.copyWith(fontSize: 12),
          ),
        ),
      if (_formType == FormType.reset) SizedBox(height: 18),
      FormSubmitButton(
        text: primaryButtonText,
        onPressed: (_isLoading != true) ? submit : () {},
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: Container(
              color: colorTheme,
              height: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('or'),
          ),
          Expanded(
            child: Container(
              color: colorTheme,
              height: 1.0,
            ),
          ),
        ],
      ),
      SizedBox(height: 8),
      FormSubmitButton(
        text: secondaryButtonText,
        onPressed: !_isLoading ? _toggleFormType : () {},
      ),
    ];
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyText1,
      autocorrect: false,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: _emailController,
      decoration: InputDecoration(
        enabled: !_isLoading,
        labelText: 'Email',
        //hintText: 'test@test.com',
      ),
      validator: (val) => val!.isEmpty
          ? "Please enter your email"
          : RegExp(r"^[a-zA-Z0-9-.]+@[a-zA-Z0-9-]+\.[a-zA-Z]+").hasMatch(val)
              ? null
              : "Please provide a valid email",
      // onEditingComplete: () => _emailEditingComplete(),
      onSaved: (val) {
        _emailController.text = val!.trim();
        _email = val.trim();
        return;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          style: Theme.of(context).textTheme.bodyText1,
          autocorrect: false,
          focusNode: _passwordFocusNode,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
          ),
          validator: (val) => val!.isEmpty
              ? "Please enter your password"
              : RegExp(r"[\w\d^<>{}\|;:.,~!?@#$%^=&*\\]{6,}").hasMatch(val)
                  ? null
                  : "Minimum of 6 characters in length",
          obscureText: _hidePassword,
          onSaved: (val) {
            _passwordController.text = val!;
            _password = val;
            return; //_password = val
          },
        ),
        IconButton(
          color: colorTheme,
          onPressed: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
          icon: Icon(
            _hidePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          style: Theme.of(context).textTheme.bodyText1,
          autocorrect: false,
          focusNode: _confirmPasswordFocusNode,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
          ),
          validator: (val) =>
              _passwordController.text == val ? null : "Passwords do not match",
          obscureText: _hideConfirmPassword,
        ),
        IconButton(
          color: colorTheme,
          onPressed: () {
            setState(() {
              _hideConfirmPassword = !_hideConfirmPassword;
            });
          },
          icon: Icon(
            _hideConfirmPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ],
    );
  }

  String get primaryButtonText {
    // use switch statements to avoid IDE complaints
    switch (_formType) {
      case FormType.login:
        return 'Sign In';
        break;

      case FormType.register:
        return 'Create an account';
        break;

      case FormType.reset:
        return 'Reset Password';
        break;

      default:
        return 'Create an account';
        break;
    }
  }

  String get secondaryButtonText {
    return _formType == FormType.login
        ? 'Need an account? Sign Up'
        : 'Have an account? Sign In';
  }

  @override
  void didChangeDependencies() {
    _mountRoute = ModalRoute.of(context)!;
    //_mountRoute ??= ModalRoute.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final GlobalKey<FormState> formKey = _mountRoute == ModalRoute.of(context)
        ? _formKey
        : GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: kIsWeb
          ? Center(
              child: SizedBox(
                width: 400,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: _buildChildren(),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: _buildChildren(),
                  ),
                ),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
