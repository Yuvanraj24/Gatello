import 'package:flutter/material.dart';
import 'package:gatello/views/add_mob_no.dart';
import 'package:gatello/views/create_username.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({Key? key}) : super(key: key);

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
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
          actions: [
      
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 120, bottom: 50),
          child: Center(
            child:
                Column( children: [
              Text(
                "Set a password",
                style: TextStyle(
                  fontSize: currentWidth * 0.08,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
              SizedBox(height: currentHeight * 0.02),
              Text(
                "Just make sure it's at least 8 characters",
                style: TextStyle(
                    fontSize: currentWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(100, 99, 99, 1)),
              ),
              Text(
                "long",
                style: TextStyle(
                    fontSize: currentWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(100, 99, 99, 1)),
              ),
              Row(
                children: [
                  Container(
                    width: currentWidth * 0.82,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "PASSWORD",
                          labelStyle: TextStyle(fontSize: currentWidth * 0.04),
                          suffixIcon: IconButton(
                            iconSize: currentWidth * 0.07,
                            icon: Icon(Icons.visibility),
                            onPressed: () {},
                          )),
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
              onPressed: () {
                 Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddMobileNumber()));
              },
              child: Text(
                'Continue',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: currentWidth * 0.045,
                    fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  onPrimary: Colors.black,
                  padding: EdgeInsets.all(10),
                  minimumSize: Size(currentWidth * 0.7, currentHeight * 0.086),
                primary: Color.fromRGBO(248, 206, 97, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  )),
            ),
                   SizedBox(height: currentHeight * 0.03),
              Container(
              height: currentHeight * 0.007,
              width: currentWidth * 0.4,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(currentWidth * 0.9)),
            )
            ]),
          ),
        ),
      ),
    );
  }
}
