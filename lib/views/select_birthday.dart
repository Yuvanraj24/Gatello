import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gatello/views/create_username.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';



import 'birthday_on_gatello.dart';

class SelectBirthday extends StatefulWidget {





  @override
  State<SelectBirthday> createState() => _SelectBirthdayState();
}

class _SelectBirthdayState extends State<SelectBirthday> {
  DateTime? _selectedDate;
  late DateTime _myDateTime;
  String time='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          Text("Gatello"),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 150.h, left: 15.w, right: 15.w, bottom: 35.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'What\'s Your Name?',
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
                child: Text("Why do I need to provide my date of birth?",style:
                  GoogleFonts.inter(fontWeight:FontWeight.w500,fontSize:11.sp))),
            TextFormField(
              cursorColor:Colors.white,
              onTap: () async {
                _myDateTime = (await  showDatePicker(context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime(2050)))!;
                setState(() {
                time = DateFormat('dd-MM-yyyy').format(_myDateTime);
                });
              },
              controller: TextEditingController(text: time.toString()),
              decoration: InputDecoration(labelText: "Birthday",
              hintText:time),
            ),
            SizedBox(height: 30),


            Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateUsername(name: '', birthDay: '',),
                      ));

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
    );
  }
}
