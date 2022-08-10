import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../Authentication/Authentication.dart';
import '../../../../Firebase.dart';
import '../../../../Helpers/DateTimeHelper.dart';
import '../../../../Others/components/LottieComposition.dart';
import '../../../../Others/lottie_strings.dart';
import '../../../../Style/Colors.dart';
import '../../../../Style/Text.dart';
import '../../../../components/AssetPageView.dart';
import '../../../../components/ScaffoldDialog.dart';
import '../../../../components/SimpleDialogBox.dart';
import '../../../../components/SnackBar.dart';
import '../../../../components/flatButton.dart';
import '../../../../main.dart';
import 'ChatDetailsUpdate.dart';



class ChatDetails extends StatefulWidget {
  ///* peeruid for personal chat and gid for group chat
  final String puid;
  final String uid;
  final SizingInformation sizingInformation;

  ///*0->user,1->group
  final int state;
  const ChatDetails({Key? key, required this.uid, required this.sizingInformation, required this.puid, required this.state}) : super(key: key);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  Future<FilePickerResult?> gallery() async => await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg'],
  );
  var top = 0.0;
  // List<String> ids = [];
  // int count = 0;
  FirebaseFirestore instance = FirebaseFirestore.instance;

  //! only admin can remove and change claim of participants
  //!this doesnt have exit group logic and election logic for now
  Future changeClaim({
    //*0->promote as admin,1->demote as admin,2->remove user from group,3->exit group
    required int type,
    required String uid,
  }) async {
    DocumentReference<Map<String, dynamic>> groupDetailDocRef = instance.collection("group-detail").doc(widget.puid);
    switch (type) {
      case 0:
        {
          await instance.runTransaction((transaction) async {
            DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(groupDetailDocRef);
            try {
              if (snapshot.data()!["members"]["${widget.uid}"]["claim"] == "admin") {
                await transaction.update(groupDetailDocRef, {
                  "members.$uid.claim": "admin",
                });
              } else {
                throw FirebaseException(plugin: 'cloud_firestore', code: 'predefined-condition-failed');
              }
            } on FirebaseException catch (e) {
              if (e.code == 'predefined-condition-failed') {
                final snackBar = snackbar(content: "You are not the admin of this group");
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } catch (e) {
              log(e.toString());
            }
          });
          // await instance.collection("group-detail").doc(widget.puid).update({
          //   "members.$uid.claim": "admin",
          // });
        }
        break;

      case 1:
        {
          await instance.runTransaction((transaction) async {
            DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(groupDetailDocRef);
            try {
              if (snapshot.data()!["members"]["${widget.uid}"]["claim"] == "admin") {
                await transaction.update(groupDetailDocRef, {
                  "members.$uid.claim": "member",
                });
              } else {
                throw FirebaseException(plugin: 'cloud_firestore', code: 'predefined-condition-failed');
              }
            } on FirebaseException catch (e) {
              if (e.code == 'predefined-condition-failed') {
                final snackBar = snackbar(content: "You are not the admin of this group");
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } catch (e) {
              log(e.toString());
            }
          });
          // await instance.collection("group-detail").doc(widget.puid).update({
          //   "members.$uid.claim": "member",
          // });
        }
        break;
      case 2:
        {
          await instance.runTransaction((transaction) async {
            DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(groupDetailDocRef);
            try {
              if (snapshot.data()!["members"]["${widget.uid}"]["claim"] == "admin") {
                await transaction.update(groupDetailDocRef, {
                  "members.$uid.isRemoved": true,
                  "members.$uid.claim": "removed",
                  "members.$uid.unreadCount": 0,
                  "members.$uid.lastRead": null,
                });
              } else {
                throw FirebaseException(plugin: 'cloud_firestore', code: 'predefined-condition-failed');
              }
            } on FirebaseException catch (e) {
              if (e.code == 'predefined-condition-failed') {
                final snackBar = snackbar(content: "You are not the admin of this group");
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } catch (e) {
              log(e.toString());
            }
          });
        }
        break;
      case 3:
        {
          await instance.runTransaction((transaction) async {
            DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(groupDetailDocRef);
            try {
              if (snapshot.data()!["members"]["${widget.uid}"]["claim"] == "member") {
                await transaction.update(groupDetailDocRef, {
                  "members.$uid.isRemoved": true,
                  "members.$uid.claim": "removed",
                  "members.$uid.unreadCount": 0,
                  "members.$uid.lastRead": null,
                });
              } else {
                throw FirebaseException(plugin: 'cloud_firestore', code: 'predefined-condition-failed');
              }
            } on FirebaseException catch (e) {
              if (e.code == 'predefined-condition-failed') {
                final snackBar = snackbar(content: "You are not the member of this group");
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            } catch (e) {
              log(e.toString());
            }
          });
        }
        break;
      default:
        {
          print("error");
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: (widget.state == 0) ? instance.collection("user-detail").doc(widget.puid).snapshots() : instance.collection("group-detail").doc(widget.puid).snapshots(),
        builder: (context, chatDetailSnapshot) {
          if (chatDetailSnapshot.hasData && chatDetailSnapshot.connectionState == ConnectionState.active) {
            //   if (widget.state == 1 && ids.length != chatDetailSnapshot.data!.data()!["members"].length) {
            //     chatDetailSnapshot.data!.data()!["members"].forEach((String key, value) {
            //       ids.add(key);
            //     });
            //     log(ids.toString());
            //     // if (mounted) {
            //     //   setState(() {
            //     count = ids.length;
            //     //   });
            //     // }
            //   }
            return ResponsiveBuilder(builder: (context, sizingInformation) {
              return Scaffold(
                  appBar: AppBar(
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: (themedata.value.index == 0) ? Color(lightGrey) : Color(materialBlack),
                    elevation: 0,
                    actions: (widget.state == 0)
                        ? [
                      TextButton(
                          onPressed: () async {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ProfileDetails(
                            //           userId: widget.puid,
                            //         )));
                          },
                          child: Text(
                            "View Profile",
                            style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14)),
                          ))
                    ]
                        : null,
                    leading: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: Icon(Icons.close),
                    ),
                    title: Text((widget.state == 0) ? "Personal Info" : "Group Info",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                  ),
                  body: ((widget.state == 0) ? true : chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] != "removed")
                      ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                  width: 150,
                                  height: 150,
                                  child: ClipOval(
                                    child: (chatDetailSnapshot.data!.data()!["pic"] != null)
                                    // ? Image.network(
                                    //     chatDetailSnapshot.data!.data()!["pic"],
                                    //     fit: BoxFit.cover,
                                    //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    //       if (loadingProgress == null) return child;
                                    //       return Center(
                                    //         child: CircularProgressIndicator(
                                    //           value: loadingProgress.expectedTotalBytes != null
                                    //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    //               : null,
                                    //         ),
                                    //       );
                                    //     },
                                    //     errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                                    //   )
                                        ? CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      fadeInDuration: const Duration(milliseconds: 400),
                                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                        child: Container(
                                          width: 20.0,
                                          height: 20.0,
                                          child: CircularProgressIndicator(value: downloadProgress.progress),
                                        ),
                                      ),
                                      imageUrl: chatDetailSnapshot.data!.data()!["pic"],
                                      errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                                    )
                                        : Image.asset((widget.state == 0) ? "assets/noProfile.jpg" : "assets/noGroupProfile.jpg", fit: BoxFit.cover),
                                  )),
                              (widget.state == 1)
                                  ? Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () async {
                                    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

                                    return await gallery().then((value) async {
                                      if (value != null && value.files.first.size < 52428800) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AssetPageView(
                                                  fileList: value.files,
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    TaskSnapshot taskSnapshot = await Write().groupProfile(
                                                        guid: widget.puid,
                                                        file: value.files.first.bytes!,
                                                        fileName: timestamp,
                                                        contentType: "image/" + value.files.first.extension!);
                                                    String url = await taskSnapshot.ref.getDownloadURL();

                                                    await instance
                                                        .collection("group-detail")
                                                        .doc(widget.puid)
                                                        .set({"pic": url, "updatedAt": DateTime.now().millisecondsSinceEpoch.toString()}, SetOptions(merge: true));
                                                  },
                                                )));
                                      } else {
                                        final snackBar = snackbar(content: "File size is greater than 50MB");
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    });
                                  },
                                  child: ClipOval(
                                      child: Material(
                                        color: Color(accent),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          child: Icon(
                                            Linecons.camera,
                                            size: 15,
                                          ),
                                        ),
                                      )),
                                ),
                              )
                                  : Container(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 5, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text((widget.state == 0) ? chatDetailSnapshot.data!.data()!["name"] : chatDetailSnapshot.data!.data()!["title"],
                                    textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 16))),
                                (widget.state == 1 && chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] == "admin")
                                    ? IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    onPressed: () async {
                                      if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                        return await scaffoldAlertDialogBox(
                                            context: context,
                                            page: ChatDetailsUpdate(
                                                state: 0, text: chatDetailSnapshot.data!.data()!["title"], guid: chatDetailSnapshot.data!.data()!["gid"]));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ChatDetailsUpdate(
                                                    state: 0, text: chatDetailSnapshot.data!.data()!["title"], guid: chatDetailSnapshot.data!.data()!["gid"])));
                                      }
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                    ))
                                    : Container()
                              ],
                            ),
                          ),
                          (widget.state == 1)
                              ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text("Group ${chatDetailSnapshot.data!.data()!["members"].length} Participants",
                                textAlign: TextAlign.center, style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          )
                              : Container(),
                          Divider(),
                          (widget.state == 1)
                              ? Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Add Group Description", style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                                    (chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] == "admin")
                                        ? IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        onPressed: () async {
                                          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                            return await scaffoldAlertDialogBox(
                                                context: context,
                                                page: ChatDetailsUpdate(
                                                    state: 1,
                                                    text: chatDetailSnapshot.data!.data()!["description"],
                                                    guid: chatDetailSnapshot.data!.data()!["gid"]));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ChatDetailsUpdate(
                                                        state: 1,
                                                        text: chatDetailSnapshot.data!.data()!["description"],
                                                        guid: chatDetailSnapshot.data!.data()!["gid"])));
                                          }
                                        },
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          size: 20,
                                        ))
                                        : Container()
                                  ],
                                ),
                                (chatDetailSnapshot.data!.data()!["description"] != null)
                                    ? Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(chatDetailSnapshot.data!.data()!["description"],
                                      style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, color: Color(grey)))),
                                )
                                    : Container(),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                      "Group created by ${chatDetailSnapshot.data!.data()!["members"][chatDetailSnapshot.data!.data()!["createdBy"]]["name"]}, On ${formatDate(getDateTimeSinceEpoch(datetime: chatDetailSnapshot.data!.data()!["createdAt"]))} at ${formatTime(getDateTimeSinceEpoch(datetime: chatDetailSnapshot.data!.data()!["createdAt"]))}",
                                      style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12, color: Color(grey)))),
                                ),
                              ],
                            ),
                          )
                              : Container(),
                          (widget.state == 1) ? Divider() : Container(),
                          (widget.state == 0)
                              ?
                          // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          //     stream: instance.collection("personal-group-list").doc(widget.uid).snapshots(),
                          //     builder: (context, personalGroupListSnapshot) {
                          //       if (personalGroupListSnapshot.hasData &&
                          //           personalGroupListSnapshot.connectionState == ConnectionState.active &&
                          //           personalGroupListSnapshot.data!.data()!["groupList"] != null &&
                          //           personalGroupListSnapshot.data!.data()!["groupList"].isNotEmpty) {
                          //         return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          //             stream: instance.collection("personal-group-list").doc(widget.puid).snapshots(),
                          //             builder: (context, peerUserGroupListSnapshot) {
                          //               if (peerUserGroupListSnapshot.hasData &&
                          //                   peerUserGroupListSnapshot.connectionState == ConnectionState.active &&
                          //                   peerUserGroupListSnapshot.data!.data()!["groupList"] != null &&
                          //                   peerUserGroupListSnapshot.data!.data()!["groupList"].isNotEmpty) {
                          //                 ids = List<String>.from(personalGroupListSnapshot.data!.data()!["groupList"])
                          //                     .toSet()
                          //                     .where((x) => List<String>.from(peerUserGroupListSnapshot.data!.data()!["groupList"]).toSet().contains(x))
                          //                     .toList();
                          //                 // if (mounted) {
                          //                 //   setState(() {
                          //                 count = ids.length;
                          //                 // });
                          //                 // }
                          //                 if (ids.isNotEmpty) {
                          //                   return

                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: instance
                                  .collection("group-detail")
                                  .where("members.${widget.uid}.isRemoved", isEqualTo: false)
                                  .where("members.${widget.puid}.isRemoved", isEqualTo: false)
                                  .snapshots(),
                              // stream: instance.collection("group-detail").where("gid", whereIn: ids).snapshots(),
                              builder: (context, groupDetailSnapshot) {
                                if (groupDetailSnapshot.hasData && groupDetailSnapshot.connectionState == ConnectionState.active) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${groupDetailSnapshot.data!.docs.length} Groups in Common",
                                            style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: groupDetailSnapshot.data!.docs.length,
                                            itemBuilder: (context, index) => buildItem(
                                                index: index,
                                                description: groupDetailSnapshot.data!.docs[index]["members"].length.toString(),
                                                pic: (groupDetailSnapshot.data!.docs[index]["pic"] != null) ? groupDetailSnapshot.data!.docs[index]["pic"] : null,
                                                chatDetailSnapshot: chatDetailSnapshot,
                                                name: groupDetailSnapshot.data!.docs[index]["title"],
                                                id: groupDetailSnapshot.data!.docs[index]["gid"]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container(
                                      child: Center(
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [lottieAnimation(invalidLottie), Text("No Groups in common")],
                                            ),
                                          )));
                                }
                              })
                          //             } else {
                          //               return Container(
                          //                   child: Center(
                          //                       child: SingleChildScrollView(
                          //                 child: Column(
                          //                   children: [lottieAnimation(invalidLottie), Text("No Groups in common")],
                          //                 ),
                          //               )));
                          //             }
                          //           } else {
                          //             return Container(
                          //                 child: Center(
                          //                     child: SingleChildScrollView(
                          //               child: Column(
                          //                 children: [lottieAnimation(invalidLottie), Text("No Groups in common")],
                          //               ),
                          //             )));
                          //           }
                          //         });
                          //   } else {
                          //     return Container(
                          //         child: Center(
                          //             child: SingleChildScrollView(
                          //       child: Column(
                          //         children: [lottieAnimation(invalidLottie), Text("No Groups in common")],
                          //       ),
                          //     )));
                          //   }
                          // })
                              :
                          // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          //     // stream: instance.collection("user-detail").where("uid", whereIn: ids).snapshots(),
                          //     // stream: instance.collection("user-detail").where("groupList", arrayContains: widget.puid).snapshots(),
                          //     //TODO theres pic and name in group detail use that
                          //     builder: (context, userDetailSnapshot) {
                          //       if (userDetailSnapshot.hasData && userDetailSnapshot.connectionState == ConnectionState.active) {
                          //         return
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 5, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${chatDetailSnapshot.data!.data()!["members"].length} Participants",
                                    style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                                (chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] == "admin")
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  // child: GestureDetector(
                                  //   behavior: HitTestBehavior.opaque,
                                  //   onTap: () async {
                                  //     if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
                                  //       return await scaffoldAlertDialogBox(
                                  //           context: context,
                                  //           page: SearchPage(
                                  //             sizingInformation: sizingInformation,
                                  //             gid: widget.puid,
                                  //             state: 5,
                                  //             participants: chatDetailSnapshot.data!.data()!["members"].keys.toList(),
                                  //           ));
                                  //     } else {
                                  //       List<String> participantIds = [];
                                  //       chatDetailSnapshot.data!.data()!["members"].forEach((key, value) {
                                  //         if (value["isRemoved"] == false) {
                                  //           participantIds.add(key);
                                  //         }
                                  //       });
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   SearchPage(sizingInformation: sizingInformation, gid: widget.puid, state: 5, participants: participantIds)));
                                  //     }
                                  //   },
                                  //   child: Row(
                                  //     children: [
                                  //       ClipOval(
                                  //         child: Material(
                                  //           color: Color(accent),
                                  //           child: Container(
                                  //             height: 50,
                                  //             width: 50,
                                  //             child:
                                  //             Center(child: Icon(Icons.person_add_sharp, color: (themedata.value.index == 0) ? Color(white) : Color(black))),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       Flexible(
                                  //         child: Padding(
                                  //           padding: EdgeInsets.only(left: 10),
                                  //           child: Text(
                                  //             "Add Participants",
                                  //             style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                  //             overflow: TextOverflow.ellipsis,
                                  //             maxLines: 1,
                                  //             softWrap: true,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) => SizedBox(
                                        height: 8,
                                      ),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: chatDetailSnapshot.data!.data()!["members"].length,
                                      itemBuilder: (context, index) => buildItem(
                                          index: index,
                                          pic: (chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["pic"] != null)
                                              ? chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["pic"]
                                              : null,
                                          name: chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["name"],
                                          description: chatDetailSnapshot.data!.data()!["members"].values.elementAt(index)["claim"],
                                          chatDetailSnapshot: chatDetailSnapshot,
                                          id: chatDetailSnapshot.data!.data()!["members"].keys.elementAt(index))),
                                ),
                              ],
                            ),
                          ),
                          (widget.state == 1) ? Divider() : Container(),
                          (widget.state == 1)
                              ? ListTile(
                              title: Text("Exit group"),
                              leading: Icon(Icons.exit_to_app),
                              onTap: () async {
                                await changeClaim(type: 3, uid: getUID());
                                Navigator.pop(context);
                                Navigator.pop(context);
                              })
                              : Container()
                          //     } else {
                          //       return Container();
                          //     }
                          //   },
                          // )
                        ],
                      ),
                    ),
                  )
                      : Container(
                      child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                lottieAnimation(notFoundLottie),
                                Text("You have been removed from the group", style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                flatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Go Back"))
                              ],
                            ),
                          ))));
            });
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget buildItem(
      {required String? pic,
        required String name,
        required String id,
        required int index,
        required String description,
        required AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> chatDetailSnapshot}) {
    if (widget.state == 1 && description == "removed") {
      return Container();
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (getUID() != id)
            ? (widget.state == 0)
            ? () {
          //TODO Navigate to Group Chat
        }
            : (chatDetailSnapshot.data!.data()!["members"]["${widget.uid}"]["claim"] == "admin")
            ? () async {
          return await simpleDialogBox(context: context, widgetList: [
            SimpleDialogOption(
                onPressed: () async {
                  await changeClaim(type: (description != "admin") ? 0 : 1, uid: id);
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    (description != 'admin') ? 'Make group admin' : 'Dismiss as admin',
                    style: GoogleFonts.poppins(
                        textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                    softWrap: true,
                  ),
                )),
            SimpleDialogOption(
                onPressed: () async {
                  await changeClaim(type: 2, uid: id);
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    'remove $name',
                    style: GoogleFonts.poppins(
                        textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w600, color: (themedata.value.index == 0) ? Color(black) : Color(white))),
                    softWrap: true,
                  ),
                )),
          ]);

          //TODO Navigate to User Chat
        }
            : null
            : null,
        child: Container(
          child: Row(
            children: [
              Container(
                  width: 50,
                  height: 50,
                  child: ClipOval(
                    child: (pic != null)
                    // ? Image.network(
                    //     pic,
                    //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    //       if (loadingProgress == null) return child;
                    //       return Center(
                    //         child: CircularProgressIndicator(
                    //           value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    //         ),
                    //       );
                    //     },
                    //     errorBuilder: (context, error, stackTrace) =>
                    //         Image.asset((widget.state == 0) ? "assets/noProfile.jpg" : "assets/noGroupProfile.jpg", fit: BoxFit.cover),
                    //   )
                        ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 400),
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(value: downloadProgress.progress),
                        ),
                      ),
                      imageUrl: pic,
                      errorWidget: (context, url, error) => Image.asset("assets/noGroupProfile.jpg", fit: BoxFit.cover),
                    )
                        : Image.asset((widget.state == 0) ? "assets/noProfile.jpg" : "assets/noGroupProfile.jpg", fit: BoxFit.cover),
                  )),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                      Text(
                        (widget.state == 0) ? "$description Participants" : "$description",
                        style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(grey))),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
