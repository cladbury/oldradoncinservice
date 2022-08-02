class StringValidator {
  bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = StringValidator();
  final StringValidator passwordValidator = StringValidator();
  final String invalidEmailErrorText = 'Invalid email';
  final String invalidPasswordErrorText = 'Invalid password';
}
