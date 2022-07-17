import 'package:flutter/material.dart';

class SelectedContact extends StatefulWidget {
  const SelectedContact({Key? key}) : super(key: key);

  @override
  State<SelectedContact> createState() => _SelectedContactState();
}

class _SelectedContactState extends State<SelectedContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/per_chat_icons/back_icon.png"),
      ),
    );
  }
}
