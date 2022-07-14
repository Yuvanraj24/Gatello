import 'package:flutter/material.dart';
import 'package:gatello/views/add_mob_no.dart';
import 'package:gatello/views/otp_screen.dart';

class AddEmail extends StatefulWidget {
  const AddEmail({Key? key}) : super(key: key);

  @override
  State<AddEmail> createState() => _AddEmailState();
}

class _AddEmailState extends State<AddEmail> {
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
          padding: EdgeInsets.only(
            left: currentWidth*0.03, 
        right: currentWidth*0.03, 
           top: currentHeight*0.2, 
           bottom: currentHeight*0.035),
          child: Center(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                "Add your email address",
                 style: TextStyle(
                fontSize: currentHeight*0.0345,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              ),
              SizedBox(height: currentHeight*0.015),
              Text(
                "This can help recover your account if you",
                style: TextStyle(
                    fontSize: currentWidth*0.037,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(100, 99, 99, 1)),
              ),
               SizedBox(height: currentHeight*0.006),
              Text(
                "forget your password!",
                style: TextStyle(
                  fontSize: currentWidth*0.037,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(100, 99, 99, 1)),
              ),
             // SizedBox(height: currentHeight*0.000),
              TextFormField(
                
                cursorColor: Colors.black,
                decoration: InputDecoration(
       
                  labelStyle: TextStyle(fontSize: currentWidth*0.035,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
                  ),
                  
                  labelText: "EMAIL",
                ),
              ),
              Spacer(),
           ElevatedButton(
              onPressed: () {
                 Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Otp()));
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
            SizedBox(height: currentHeight*0.03,),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
    height:currentHeight*0.007,
    width: currentWidth*0.4,
    decoration: BoxDecoration(
      color: Colors.black,
    borderRadius: BorderRadius.circular(currentWidth*0.9)
    ),
    
                ),
                     ],
                   )
            ]),
          ),
        ),
      ),
    );
  }
}
