import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatello/views/create_username.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../Helpers/StateHelper.dart';
import 'birthday_on_gatello.dart';

class SelectBirthday extends StatefulWidget {
  String name;
  SelectBirthday({
    required this.name,
  });

  @override
  State<SelectBirthday> createState() => _SelectBirthdayState();
}

class _SelectBirthdayState extends State<SelectBirthday> {

  String? name;
  String? pageNo;
  late DateTime _selectedDate;
  late DateTime _myDateTime;
  DateTime currentDate = DateTime.now();
  TextEditingController Datepick =TextEditingController();

  @override
  void initState() {
    print('init called');
    name=getData("name1");
    pageNo=getData("page");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomInset:false,
        appBar: AppBar(
          leading: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back',
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
              )),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: EdgeInsets.only(top: 150.h, left: 15.w, right: 15.w, bottom: 35.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'When\'s Your Birthday?',
                  style: GoogleFonts.fredoka(
                      textStyle: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>
                          BirthdayGatello()));
                    },
                    child: Text("Why do I need to provide my date of birth?",
                        style: GoogleFonts.inter(fontWeight:FontWeight.w500,fontSize:11.sp))),
                SizedBox(height:15.h,),

                DatePickerWidget(
                  looping: false,
                  firstDate: DateTime(1800),
                  lastDate: DateTime(2006),
                  dateFormat:
                  // "MM-dd(E)",
                  "dd/MMMM/yyyy",
                  onChange: (DateTime newDate, a) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                    print("this is date :${_selectedDate}");
                  },
                  pickerTheme: DateTimePickerTheme(confirmTextStyle:TextStyle(color: Colors.yellow),
                    cancelTextStyle:TextStyle(color: Colors.yellow),
                    backgroundColor: Colors.transparent,
                    itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                    dividerColor: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      int yearDiff = currentDate.year - _selectedDate.year;
                      int monthDiff = currentDate.month - _selectedDate.month;
                      int dayDiff = currentDate.day - _selectedDate.day;
                      print("Year diff : ${yearDiff}");
                      print("month diff : ${monthDiff}");
                      print("day diff : ${dayDiff}");
                      if(yearDiff > 16 || yearDiff == 16 && monthDiff >= 0 && dayDiff >= 0){
                        setData("dob", _selectedDate.toString());
                        setData("page","3");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateUsername(name: widget.name, birthDay: _selectedDate.toString(),),
                            ));
                      }else{
                        Fluttertoast.showToast(msg: "You are not eligible");
                      }


                    },
                    style:ElevatedButton.styleFrom(primary:Color.fromRGBO(248, 206, 97, 1),
                        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(27)),
                        fixedSize: Size(234.w, 50.h)),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    )),
              ],
            ),
          ),
        ),
      ),)
    );
  }
}
