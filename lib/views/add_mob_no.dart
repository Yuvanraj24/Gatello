import 'package:flutter/material.dart';
import 'package:gatello/views/add_email.dart';

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
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
                    toolbarHeight: currentHeight*0.07,
             leading: Center(
            child: 
           TextButton(onPressed: (){
              Navigator.pop(context);
           }, child: Text('Back',
           style: TextStyle(          
              color: Colors.black,
              fontSize: currentWidth*0.038,
              fontWeight: FontWeight.w600            
           ),
              ),
             )
          ),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 80, bottom: 20),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Almost done!",
                        style: TextStyle(
                          fontSize: currentWidth * 0.07,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      SizedBox(height: currentHeight * 0.02),
                      Text(
                        "Add  your mobile",
                        style: TextStyle(
                          fontSize: currentWidth * 0.08,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      Text(
                        "number?",
                        style: TextStyle(
                          fontSize: currentWidth * 0.08,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      SizedBox(height: currentHeight * 0.02),
                      Text(
                        "You will be using this mobile number to login into",
                        style: TextStyle(
                            fontSize: currentWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(100, 99, 99, 1)),
                      ),
                      Text(
                        "your account.",
                        style: TextStyle(
                            fontSize: currentWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(100, 99, 99, 1)),
                      )
                    ],
                  ),
                ),
                SizedBox(height: currentHeight * 0.02),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("MOBILE NUMBER",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: currentWidth * 0.05,
                              color: Color.fromRGBO(0, 0, 0, 1))),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'icons/flags/png/in.png',
                                package: 'country_icons',
                                width: currentWidth * 0.10,
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
                              width: currentWidth * 0.19,
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
                          SizedBox(height: currentHeight * 0.02),
                          Container(
                            width: currentWidth * 0.68,
                            child: TextFormField(
                              decoration: InputDecoration(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: currentHeight * 0.02),
                Text(
                  "We'll send you a text verification code.",
                  style: TextStyle(
                      color: Color.fromRGBO(100, 99, 99, 1),
                      fontSize: currentWidth * 0.039,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
    
                       Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddEmail()));
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Color.fromRGBO(248, 206, 97, 1)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      fixedSize: Size(currentWidth * 0.6, currentHeight * 0.06),
                      //padding: EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                      primary: Color.fromRGBO(248, 206, 97, 1),
                    ),
                    child: Text(
                      "Verify mobile number",
                      style: TextStyle(
                          fontSize: currentWidth * 0.04,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    )),
                SizedBox(height: currentHeight * 0.02),
                Container(
                  height: currentHeight * 0.007,
                  width: currentWidth * 0.42,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(currentWidth * 0.92)),
                ),
              ],
            ),
          )),
    );
  }
}
