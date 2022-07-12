import 'package:flutter/material.dart';
import 'package:gatello/views/login_screen.dart';
import 'package:hexcolor/hexcolor.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: height*0.0735,

        leading: Center(
            child: TextButton(
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          child: Text(
            'Back',
            style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.038,
                fontWeight: FontWeight.w600),
          ),
        )),
      ),
      body: Column(
        children: [
          SizedBox(height: height * 0.2),
          SizedBox(height: height * 0.195),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'What\'s Your Name?',
                style: TextStyle(
                    fontSize: width * 0.074,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          SizedBox(
            height: height * 0.016,
          ),
          Text(
            'Add your name so that your friends can find you ',
            style: TextStyle(
                fontSize: width * 0.035,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(height: height * 0.05),
          _firstNamecon(height, width),
          SizedBox(height: height * 0.04),
          _lastNamecon(height, width),
          SizedBox(height: height * 0.014),
          Text(
            'By tapping "Sign Up", you acknowledge & agree',
            style: TextStyle(
                fontSize: width * 0.035,
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
          SizedBox(height: height * 0.004),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'to our',
                style: TextStyle(
                  fontSize: width * 0.035,
                ),
              ),
              SizedBox(width: width * 0.008),
              InkWell(
                onTap: () {},
                child: Text(
                  'Terms of service',
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(width: width * 0.008),
              Text(
                'and',
                style: TextStyle(
                  fontSize: width * 0.035,
                ),
              ),
              SizedBox(width: width * 0.008),
              InkWell(
                onTap: () {},
                child: Text(
                  'Privacy Policy.',
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.07),
          ElevatedButton(
            onPressed: () {
              //  Navigator.push(context,
              //   MaterialPageRoute(builder: (context) => ()));
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
                elevation: 5,
                onPrimary: Colors.black,
                padding: EdgeInsets.all(10),
                minimumSize: Size(width * 0.68, height * 0.09),
                primary: HexColor('#F8CE61'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                )),
          ),
          SizedBox(
            height: height * 0.053,
          ),
          Container(
            height: height * 0.007,
            width: width * 0.4,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(width * 0.9)),
          ),
        ],
      ),
    );
  }

  Container _lastNamecon(double height, double width) {
    return Container(
      height: height * 0.07,
      width: width * 0.92,
      child: TextFormField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 7),
          labelText: 'LAST NAME',
          labelStyle: TextStyle(
              fontSize: width * 0.04,
              color: Colors.black,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: width * 0.004),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: width * 0.004),
              borderRadius: BorderRadius.circular(
                5,
              )),
        ),
      ),
    );
  }

  Container _firstNamecon(double height, double width) {
    return Container(
      height: height * 0.07,
      width: width * 0.92,
      child: TextFormField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 7),
          labelText: 'FIRST NAME',
          labelStyle: TextStyle(
              fontSize: width * 0.04,
              color: Colors.black,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: width * 0.004),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: width * 0.004),
              borderRadius: BorderRadius.circular(
                5,
              )),
        ),
        validator: (val) {
          if (val!.isEmpty) {
            return "Field can't be empty";
          }
          else{
            return null;
          }
        },
      ),
    );
  }
}
