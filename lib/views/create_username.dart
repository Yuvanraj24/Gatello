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
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "Create Username",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Your friends use your username to find you",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(100, 99, 99, 1)),
            ),
            Text(
              "on Gatello",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(100, 99, 99, 1)),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Container(
                  width: currentWidth * 0.85,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 12),
                      labelText: "USERNAME",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  "assets/icons_assets/green_tick_icon.png",
                  width: 18.6,
                  height: 18.6,
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {

                  
                },
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
