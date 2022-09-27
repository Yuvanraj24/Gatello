import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';



class ReportCustomDialog extends StatefulWidget {
  @override
  _ReportCustomDialogState createState() => _ReportCustomDialogState();
}

class _ReportCustomDialogState extends State<ReportCustomDialog> {
  var _result;
  bool isSelcted=false;

  List<bool> _isChecked = [false, false, false];

  bool isChecked = false;
  showConfirmationDialog1(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ReportCustomDialog();
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
        height: 160.h,
        width: 380.w,
        padding: EdgeInsets.only(left: 12, top: 20, bottom: 0,right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10.w,),
                Text(
                  'Report',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 1))),
                ),
              ],
            ),
//


            SizedBox(height: 20.h),
            Row(
              children: [
                SizedBox(
                  width:12.5.w,
                ),
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      value: isChecked,
                      onChanged: (bool? value) {
                        // This is where we update the state when the checkbox is tapped
                        setState(() {
                          isChecked = value!;
                        });
                      }),
                ),
                SizedBox(
                  width: 7.w,
                ),
                Text(
                  'Block contact and report',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(157, 157, 157, 1))),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: GoogleFonts.inter(
                        textStyle: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 163, 255, 1))))),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(context: context, builder: (context) {
                    return  AlertDialog(shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),
                      title:Container(
                        child: Column(
                          children: [
                            Text('Thanks for the Report',style:GoogleFonts.inter(
                            textStyle:TextStyle(fontWeight:FontWeight.w600,fontSize:16.sp,color:Colors.red))),
                            SizedBox(height: 15.h),
                            Divider(thickness:0.2.h,color:Colors.grey,),
                            TextButton(
                                onPressed:() {
                               Navigator.pop(context);
                            }, child: Text('Ok',style:GoogleFonts.inter(textStyle: TextStyle(fontWeight:FontWeight.w700,fontSize:16.sp))))
                          ],
                        )),

                    );
                    },);
                  },
                  child: Text(
                    'Report',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 1))),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//-------------------------------------------------------------

class Messageinfo extends StatefulWidget {
  final msgData;
  final deliverTime;
  final readTime;
  final msgTime;
   Messageinfo({
    required this.msgData,
     required this.readTime,
    required this.deliverTime,
    required this.msgTime

});

  @override
  State<Messageinfo> createState() => _MessageinfoState();
}

class _MessageinfoState extends State<Messageinfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:GestureDetector(
            onTap:(){
              Navigator.pop(context);
            },
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/pops_asset/back_button.svg',height:35.h,
                  width:35.w,),
              ],
            )),
        title:Text('Ping Info',style:GoogleFonts.inter(fontWeight:FontWeight.w700,fontSize:16.sp,
        color:Colors.black),),
      ),
      body:Column(crossAxisAlignment:CrossAxisAlignment.start,
        children: [Align(alignment:Alignment.topRight,
          child: ConstrainedBox(constraints:BoxConstraints(
            minWidth:100.w,maxWidth:300.w,
            minHeight:45.h,maxHeight: MediaQuery.of(context).size.height
          ),
            child: Card(margin:EdgeInsets.only(right: 12.w,top: 18.h,bottom: 18.h),
              color:Color.fromRGBO(248, 206, 97, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("${widget.msgData}",style:GoogleFonts.inter(textStyle:TextStyle(
                    fontWeight:FontWeight.w400,fontSize:12.sp,color:Colors.black
                  )),),
                ),
            ),
          ),
        ),
          Container(
            child: Padding(
              padding:EdgeInsets.fromLTRB(20.w, 10.h,0.w, 0.h),
              child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                  children: [Row(children: [
                      Icon(Icons.done_all_rounded),SizedBox(width:10.w),
                      Text('Read',style:GoogleFonts.inter(fontWeight:FontWeight.w500,fontSize:16.sp))]),
                SizedBox(height:5.h),
                Text('${widget.readTime}',style:GoogleFonts.inter(fontWeight:FontWeight.w400,fontSize:12.sp,
                    color:Color.fromRGBO(130, 130, 130, 1))),
                SizedBox(height:18.h),
                Row(children: [
                      Icon(Icons.done_all_rounded,color:Colors.grey,),SizedBox(width:10.w),
                      Text('Delivered',style:GoogleFonts.inter(fontWeight:FontWeight.w500,fontSize:16.sp,))]),
                SizedBox(height:5.h),
                Text('${widget.msgTime}',style:GoogleFonts.inter(fontWeight:FontWeight.w400,fontSize:12.sp,
                    color:Color.fromRGBO(130, 130, 130, 1))),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}


