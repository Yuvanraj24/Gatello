import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class SelectBirthday extends StatefulWidget {
  const SelectBirthday({Key? key}) : super(key: key);

  @override
  State<SelectBirthday> createState() => _SelectBirthdayState();
}

class _SelectBirthdayState extends State<SelectBirthday> {
  //DateTime _selectedDate = DateTime.now();
  //DateTime? _selectedDate;
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 15,
          ),
          child: Text(
            "Back",
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          Text("Gatello"),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 150, left: 15, right: 15, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "When's your birthday?",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(textStyle: TextStyle(fontSize: 12)),
                child: Text("Why do I need to provide my date of birth?")),

            TextFormField(
              onTap: () {},
              decoration: InputDecoration(labelText: "Birthday"),
            ),
            SizedBox(height: 30),

            ElevatedButton(
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1980),
                          lastDate: DateTime(2022))
                      .then((date) {
                    setState(() {
                      _dateTime = date;
                    });
                    print(_dateTime);
                  });
                },
                child: Text("Date Pick")),
            // DatePickerWidget(
            //   looping: true, // default is not looping
            //   firstDate: DateTime.now(), //DateTime(1960),
            //   //  lastDate: DateTime(2002, 1, 1),
            //   //initialDate: DateTime.now(),// DateTime(1994),
            //   dateFormat:
            //       // "MM-dd(E)",
            //       "dd/MMMM/yyyy",
            //   //     locale: DatePicker.localeFromString('he'),
            //   onChange: (DateTime newDate, _) {
            //     setState(() {
            //       _selectedDate = newDate;
            //     });
            //     print(_selectedDate);
            //   },
            //   pickerTheme: DateTimePickerTheme(
            //     itemHeight: 20,
            //     itemTextStyle: TextStyle(
            //         color: Color.fromRGBO(248, 206, 97, 1), fontSize: 19),
            //     dividerColor: Colors.black,
            //   ),
            // ),
            Spacer(),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Color.fromRGBO(248, 206, 97, 1)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  fixedSize: Size(180, 40),
                  primary: Color.fromRGBO(248, 206, 97, 1),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.black),
                )),
            Divider(
              color: Colors.black,
              height: 35,
              endIndent: 70,
              indent: 80,
              thickness: 3.5,
            ),
          ],
        ),
      ),
    );
  }
}
