
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionText extends StatefulWidget {
  final int index;
  final String text;
  final TextStyle? style;
  final TextStyle? buttonStyle;
  DescriptionText({required this.text, this.index = 50, this.style, this.buttonStyle});

  @override
  _DescriptionTextState createState() => new _DescriptionTextState();
}

class _DescriptionTextState extends State<DescriptionText> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > widget.index) {
      firstHalf = widget.text.substring(0, widget.index);
      secondHalf = widget.text.substring(widget.index, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!mounted) return;
        setState(() {
          flag = !flag;
        });
      },
      child: new Container(
        child: secondHalf.isEmpty
            ? new Text(firstHalf, style: widget.style)
            : new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(child: Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf), style: widget.style)),
            new InkWell(
              child: Text(
                flag ? "Show More" : "Show Less",
                style: widget.buttonStyle,
              ),
              onTap: () {
                setState(() {
                  flag = !flag;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
