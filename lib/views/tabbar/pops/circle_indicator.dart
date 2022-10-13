import 'package:flutter/material.dart';

class CircleIndicator extends StatelessWidget {
  const CircleIndicator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(child: Image.asset('assets/pops_asset/gatello_loading2.gif',width:200 ,height: 200,)),
    );
  }
}
