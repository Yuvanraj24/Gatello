import 'package:flutter/material.dart';

class CreateUsername extends StatefulWidget {
  const CreateUsername({Key? key}) : super(key: key);

  @override
  State<CreateUsername> createState() => _CreateUsernameState();
}

class _CreateUsernameState extends State<CreateUsername> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(
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
        padding: EdgeInsets.only(left: 10, right: 10, top: 120, bottom: 10),
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "Create Username",
              style: TextStyle(
                fontSize: currentWidth * 0.08,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            SizedBox(height: currentHeight * 0.02),
            Text(
              "Your friends use your username to find you",
              style: TextStyle(
                  fontSize: currentWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(100, 99, 99, 1)),
            ),
            Text(
              "on Gatello",
              style: TextStyle(
                  fontSize: currentWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(100, 99, 99, 1)),
            ),
            SizedBox(height: currentHeight * 0.02),
            Row(
              children: [
                Container(
                  width: currentWidth * 0.82,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: currentWidth * 0.04),
                      labelText: "USERNAME",
                      suffixIcon: IconButton(
                        iconSize: currentWidth * 0.07,
                        icon: Icon(Icons.refresh),
                        // splashRadius: 5,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  "assets/icons_assets/green_tick_icon.png",
                  width: currentWidth * 0.06,
                  height: currentHeight * 0.06,
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Color.fromRGBO(248, 206, 97, 1)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  fixedSize: Size(currentWidth * 0.6, currentHeight * 0.06),
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
