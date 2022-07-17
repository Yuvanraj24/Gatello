import '../handler/regex.dart';

String? defaultValidator({required String? value, required String type, String? message}) {
  if (value == null || value.trim() == "" || value.isEmpty || value.length < 1) {
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

String? emailValidator(String? value) {
  String emailPattern = r"^[a-zA-Z0-9.!#$%&'*+=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
  if (value == null || regex(pattern: emailPattern, input: value) == false) {
    return 'Enter the correct email id';
  }
  return null;
}

String? passwordValidator({required String? value, String? message}) {
  String passwordPattern = r'(^(?=.*[a-z])(?=.*\d)(?=.*[@#_%-])[A-Za-z\d@#_%-]{6,}$)';
  if (value == null || regex(pattern: passwordPattern, input: value) == false) {
    if (message != null) {
      return message;
    } else {
      return 'Password should contain 8 and above characters, at least one uppercase letter, one lowercase letter, one number and one symbol';
    }
  }
  return null;
}

String? phoneValidator(String? value) {
  String phonePattern = r'(^(\+\d{1,3}[- ]?)?\d{10}$)';
  // r'((?:\+|00)[17](?: |\-)?|(?:\+|00)[1-9]\d{0,2}(?: |\-)?|(?:\+|00)1\-\d{3}(?: |\-)?)?(0\d|\([0-9]{3}\)|[1-9]{0,3})(?:((?: |\-)[0-9]{2}){4}|((?:[0-9]{2}){4})|((?: |\-)[0-9]{3}(?: |\-)[0-9]{4})|([0-9]{7}))';
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
  if (value == null || (int.tryParse(value) == null && int.tryParse(value).toString().length < 1)) {
    return '$type must be numeric(integer) and should contain more than 1 digits!';
  }
  return null;
}
