import 'package:flutter/material.dart';

class BirthdayGatello extends StatefulWidget {
  const BirthdayGatello({Key? key}) : super(key: key);

  @override
  State<BirthdayGatello> createState() => _BirthdayGatelloState();
}

class _BirthdayGatelloState extends State<BirthdayGatello> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
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
          Image(
            image: AssetImage("assets/appbar_action/Rectangle 7.png"),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50, bottom: 15, left: 15, right: 15),
        child: Column(children: [
          Container(
              width: currentWidth,
              height: currentHeight * 0.3,
              child: Image(
                  image:
                      AssetImage("assets/birthday_image/birthday_logo.png"))),
          SizedBox(height: 16),
          Text(
            "Birthday on Gatello",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Providing your date of birth improves the feature you",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(100, 99, 99, 1)),
          ),
          Text(
            "see and helps us keep the Gatello community safe.",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(100, 99, 99, 1)),
          ),
          Text(
            "You can find your date of birth under “Personal",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(100, 99, 99, 1)),
          ),
          Text(
            "information” in your account settings.",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(100, 99, 99, 1)),
          ),
          Spacer(),
          Divider(
            color: Colors.black,
            height: 35,
            endIndent: 70,
            indent: 80,
            thickness: 3.5,
          )
        ]),
      ),
    );
  }
}
