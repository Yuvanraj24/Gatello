import 'package:flutter/material.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  
  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
  appBar: AppBar( leading: Center(
          child: 
         TextButton(onPressed: (){
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
         }, child: Text('Back',
         style: TextStyle(          
            color: Colors.black,
            fontSize: width*0.038,
            fontWeight: FontWeight.w600            
         ),
            ),
           )
        ),
      ),
body: Container(

  child:   Column(
  
    mainAxisAlignment: MainAxisAlignment.start,
  
    
  
    children: [
  
  SizedBox(height: height*0.12,),
  
      Image(image: AssetImage(
  
        'assets/forgot_scren_image/Group 677.png'),
  
        width: width*0.251,),
  
      SizedBox(height:height*0.012),
  
        Row(
  
              mainAxisAlignment: MainAxisAlignment.center,
  
              children: [
  
                Text(
  
                  'Forgot Your Password?',
  
                  style: TextStyle(
  
                      fontSize: width * 0.073,
  
                      fontWeight: FontWeight.w700,
  
                      color: Colors.black),
  
                ),
  
                  SizedBox(height: height*0.047,),
  
            
  
              ],
  
            ),
  
              SizedBox(height:height*0.0058 ),
  
            Text(
  
              'No Worries! Enter your email and we will send',
  
              style: TextStyle(
  
                  fontSize: width * 0.04,
  
                  fontWeight: FontWeight.w400,
  
              
  
                  color: HexColor('#9A9A9A')),
  
            ),
  
             Text(
  
              'you a reset',
  
              style: TextStyle(
  
                  fontSize: width * 0.04,
  
                  fontWeight: FontWeight.w400,
  
                  color:  HexColor('#9A9A9A')),
  
            ),
  
             SizedBox(height:height*0.033 ),
  
             Container(
  
            height: height * 0.052,
  
            width: width * 0.93,
  
            child: TextFormField(
  
              cursorColor: Colors.black,
  
       
  
     
  
              decoration: InputDecoration(
  
                 contentPadding: EdgeInsets.only(
                  top: 20,
                 bottom: 24,
               
                 ),
  
          
  
  prefixIcon: Container(
    margin: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
   // color: Colors.pink,
height: 1,width: 1,
    child: Image(image:
    AssetImage('assets/email_image/Group 680.png'),
   // width: width*0.05,height: height*0.05
    ),
  ),
          
  
                hintText: '@email.com',
  
             hintStyle: TextStyle(
  
              
  
                    fontSize: width * 0.04,
  
                    color:HexColor('#B7B7B7'),
  
                    fontWeight: FontWeight.w600),
  
          
  
                focusedBorder: OutlineInputBorder(
  
                  borderSide:
  
                      BorderSide(color:  HexColor('#585858'),
  
                       width: width * 0.002),
  
                ),
  
                enabledBorder: OutlineInputBorder(
  
                    borderSide:
  
                        BorderSide(color: Colors.black, 
  
                        width: width * 0.0017),
  
                    borderRadius: BorderRadius.circular(
  
                      width*0.015,
  
                    )),
  
              ),
  
            ),
  
          ),
  
          SizedBox(height: height*0.04),
  
            ElevatedButton(
  
              onPressed: () {
  
                // Navigator.push(context,
  
                //     MaterialPageRoute(builder: (context) => LoginScreen()));
  
              },
  
              child: Text(
  
                'Send request',
  
                style: TextStyle(
  
                    color: Colors.black,
  
                    fontSize: width * 0.045,
  
                    fontWeight: FontWeight.w700),
  
              ),
  
              style: ElevatedButton.styleFrom(
  
                 
  
                  padding: EdgeInsets.all(10),
  
                  minimumSize: Size(width * 0.98,
  
                   height * 0.073),
  
                  primary: HexColor('#F8CE61'),
  
             
  
                  shape: RoundedRectangleBorder(
  
                    borderRadius: BorderRadius.circular(width*0.015),
  
                  )),
  
            ),
  
          
  
  Spacer(),
  
          Container(
  
  height:height*0.007,
  
  width: width*0.42,
  
  decoration: BoxDecoration(
  
    color: Colors.black,
  
  borderRadius: BorderRadius.circular(width*0.01)
  
  ),
  
  
  
                ),
                SizedBox(height: height*0.038,)
  
    ],
  
  ),
),
    );
  }
}