import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatello/core/models/pings_chat_model/pings_chats_list_model.dart';
import 'package:gatello/views/tabbar/chats/pesrsonal_chat.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact.dart';
import 'package:gatello/views/tabbar/pings_chat/select_contact/select_contact_model.dart';
import 'package:google_fonts/google_fonts.dart';

class PingsChatView extends StatefulWidget {
  const PingsChatView({Key? key}) : super(key: key);

  @override
  State<PingsChatView> createState() => _PingsChatViewState();
}

class _PingsChatViewState extends State<PingsChatView> {
  List<PingsChatListModel> tileData = [];
  var isSelected = false;
  var mycolor = Colors.white;

  @override
  void initState() {
    super.initState();
    tileData = pingsChatListData();
  }

  bool change = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 52, 130, 0.06),
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
              color: Color.fromRGBO(26, 52, 130, 0.06),
              child: ListView.builder(
                itemCount: tileData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: InkWell(
                      onTap: () {},
                      onLongPress: () {},
                      child: Container(
                        // color: (tileData.contains(index))
                        //                   ? Colors.blue.withOpacity(0.5)
                        //                   : Colors.transparent,

                        child: ListTile(
                          onLongPress: () {
                            toggleSelection();
                          },
                          onTap: () {
                            if (tileData.contains(index)) {
                              setState(() {
                                tileData.removeWhere((val) => val == index);
                              });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PersonalChat()));
                            }
                          },
                          tileColor: Colors.white,
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 6, bottom: 6),
                          //  contentPadding: EdgeInsets.all(10),
                          leading: CircleAvatar(
                            radius: 25.5.h,
                            backgroundImage: NetworkImage(tileData[index].dp),
                          ),
                          selected: isSelected,

                          title: Text(
                            tileData[index].name,
                            style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                    fontSize: 16.sp,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.w700)),
                          ),
                          subtitle: Text(tileData[index].lasttext,
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color.fromRGBO(12, 16, 29, 0.6),
                                      fontWeight: FontWeight.w400))),
                          trailing: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Column(
                              children: [
                                Text("${11}:${20} AM",
                                    style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 10.sp,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                          fontWeight: FontWeight.w400),
                                    )),
                                SizedBox(height: 3.h),
                                Container(
                                    decoration: BoxDecoration(
                                        //borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(255, 202, 40, 1),
                                        ),
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(255, 202, 40, 1)),
                                    width: 22.w,
                                    height: 22.h,
                                    child: Center(
                                      child: Text(
                                          tileData[index].unreadMsg.toString(),
                                          style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 11.sp,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontWeight: FontWeight.w400),
                                          )),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SelectContact()));
          },
          backgroundColor: Color.fromRGBO(248, 206, 97, 1),
          child: SvgPicture.asset("assets/icons_assets/chat_icon_floating.svg")),
    );
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = Colors.white;
        isSelected = false;
      } else {
        mycolor = Colors.red;
        isSelected = true;
      }
    });
  }
}
