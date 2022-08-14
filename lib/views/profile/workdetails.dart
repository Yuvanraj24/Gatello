import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class WorkDetailsDialog extends StatefulWidget {

  @override
  _WorkDetailsDialogState createState() => _WorkDetailsDialogState();
}

class _WorkDetailsDialogState extends State<WorkDetailsDialog> {
  bool isSelcted=false;
  final List<String> items = ['Public', 'Friends', 'Only me'];
  String? selectedValue;
  bool isSwitched = false;

  final _from=TextEditingController();
  final _to=TextEditingController();
  final _position=TextEditingController();
  final _company=TextEditingController();
  final _location=TextEditingController();

  List<bool> _isChecked = [false, false, false];

  bool isChecked = false;
  showConfirmationDialog(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WorkDetailsDialog();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: EdgeInsets.only(left: 12, right: 12),
      titlePadding: EdgeInsets.all(0),
      title: Container(
        width:336.w,height:323.h,decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8)
      ),child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left:16,top:17,right:17),
          child: Row(children: [
            Spacer(),
            GestureDetector(onTap: (){
              Navigator.pop(context);
            },
              child: Text('Cancel',style: GoogleFonts.inter(textStyle: TextStyle(
                  fontSize:14.sp,fontWeight: FontWeight.w400,color: Color.fromRGBO(0, 163, 255, 1)
              )),),
            )
          ],),
        ),
        Container(padding:EdgeInsets.only(left:18,top:40,right:18),
          child: Column(
            children: [
              Row(
                children: [
                  Text('From',style: GoogleFonts.inter(textStyle: TextStyle(
                      fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                  )),),SizedBox(width:9.w),
                  Container(height:26.h,width:101.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                  child: Container(
                    height:25.h,width:100.w,
                    child: TextField(
                      autofocus: true,
                      controller:_from,
                      onChanged: (val){

                      },
                      cursorColor:Colors.black,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.w,
                                  color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10)),
                      ),),
                  )
                  ),
                  Spacer(),
                  Text('To',style: GoogleFonts.inter(textStyle: TextStyle(
                      fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                  )),),SizedBox(width:9.w),
                  Container(height:26.h,width:101.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                  child:  Container(
                    height:25.h,width:100.w,
                    child: TextField(
                      autofocus: true,
                      controller:_to,
                      cursorColor:Colors.black,
                      decoration: InputDecoration(

                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1.w,
                                color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10)),
                      ),),
                  ),)
                ],
              ),
              SizedBox(height:17.h),
              Row(
                children: [
                  Text('Position',style: GoogleFonts.inter(textStyle: TextStyle(
                      fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                  )),),SizedBox(width:11.w),
                  Container(height:26.h,width:240.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                      child: Container(
                        height:25.h,width:100.w,
                        child: TextField(
                          autofocus: true,
                          controller:_position,
                          cursorColor:Colors.black,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10)),
                          ),),
                      )
                  ),
                ],
              ),
              SizedBox(height:17.h),
              Row(
                children: [
                  Text('Company',style: GoogleFonts.inter(textStyle: TextStyle(
                      fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                  )),),SizedBox(width:11.w),
                  Container(height:45.h,width:228.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                      child: Container(
                        height:25.h,width:100.w,
                        child: TextField(
                          autofocus: true,
                          controller:_company,
                          cursorColor:Colors.black,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10)),
                          ),),
                      )
                  ),
                ],
              ),
              SizedBox(height:17.h),
              Row(
                children: [
                  Text('Location',style: GoogleFonts.inter(textStyle: TextStyle(
                      fontSize:14.sp,fontWeight: FontWeight.w700,color: Color.fromRGBO(0,0,0, 1)
                  )),),SizedBox(width:11.w),
                  Container(height:26.h,width:234.w,decoration: BoxDecoration(color:Color.fromRGBO(217, 217, 217, 1)),
                      child: Container(
                        height:25.h,width:100.w,
                        child: TextField(
                          autofocus: true,
                          controller:_location,
                          cursorColor:Colors.black,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.w,
                                    color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10)),
                          ),),
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom:17),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                primary:Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(302.w,36.h),
              ),
              onPressed: (){
              setState(() {
                print(_from.text);
                print(_to.text);
                print(_position.text);
                print(_company.text);
                print(_location.text);
              });
               Navigator.pop(context);
              }, child: Text('Save',style: GoogleFonts.inter(
              textStyle: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),fontSize:20,fontWeight: FontWeight.w700
              )
          ),)),
        ),
      ],),
      ),
    );
  }
}
