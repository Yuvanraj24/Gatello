import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



class BioDialog extends StatefulWidget {
  @override
  _BioDialogState createState() => _BioDialogState();
}

class _BioDialogState extends State<BioDialog> {
  TextEditingController _alert1=TextEditingController();
  var _result;
  bool isSelcted=false;
  final List<String> items = ['Public', 'Friends', 'Only me'];
  String? selectedValue;
  bool isSwitched = false;

  List<bool> _isChecked = [false, false, false];

  bool isChecked = false;
  showConfirmationDialog(BuildContext context) {
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BioDialog();
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
        width:336.w,height:293.h,decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8)
      ),child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left:16,top:17,right:17),
          child: Row(children: [
            Text(
              'Biog',
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(0, 0, 0, 1))),
            ),SizedBox(width:126.w,),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 7, left: 9, bottom: 6),
                        child: Text(
                          'Public',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.sp,
                                  color: Color.fromRGBO(0, 0, 0, 1))),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                  });
                },
                icon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: Color.fromRGBO(12, 16, 29, 1),
                  ),
                ),
                iconSize: 14,
                buttonHeight: 30,
                buttonWidth: 86,
                buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Color.fromRGBO(248, 206, 97, 1)),
                itemHeight: 40,
                // itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 90,
                dropdownWidth: 90,
                buttonElevation: 0,
                dropdownElevation: 0,
                dropdownDecoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                scrollbarAlwaysShow: false,
              ),
            ),Spacer(),
            GestureDetector(onTap: (){
              Navigator.pop(context);
            },
              child: Text('Cancel',style: GoogleFonts.inter(textStyle: TextStyle(
                  fontSize:14.sp,fontWeight: FontWeight.w400,color: Color.fromRGBO(0, 163, 255, 1)
              )),),
            )
          ],),
        ),
        SizedBox(height:10.h),
        TextField(controller:_alert1,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1.w,
                      color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10)),
              hintText:'Your professional',hintStyle:GoogleFonts.inter(
              textStyle:TextStyle(fontWeight:FontWeight.w400,fontSize: 14.sp,
                  color: Color.fromRGBO(118, 118, 118, 1))
          )
          ),),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom:17),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                primary:Color.fromRGBO(248, 206, 97, 1),fixedSize: Size(302.w,36.h),
              ),
              onPressed: (){
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
