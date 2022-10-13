bool regex({required String pattern, required String input}) {
  return (input.isNotEmpty && input.trim() != "")
      ? new RegExp(pattern).hasMatch(input)
      : false;
}
bool isPassword(String str){
  return _pass.hasMatch(str);

}
RegExp _pass=RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');