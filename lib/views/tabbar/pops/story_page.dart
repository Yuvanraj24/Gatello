import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Story_Page extends StatefulWidget {
  const Story_Page({Key? key}) : super(key: key);

  @override
  State<Story_Page> createState() => _Story_PageState();
}

class _Story_PageState extends State<Story_Page> {
  TextEditingController _controller0=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
      title: Text('upload'),
    ),
      body: Column(
        children: [

        Row(
          children: [
            IconButton(
                onPressed: (){

                }, icon: Icon(Icons.close)),
            Spacer(),
            IconButton(
                onPressed: (){

                },
                icon: Icon(Icons.check_rounded)),
          ],
        ),

        Center(
          child: Container(
            height:650,width:double.infinity,
            child: Image.network('https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _controller0,
            decoration: InputDecoration(filled: true,fillColor: Colors.grey,
              prefixIcon:Icon(Icons.insert_emoticon_outlined,color: Colors.white,),
              suffixIcon:Icon(Icons.send,size:30,color: Colors.green,),
              enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(20),
                borderSide: BorderSide(
                  color:  Colors.green,
                ),
              ),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)
              ),
              hintText: 'Type here...',
              hintStyle: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(118, 118, 118, 1))),
            ),
          ),
        ),
      ],
      ),
    );
  }
}
