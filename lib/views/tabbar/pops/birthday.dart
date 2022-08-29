
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Birthday extends StatefulWidget {
  const Birthday({Key? key}) : super(key: key);

  @override
  State<Birthday> createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  late DateTime _myDateTime;
  String time='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Text(time),
            ElevatedButton(onPressed: ()async {

                  _myDateTime = (await  showDatePicker(context: context,
                 initialDate: DateTime.now(),
                 firstDate: DateTime(1950),
                 lastDate: DateTime(2050)))!;
                  setState(() {
                    time = DateFormat('dd-MM-yyyy').format(_myDateTime);
                  });
            }, child: Text('Tap me')),
          ],
        ),
      ),
    );

  }
}
