import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  bool isSelected=false;
  void callBack(){
    setState(() {
      isSelected==true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
      body: Container(child:isSelected? Text('check1'):Text('check2')),
    );
  }
}
class Testing2 extends StatelessWidget {
  final Function callBack;
  const Testing2({Key? key,required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
      body: Container(

        child: ElevatedButton(onPressed: (){
          callBack();
        },child: Text('press this')),
      ),
    );
  }
}
