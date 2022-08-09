import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Calls_page extends StatefulWidget {
  const Calls_page({Key? key}) : super(key: key);

  @override
  State<Calls_page> createState() => _Calls_pageState();
}

class _Calls_pageState extends State<Calls_page> {
  @override
  Widget build(BuildContext context) {
    return
     Scaffold(
       body: Column(
          children:[ Padding(
            padding: EdgeInsets.only(top:150,left: 65,right: 65),
            child: Container(
              height: 201.h,width: 229.w,
             child: SvgPicture.asset('assets/call_assets/noconversation.svg'),
            ),
          ),
        ]
        ),
       floatingActionButton: FloatingActionButton(onPressed: (){},
       backgroundColor:Color.fromRGBO(248, 206, 97, 1),),
     );
    

  }
}
