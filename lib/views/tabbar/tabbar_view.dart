import 'package:flutter/material.dart';
import 'package:gatello/views/tabbar/pings_chat/pings_chat_view.dart';
import 'package:google_fonts/google_fonts.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({Key? key}) : super(key: key);

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          // shadowColor: Colors.black,
          leading: Image(
            image: AssetImage("assets/Gatello_logo/Gatello_temp_logo.png"),
            width: 50,
            height: 25,
          ),
          actionsIconTheme: IconThemeData(color: Color.fromRGBO(0, 0, 0, 1)),
          actions: [
            CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                    "https://c4.wallpaperflare.com/wallpaper/611/838/413/spiderman-hd-4k-superheroes-wallpaper-preview.jpg")),
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            PopupMenuButton(
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          child: Container(
                        width: 100,
                        child: Row(
                          children: [
                            Image.asset(
                                "assets/icons_assets/chat_icon_floating.png"),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "New Group",
                              style: TextStyle(
                                  fontFamily: 'Helvetica', fontSize: 12),
                            ),
                          ],
                        ),
                      )),
                      PopupMenuItem(child: Text("Linked devices")),
                      PopupMenuItem(child: Text("Invite friends")),
                      PopupMenuItem(child: Text("Settings"))
                    ]),
          ],
          bottom: TabBar(
            labelPadding: EdgeInsets.all(0),
            indicatorColor: Color.fromRGBO(255, 255, 255, 1),
            tabs: [
              Tab(
                child: Column(
                  children: [
                    Image(
                        image:
                            AssetImage("assets/tabbar_icons/getit_icon.png")),
                    Text("Get it",style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),)
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Image(
                        image:
                            AssetImage("assets/tabbar_icons/pings_icon.png")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pings"),
                        SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          width: 15,
                          height: 15,
                          child: Center(
                              child: Text("${5}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10))),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Image(
                        image:
                            AssetImage("assets/tabbar_icons/pings_icon.png")),
                    Text("Pops")
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Image(
                        image:
                            AssetImage("assets/tabbar_icons/status_icon.png")),
                    Text("Status")
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    Image(
                        image: AssetImage("assets/tabbar_icons/call_icon.png")),
                        Text("Calls")
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Text("Get it...!"),
            ),
            PingsChatView(),
            Center(
              child: Text("Pops...!"),
            ),
            Center(
              child: Text("Status...!"),
            ),
            Center(
              child: Text("Calls...!"),
            ),
          ],
        ),
      ),
    );
  }
}
