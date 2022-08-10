import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Database/StorageManager.dart';
import '../../../../Style/Colors.dart';
import '../../../../Style/Text.dart';
import '../../../../components/Emoji.dart';
import '../../../../components/SnackBar.dart';
import '../../../../components/TextFormField.dart';
import '../../../../main.dart';
import '../../../../validator/validator.dart';


class ChatDetailsUpdate extends StatefulWidget {
  ///* 0->edit name,1->edit description
  final int state;
  final String? text;
  final String guid;
  const ChatDetailsUpdate({Key? key, required this.state, required this.text, required this.guid}) : super(key: key);

  @override
  _ChatDetailsUpdateState createState() => _ChatDetailsUpdateState();
}

class _ChatDetailsUpdateState extends State<ChatDetailsUpdate> {
  bool emojiShowing = false;
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  List recentEmojiList = [];

  @override
  void initState() {
    if (widget.text != null) {
      textEditingController.text = widget.text!;
    }
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future updateGroupDetails(String guid, String text) async {
    if (widget.state == 0) {
      await instance.collection('group-detail').doc(guid).update({'title': text, "updatedAt": DateTime.now().millisecondsSinceEpoch.toString()});
    } else {
      await instance.collection('group-detail').doc(guid).update({'description': text, "updatedAt": DateTime.now().millisecondsSinceEpoch.toString()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
          elevation: 0,
          title: Text((widget.state == 0) ? "Enter new title" : "Enter new description",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                      Text("Cancel", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: (themedata.value.index == 0) ? Color(black) : Color(white),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await updateGroupDetails(widget.guid, textEditingController.text);
                          Navigator.pop(context);
                        } else {
                          final snackBar = snackbar(content: "Please fill out the text field.");
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text("OK", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Form(
                              key: _formKey,
                              child: textFormField(
                                  textStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  textEditingController: textEditingController,
                                  border: false,
                                  autofocus: true,
                                  focusNode: focusNode,
                                  hintText: (widget.state == 0) ? "Enter new title" : "Enter new description",
                                  hintStyle: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(grey))),
                                  validator: (value) => defaultValidator(
                                    value: value,
                                    type: (widget.state == 0) ? "Enter new title" : "Enter new description",
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onPressed: () async {
                                  recentEmojiList = await getRecentEmoji();
                                  if (!mounted) return;
                                  setState(() {
                                    emojiShowing = !emojiShowing;
                                    if (!emojiShowing) {
                                      focusNode.requestFocus();
                                    } else {
                                      focusNode.unfocus();
                                    }
                                  });
                                },
                                icon: Icon(Icons.emoji_emotions_outlined)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: !emojiShowing,
              child: emojiOffstage(),
            )
          ],
        ),
      ),
    );
  }

  Widget emojiOffstage() {
    return Container(
      height: 300,
      child: Material(
        child: DefaultTabController(
          length: emojiArray.length + 1,
          child: Column(
            children: [
              TabBar(
                // isScrollable: true,
                  tabs: List.generate(
                    emojiArray.length + 1,
                        (tabindex) => Tab(text: (tabindex == 0 ? "🕐" : emojiArray[tabindex - 1][0])),
                  )),
              Flexible(
                child: TabBarView(
                  children: List.generate(emojiArray.length + 1, (tabbarindex) {
                    return SingleChildScrollView(
                      child: Wrap(
                          children: List.generate(
                            tabbarindex == 0 ? recentEmojiList.length : emojiArray[tabbarindex - 1].length,
                                (index) {
                              return GestureDetector(
                                  onTap: () async {
                                    if (tabbarindex != 0) {
                                      await setRecentEmoji(emojiArray[tabbarindex - 1][index]);
                                      recentEmojiList = await getRecentEmoji();
                                      if (!mounted) return;
                                      setState(() {});
                                    }
                                    textEditingController
                                      ..text += (tabbarindex == 0) ? recentEmojiList[index].toString() : emojiArray[tabbarindex - 1][index]
                                      ..selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text((tabbarindex == 0) ? recentEmojiList[index] : emojiArray[tabbarindex - 1][index], style: TextStyle(fontSize: 30)),
                                  ));
                            },
                          )),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
