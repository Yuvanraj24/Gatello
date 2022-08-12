import 'package:flutter/material.dart';

class Bulletpoint extends StatefulWidget {

  const Bulletpoint({Key? key}) : super(key: key);
  @override
  State<Bulletpoint> createState() => _BulletpointState();
}

class _BulletpointState extends State<Bulletpoint> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController=TextEditingController();
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
