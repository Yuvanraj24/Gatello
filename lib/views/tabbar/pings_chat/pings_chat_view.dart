import 'package:flutter/material.dart';
import 'package:gatello/core/models/pings_chat_model/pings_chats_list_model.dart';
import 'package:google_fonts/google_fonts.dart';

class PingsChatView extends StatefulWidget {
  const PingsChatView({Key? key}) : super(key: key);

  @override
  State<PingsChatView> createState() => _PingsChatViewState();
}

class _PingsChatViewState extends State<PingsChatView> {

  List<PingsChatListModel> tileData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tileData = pingsChatListData();
  }
  
  bool change = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: change == true
          ? Container(
              padding: EdgeInsets.only(top: 110),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                        "assets/tabbar_icons/chats_image/chats_empty.png"),
                    Text("No Conversation",
                        style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 22,
                                fontWeight: FontWeight.w700))),
                    Text(
                      "You don't made any conversation yet",
                      style: GoogleFonts.raleway(
                          color: Color.fromRGBO(122, 122, 122, 1),
                          fontSize: 14),
                    ),
                  ],
                ),
              ))
          : Container(
              child: ListView.builder(
                itemCount: tileData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(tileData[index].dp),
                    ),
                    title: Text(tileData[index].name),
                    subtitle: Text(tileData[index].lasttext),
                    trailing: Column(
                      children: [
                        Text("${11}:${20} AM"),
                        SizedBox(height: 4),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color:  Color.fromRGBO(255, 202, 40, 1)
                          ),
                          width: 20,
                          height: 20,
                          child: Center(child: Text(tileData[index].unreadMsg.toString(),
                             style: TextStyle(color: Colors.black, fontSize: 12)),
                        )),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color.fromRGBO(248, 206, 97, 1),
          child: Image.asset("assets/icons_assets/chat_icon_floating.png")),
    );
  }
}
