import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String description =
      "Your professional bio is an important piece of personal branding real estate that can help you catch the interest of a recruiter, earn a speaking gig, land a guest blogging opportunity, gain admission to a program, or prompt other career wins.";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Demo App"),
      ),
      body: new Container(
        child: new DescriptionTextWidget(text: description),
      ),
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({required this.text});

  @override
  _DescriptionTextWidgetState createState() => new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 18) {
      firstHalf = widget.text.substring(0, 18);
      secondHalf = widget.text.substring(18, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ?  Text(firstHalf)
          :  Column(
        children: <Widget>[
           Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
           InkWell(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                 Text(
                  flag ? "More" : "Back",
                  style:  TextStyle(color: Colors.blue),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
        ],
      ),
    );
  }
}