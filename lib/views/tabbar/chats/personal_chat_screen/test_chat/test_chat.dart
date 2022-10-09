import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  late GlobalKey<PlayerState> playerKey;

  @override
  void initState() {
    playerKey = GlobalKey<PlayerState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playerKey.currentState!.move(); // - My mistake was here that I thought that I'm supposed to return a function pointer here. <FACEPALM> . The currlybraces made it.
      },
      child: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("image/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        new Player(key: playerKey),
      ]),
    );
  }
}
class Player extends StatefulWidget {
  Player({required Key key}) : super(key: key);

  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  double ypos = 0;
  void move() // method I want to call
  {
    setState(() {
      ypos -= 0.1;
      print(ypos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 0),
        alignment: Alignment(0, ypos),
        child: Image.asset(
          "image/test.png",
          fit: BoxFit.contain,
          height: 60,
          width: 60,
        ));
  }
}