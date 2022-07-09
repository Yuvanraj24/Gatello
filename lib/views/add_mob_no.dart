import 'package:flutter/material.dart';

class AddMobileNumber extends StatefulWidget {
  const AddMobileNumber({Key? key}) : super(key: key);

  @override
  State<AddMobileNumber> createState() => _AddMobileNumberState();
}

class _AddMobileNumberState extends State<AddMobileNumber> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 120, bottom: 10),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      "Almost done!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Add  your mobile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                    Text(
                      "number?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "You will be using this mobile number to login into",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(100, 99, 99, 1)),
                    ),
                    Text(
                      "your account.",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(100, 99, 99, 1)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("MOBILE NUMBER",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color.fromRGBO(0, 0, 0, 1))),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'icons/flags/png/in.png',
                              package: 'country_icons',
                              width: 21,
                              //height: 21,
                            ),
                            SizedBox(width: 8),
                            Text("India",
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.arrow_drop_down),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    //2nd field
                    Row(
                      children: [
                        Container(
                            width: 45,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(top: 2, bottom: 0.1),
                                  prefixIcon: Center(
                                      child: Text(
                                    "+${91}",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ))),
                            )),
                        SizedBox(width: 10),
                        Container(
                          width: currentWidth - 85,
                          child: TextFormField(
                            decoration: InputDecoration(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
                    Text(
                      "We'll send you a text verification code.",
                      style: TextStyle(
                        color: Color.fromRGBO(100, 99, 99, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                        ),
                    ),
              Spacer(),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Color.fromRGBO(248, 206, 97, 1)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    fixedSize: Size(currentWidth - 100, 50),
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                    primary: Color.fromRGBO(248, 206, 97, 1),
                  ),
                  child: Text(
                    "Verify mobile number",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700
                      ),
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
        ));
  }
}
