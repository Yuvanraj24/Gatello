import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:tuple/tuple.dart';

import '../../Others/exception_string.dart';
import '../../core/Models/Default.dart';
import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import '/core/models/own_status_model.dart' as OwnStatusDetailsModel;

class MoreStories extends StatefulWidget {
  String uid;
  MoreStories({
    required this.uid,
  });
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {

  final storyController = StoryController();

  ValueNotifier<Tuple4> statusShowValueNotifier = ValueNotifier<Tuple4>(Tuple4(0, exceptionFromJson(loading), "Loading", null));
  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  showOwnStatus() async{

    print("this is an showStatus success api...!");
    return await ApiHandler().apiHandler(
        valueNotifier: statusShowValueNotifier,
        jsonModel: OwnStatusDetailsModel.statusDataFromJson,
        url : "http://192.168.29.93:4000/status/status",
        requestMethod: 1,
        body: {"user_id": widget.uid,}

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(

        storyItems: [
          StoryItem.text(
            title: "Nice!\n\nTap to continue.",
            backgroundColor: Colors.red,
            textStyle: TextStyle(
              fontFamily: 'Dancing',
              fontSize: 40,
            ),
          ),
          StoryItem.pageImage(
            duration:Duration(milliseconds:10),
            url: statusShowValueNotifier.value.item2.result[0].status_post,
            caption: "Still sampling",
            controller: storyController,
          ),

          StoryItem.pageImage(
            duration:Duration(milliseconds:30),
            url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTxYUbW9vYBWtS-U1UdHRiZJp_g3aIdqODlcA&usqp=CAU",
            caption: "Still sampling",
            controller: storyController,
          ),
          StoryItem.pageImage(
              url: "https://i.gifer.com/LeKR.gif",
              caption: "Working with gifs",
              controller: storyController),
          StoryItem.pageImage(
            url: "https://i.pinimg.com/originals/ca/92/98/ca9298defb01dbe4c9bbee2400b1f4e0.gif",
            caption: "Hello, from the other side",
            controller: storyController,
          ),
          StoryItem.pageImage(
            url: "https://i.pinimg.com/originals/81/5d/89/815d895b4721c14cbe7c86c63806d6c8.gif",
            caption: "Hello, from the other side2",
            controller: storyController,
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: true,
        controller: storyController,
      ),
    );
  }
}
