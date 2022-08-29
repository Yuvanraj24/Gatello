import 'package:flutter/material.dart';

class Showpage extends StatefulWidget {
  const Showpage({Key? key}) : super(key: key);

  @override
  State<Showpage> createState() => _ShowpageState();
}

class _ShowpageState extends State<Showpage> {
  var currentIndex=0;
  List statusimage=[
    'https://i.pinimg.com/474x/b3/be/65/b3be650a7e162b12eab155ab0839ee06--chota-bheem-goku.jpg',
    'https://www.chhotabheem.com/image/catalog/photo/1920X1200/cbha10.jpg',
    'https://static.digit.in/OTT/images/tr:n-ott_home_crousel/chhota-bheem-5fb5280d6734603ebee3c792.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:GestureDetector(
       onLongPressStart:(onPressed) {

       },
       child: Column(),
     ),
    );
  }
}
