import 'package:flutter/material.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({Key? key}) : super(key: key);

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text("Back"),
        actions: [
          Text("Gatello"),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 150, bottom: 25),
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "Set a password",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Just make sure it's at least 8 characters",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(100, 99, 99, 1)),
            ),
            Text(
              "long",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(100, 99, 99, 1)),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "PASSWORD",
                  labelStyle: TextStyle(fontSize: 12),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {},
                  )),
            ),
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
          ]),
        ),
      ),
    );
  }
}
