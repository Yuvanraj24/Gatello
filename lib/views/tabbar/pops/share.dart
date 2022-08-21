import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class Share_Page extends StatefulWidget {
  const Share_Page({Key? key}) : super(key: key);

  @override
  State<Share_Page> createState() => _Share_PageState();
}

class _Share_PageState extends State<Share_Page> {
  TextEditingController _share=TextEditingController();
  TextEditingController _share1=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(height:560.h,
        padding: EdgeInsets.only(left:12,right: 13,top: 10),
        child: Column(
          children: [
            Divider(
              endIndent:154,
              indent:154,
              thickness: 2,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
            Row(
              children: [
                Container(height:57.h , width:59.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: NetworkImage('https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                    fit: BoxFit.fill)
                  ),
                ),
                SizedBox(width: 12.w,),
                Container(width:240.w,
                    child: TextFormField(
                      cursorColor:Colors.black,
                      controller:_share1,
                      decoration:InputDecoration(
                        hintText:'Write something here...',
                        hintStyle:GoogleFonts.inter(
                            textStyle:TextStyle(
                                color:Color.fromRGBO(140, 140, 140, 1),fontSize:12,
                                fontWeight:FontWeight.w400
                            )
                        ),
                        enabledBorder:OutlineInputBorder(
                            borderSide:(BorderSide(
                                color:Colors.transparent
                            ))
                        ),
                        focusedBorder:OutlineInputBorder(
                            borderSide:(BorderSide(
                                color:Colors.transparent
                            ))
                        ),
                      ),
                    ))
              ],
            ),

            Padding(
              padding: EdgeInsets.only(top: 17,left: 12,right: 13),
              child: Row(
                children: [
                  Text('Share to...',style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      fontSize: 16.sp,fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(0, 0, 0, 1)
                    )
                  ),),
                ],
              ),
            ),
            SizedBox(height:20.h,),
            Container(height:35.h,width:335.w, decoration: BoxDecoration(
                color:Color.fromRGBO(232, 232, 232, 1),borderRadius:BorderRadius.circular(4)),
              child: Row(children: [
                SizedBox(width:18.w),
                Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/pops_asset/searchicon.svg',height:18.h,
                      width:18.w,),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top:19,left:18),
                  height:35.h,width:200.w,
                  child: TextField(controller:_share,
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
                        hintText:'Peter Parker',hintStyle:GoogleFonts.inter(
                        textStyle:TextStyle(fontWeight:FontWeight.w400,fontSize: 14.sp,
                            color: Color.fromRGBO(118, 118, 118, 1))
                    )
                    ),),
                )
              ],),
            ),
            SizedBox(height: 18,),
            Container(
              child: Expanded(
                child: ListView.builder(itemCount: 20,
                    itemBuilder: (context,index){
                  return
                      ListTile(
                        trailing: ElevatedButton(style: ElevatedButton.styleFrom(elevation: 0,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          primary: Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(76.w, 32.h),
                        ),
                            onPressed: (){}, child: Text('Send',style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),fontSize: 12,fontWeight: FontWeight.w700
                          )
                        ),)),
                        leading: Container(
                          height: 57.h,width: 57.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            image: DecorationImage(image: NetworkImage('https://loveshayariimages.in/wp-content/uploads/2021/10/DP-for-Whatsapp-Profile-Pics-HD.jpg'),
                            fit: BoxFit.fill)
                          ),
                        ),
                        title: Text('Peter Parker',style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontSize: 16.sp,fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(0, 0, 0, 1)
                          )
                        ),),
                        subtitle:Text('Peter',style: GoogleFonts.inter(
                          textStyle: TextStyle(fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(70, 70, 70, 1),fontSize: 14
                          )
                        ),) ,
                      );

                }),
              ),
            )
          ],
        ),

    );
  }
}

