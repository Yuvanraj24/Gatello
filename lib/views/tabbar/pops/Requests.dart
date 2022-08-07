import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class Requests_Page extends StatefulWidget {
  const Requests_Page({Key? key}) : super(key: key);

  @override
  State<Requests_Page> createState() => _Requests_PageState();
}

class _Requests_PageState extends State<Requests_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Color.fromRGBO(12, 16, 29, 1),),
        title: Text('Requests',style: GoogleFonts.inter(
          textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1),fontWeight: FontWeight.w400,fontSize:22)
        ),),
      ),
      body:ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
        return request_List();
      },)

    );
  }
}
Widget request_List (){
  return  Padding(
    padding: const EdgeInsets.only(top: 16,left: 12),
    child: Column(
      children: [
        Row(
          children: [
            Container( height: 49.h,width: 50.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage('https://loveshayariimages.in/wp-content/uploads/2021/10/DP-for-Whatsapp-Profile-Pics-HD.jpg'),
                      fit: BoxFit.fill)
              ),),
            SizedBox(width: 14.w),
            Text('Angelena_123',style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 16.sp,fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(0, 0, 0, 1)
                )
            ),),
            SizedBox(width: 142.w),
            Text('11:20 AM',style: GoogleFonts.inter(
                textStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1),fontWeight: FontWeight.w400,fontSize:12)),)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Divider(thickness:2,color: Color.fromRGBO(26, 52, 130, 0.06),indent:70,endIndent: 13),
        )
      ],
    ),
  );
}