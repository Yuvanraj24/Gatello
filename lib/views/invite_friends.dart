import 'package:flutter/material.dart';

class InviteFriends extends StatefulWidget {
  const InviteFriends({Key? key}) : super(key: key);

  @override
  State<InviteFriends> createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 15,
          ),
          child: Text(
            "Back",
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          Image(
            image: AssetImage("assets/appbar_action/Rectangle 7.png"),
            width: 50,
            height: 50,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Column(
          children: [
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                      child: Image.asset(
                          "assets/invite_friends/invite_friends_logo.png"),
                    ),
                    Text(
                      "Invite Your Friends",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            primary: Color.fromRGBO(0, 0, 0, 0.44)),
                        child: Text("Skip",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)))
                  ]),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 15, left: 15),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(),
                      borderRadius: BorderRadius.circular(40)),
                  prefixIcon: Icon(Icons.search),
                  labelStyle: TextStyle(fontSize: 12),
                  hintText: "Search",
                ),
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 5,
            //     itemBuilder: (context, index) {
            //       return Container(
            //         child: Column(
            //           children: [
            //             Row(
            //               children: [
            //                 CircleAvatar(
            //                   backgroundImage: NetworkImage(
            //                       "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
            //                 ),
            //                 Column(
            //                   children: [

            //                   ],
            //                 )
            //               ],
            //             ),
            //             Divider(
            //               color: Color.fromRGBO(0, 0, 0, 0.14),
            //               height: 0,
            //               thickness: 0.5,
            //             )
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              "https://images.pexels.com/photos/733745/pexels-photo-733745.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                        ),
                        title: Text("Name"),
                        subtitle: Text("Customer"),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(248, 206, 97, 1),
                          ),
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Divider(
                        color: Color.fromRGBO(0, 0, 0, 0.14),
                        height: 0,
                        thickness: 0.5,
                      )
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Color.fromRGBO(248, 206, 97, 1)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  fixedSize: Size(180, 40),
                  primary: Color.fromRGBO(248, 206, 97, 1),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(color: Colors.black),
                )),
            Divider(
              color: Colors.black,
              height: 35,
              endIndent: 70,
              indent: 80,
              thickness: 3.5,
            ),
          ],
        ),
      ),
    );
  }
}
