import 'package:flutter/material.dart';
class TernaryOper extends StatefulWidget {
  const TernaryOper({Key? key}) : super(key: key);

  @override
  State<TernaryOper> createState() => _TernaryOperState();
}

class _TernaryOperState extends State<TernaryOper> {
  int num=1;
  bool check=false;
bool fun=false;
bool pay=false;
bool nxt=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: Container(child: Center(child:
      (num==1)?(check==false)?(fun==true)?Text('555'):Text('333'):Text('444'):(pay==false)?Text('666'):Text('777')


    ),));
  }
}
