import '../handler/regex.dart';
String? defaultValidator(
    {required String? value, required String type, String? message}) {
  if (value == null ||
      value.trim() == "" ||
      value.isEmpty ||
      value.length < 1) {
    if (message != null) {
      return message;
    } else {
      return '$type should contain atleast 1 characters or above';
    }
  }
  return null;
}
String? usernameValidator(String? value) {
  String userPattern = r'(^[a-zA-Z0-9]{4,20}$)';
  if (value == null || regex(pattern: userPattern, input: value) == false) {
    return 'Username should contain 4 to 20 characters';
  }
  return null;
}
String? emailValidator(String value) {
  if ((value.isNotEmpty || value.contains('.com')|| value.contains('.in')|| value.contains('.org')|| value.contains('.net')|| value.contains('.co')||value.contains('.edu')||value.contains('.gov')||value.contains('.site')||value.contains('.it')||value.contains('.uk')||value.contains('.xyz')||value.contains('.info')||value.contains('.ru')||value.contains('.de')||value.contains('.ir')) == false ) {
    return 'Invalid Email';
  }
  return null;
}

String? forgotPasswordValidator(String? value) {
  if (value == null || value.isEmpty || !value.contains('@gmail.com')) {
    return 'Invalid Email';
  }
  return null;
}

String? passwordValidator({required String? value, String? message, bool? isCorrect}) {
  String passwordPattern = r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  if (value == null || regex(pattern: passwordPattern, input: value) == false) {
    if (message != null) {


      return null;
    }
    else {

      return 'Password should contain 8 and above characters, at least one uppercase letter,\none lowercase letter, one number and one symbol';

    }
  }
  return null;
}

String? resetPasswordValidator({required String? value, String? message}) {
  String passwordPattern =r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  if (value == null || regex(pattern: passwordPattern, input: value) == false) {
    if (message != null) {
      return null;
    } else {
      return 'Password should contain 8 and above characters, at least one uppercase letter, one lowercase letter, one number and one symbol';
    }
  }
  return null;
}

String? phoneValidator(String? value) {
  String phonePattern = r'(^(\+\d{1,3}[- ]?)?\d{10}$)';
 
  if (value == null || regex(pattern: phonePattern, input: value) == false) {
    return 'Enter the correct phone number';
  }
  return null;
}

String? otpValidator(String? value) {
  String otpPattern = r'(^[0-9]{6}$)';
  if (value == null || regex(pattern: otpPattern, input: value) == false) {
    return 'Enter the correct OTP';
  }
  return null;
}

String? intValidator(String? value, String type) {
  if (value == null ||
      (int.tryParse(value) == null &&
          int.tryParse(value).toString().length < 1)) {
    return '$type must be numeric(integer) and should contain more than 1 digits!';
  }
  return null;
}
