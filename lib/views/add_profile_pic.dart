import 'package:flutter/material.dart';

class AddProfilePic extends StatefulWidget {
  const AddProfilePic({Key? key}) : super(key: key);

  @override
  State<AddProfilePic> createState() => _AddProfilePicState();
}

class _AddProfilePicState extends State<AddProfilePic> {
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
        padding: EdgeInsets.only(left: 15, right: 15, top: 120, bottom: 10),
        child: Column(children: [
          Text(
            "Add profile photo",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Add a profile photo so that your friends know its you.",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(100, 99, 99, 1)),
          ),
          SizedBox(height: 50),
          Image.asset("assets/profile_page/profile_pic_logo.png"),
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
                "Add a photo",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(onPressed: () {},
          style: TextButton.styleFrom(
            primary: Color.fromRGBO(0, 0, 0, 0.44)
          ),
          child: Text("Skip")),
          Divider(
            color: Colors.black,
            height: 35,
            endIndent: 70,
            indent: 80,
            thickness: 3.5,
          ),
        ]),
      ),
    );
  }
}
