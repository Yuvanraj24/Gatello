import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gatello/views/add_profile_pic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'moji_files/fluttermojiCircleAvatar.dart';
import 'moji_files/fluttermojiCustomizer.dart';
import 'moji_files/fluttermojiThemeData.dart';

class Avator extends StatefulWidget {
  var uid;
  var mobileNo;
  var password;
  var username;
  var name;
  var birthDay;
  var email;
  Avator({
    required this.uid,
  required this.mobileNo,
  required this.password,
  required this.username,
  required this.name,
  required this.birthDay,
  required this.email,

  });


  @override
  State<Avator> createState() => _AvatorState();
}

class _AvatorState extends State<Avator> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:   Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/pops_asset/back_button.svg',
                height: 35,
                width: 35,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[


          // SizedBox(
          //   height: 100,
          // ),
          FluttermojiCircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 100,
          ),


          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Spacer(flex: 2),
              Expanded(
                flex: 3,
                child: Container(

                  height: 35,
                  child: ElevatedButton.icon(

                    icon: Icon(Icons.edit),
                    label: Text("Edit"),
                    onPressed: () => Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => NewPage(uid: widget.uid, mobileNo: widget.mobileNo, password: widget.password, username: widget.username, name: widget.name, birthDay: widget.birthDay, email: widget.email,))),
                    style: ElevatedButton.styleFrom(primary:Color.fromRGBO(248, 206, 97, 1), ),
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}


class NewPage extends StatelessWidget {
  var uid;
  var mobileNo;
  var password;
  var username;
  var name;
  var birthDay;
  var email;
  NewPage({
    required this.uid,
    required this.mobileNo,
    required this.password,
    required this.username,
    required this.name,
    required this.birthDay,
    required this.email,
  });

  AddProfilePic obj = AddProfilePic(uid: "zR1MaxWgzQUwZm2e9v6x8LykXA52", mobileNo: "8124043013", username: "yuvan_u1", password: "Pass@2022", birthDay: "24-12-2000", name: "yuvanraj", email: "itsmeyuvanraj@gmail.com");

  @override
  Widget build(BuildContext context) {
    Map<String,int> mojiOptions={"topType":0,'accessoriesType':0,'hairColor':1,'facialHairType':0,'facialHairColor':1,'clotheType':4,'eyeType':6,'eyebrowType':10,
      'mouthType':8,'skinColor':3,'clotheColor':8,'style':0,'graphicType':0};

    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading:   Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/pops_asset/back_button.svg',
                height: 35,
                width: 35,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: FluttermojiCircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              SizedBox(
                width: min(600, _width * 0.85),
                child: Row(
                  children: [
                    Text(
                      "Customize:",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Spacer(),
                    // FluttermojiSaveWidget(),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: FluttermojiCustomizer(
                  scaffoldWidth: min(600, _width * 0.85),
                  autosave: true,
                  theme: FluttermojiThemeData(
                      boxDecoration: BoxDecoration(boxShadow: [BoxShadow()])),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
        getEmoji().then((v){
          debugPrint("value get :${v}");
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddProfilePic(avatarData: v, uid: uid, mobileNo: mobileNo, password: password, username: username, name: name, birthDay: birthDay, email: email,)));
        });
      },
      child: Icon(Icons.save),
      ),
    );
  }
  Future<String?> getEmoji() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? _fluttermoji = pref.getString('fluttermoji');
    return _fluttermoji;
  }

  Future<Uint8List> svgToPng(BuildContext context, String svgString,
      ) async {
    var svgHeight = 264;
    var svgWidth = 280;
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "");

    // to have a nice rendering it is important to have the exact original height and width,
    // the easier way to retrieve it is directly from the svg string
    // but be careful, this is an ugly fix for a flutter_svg problem that works
    // with my images
    String temp = svgString.substring(svgString.indexOf('height="') + 8);
    int originalHeight =
        svgHeight ?? int.parse(temp.substring(0, temp.indexOf('p')));
    temp = svgString.substring(svgString.indexOf('width="') + 7);
    int originalWidth =
        svgWidth ?? int.parse(temp.substring(0, temp.indexOf('p')));

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    double width = originalHeight *
        devicePixelRatio; // where 32 is your SVG's original width
    double height = originalWidth * devicePixelRatio; // same thing

    // Convert to ui.Picture
    final picture = svgDrawableRoot.toPicture(size: Size(width, height));

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the screen DPI
    final image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await image.toByteData(format: ImageByteFormat.png);

    return bytes!.buffer.asUint8List();
  }
}