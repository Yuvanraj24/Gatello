import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nanoid/nanoid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Authentication/Authentication.dart';
import '../../../../../Firebase/Writes.dart';
import '../../../../../Others/Structure.dart';
import '../../../../../Others/components/ExceptionScaffold.dart';
import '../../../../../Others/lottie_strings.dart';
import '../../../../../Style/Colors.dart';
import '../../../../../Style/Text.dart';
import '../../../../../components/AssetPageView.dart';
import '../../../../../components/SnackBar.dart';
import '../../../../../components/TextField.dart';
import '../../../../../components/TextFormField.dart';
import '../../../../../validator/validator.dart';
import '../../personal_chat_screen/ChatPage.dart';
class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> members;
  final List memberlist;
  final String uid;
  const CreateGroup({Key? key,
    required this.memberlist,
    required this.members,
    required this.uid}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}
class _CreateGroupState extends State<CreateGroup> {
  bool _isRequesting = false;
  bool _isFinish = false;
  List fBPhone=[];
  Map <String,String> conMap = Map();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> body = [];
  var showMember;

  Future userChatList({required String searchQuery, int limit = 50}) async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      _isRequesting = true;
      if (body.isEmpty) {

        querySnapshot = await instance
            .collection("user-detail")
            .where("name",
            isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
            .where("name",
            isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery +
                '\uf8ff')
            .orderBy("name")
            .limit(limit)
            .get();
      } else {
        querySnapshot = await instance
            .collection("user-detail")
            .where("name",
            isGreaterThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery)
            .where("name",
            isLessThanOrEqualTo: (searchQuery.isEmpty) ? null : searchQuery +
                '\uf8ff')
            .orderBy("name")
            .startAfterDocument(body[body.length - 1])
            .limit(limit)
            .get();
      }
      if (querySnapshot != null) {

        if (!mounted) return;
        setState(() {
          // print("QS Len: ${querySnapshot.docs.length}");
          body.addAll(querySnapshot.docs);
          print("Body Added ${querySnapshot.docs}");

          String phone,name,id;
          Stream<QuerySnapshot> chatRef = instance.collection("user-detail").snapshots();
          chatRef.forEach((field) {
            field.docs.asMap().forEach((index, data) {
              // print("Con:${field.docs[index]["phone"]}");
              phone=field.docs[index]["phone"];
              name=field.docs[index]["name"];
              id=field.docs[index]["uid"];

              phone=phone.replaceAll(" ", "");
              print("Con:${phone}(${phone.length})");
              print("ConName:${name}(${name.length})");

              if(phone.length>10 && phone.length<=13)
              {
                print("ifdrop");
                phone=phone.substring(3,13);
                print(phone);
                fBPhone.add(phone);
                // conMap[phone]=name;
                // conId.add(id);
                conMap[phone]=id;


              }
              else
              {
                fBPhone.add(phone);
                conMap[phone]=id;

              }

              // print(fBPhone);




            });
            print("ConMap:${conMap}");
            setState(() {

            });
          });

        });
        if (querySnapshot.docs.length < limit) {
          print('Lotus777${querySnapshot.docs}');
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }
  TextEditingController searchTextEditingController = TextEditingController();

  List<Map<String, dynamic>> groupMemberList = [];
  groupAdd() {
    print("group add function is called...");
    for (int x = 0; x < body.length; x++) {
      for (int j = 0; j<widget.memberlist.length; j++){
        if (body[x]["uid"] == widget.memberlist[j]) {
          print("Came to the Adding Group Action...");
          groupMemberList.add(body[x].data());
          print("The New print of groupList : ${groupMemberList}");
          print("Data of the Body => ${body[x].data()}");
          print("SELTEST contact for create group : ${widget.memberlist[j].toString()} == ${body[x]["uid"]}");
        }
        else{
          print("The Uid is not match with ---- Group member list..!");
        }
      }
    }
    print("The List count for Group member map ${groupMemberList.length}");
  }


  //---------------------------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Uint8List? groupPicture;
  Future<FilePickerResult?> gallery() async => await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg'],
  );
  // Future<XFile?> camera() async => await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front, imageQuality: 50);
  FirebaseFirestore instance = FirebaseFirestore.instance;
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  Future<DocumentSnapshot<Map<String, dynamic>>>? adminDetailFuture;
  //String? uid;
  String? contentType;
  Future<DocumentSnapshot<Map<String, dynamic>>> adminDetails() async {
    // final data1=await _getUID();
    // final data2=await instance.collection("user-detail").doc(uid!).get();
    // return [data1,data2];
    groupAdd();
    return await instance.collection("user-detail").doc(widget.uid).get();
  }
  // Future<void> _getUID() async {
  //   print('uidapi');
  //   SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  //   uid = sharedPrefs.getString("userid");
  //   print("ShardPref ${uid}");
  //
  // }
  @override
  void initState() {
    //  _getUID();
    userChatList(searchQuery: searchTextEditingController.text);
    groupAdd();
    print("member b4 set : ${widget.members}");
    print(widget.members.length);
    var a = widget.members.toSet();
    print("a length : ${a.length}");
    print("Set a is : ${a}");

    adminDetailFuture= adminDetails() ;
    super.initState();
  }

  @override
  void dispose() {
    titleTextEditingController.dispose();
    descriptionTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future:adminDetailFuture ,
            builder: (context, snapshot) {

              if ( snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null && adminDetailFuture != null ) {
                return Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: (isLoading)
                        ? null
                        : () async {
                      try {
                        if (!mounted) return;
                        setState(() {
                          isLoading = true;
                        });
                        if (_formKey.currentState!.validate() && widget.members.isNotEmpty) {
                          String gid = nanoid(30);

                          WriteBatch writeBatch = instance.batch();
                          String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
                          String? url;
                          if (groupPicture != null && contentType != null) {
                            TaskSnapshot taskSnapshot = await Write(uid: widget.uid).groupProfile(guid: gid, file: groupPicture!, fileName: timestamp, contentType: contentType!);
                            url = await taskSnapshot.ref.getDownloadURL();
                          }
                          writeBatch.set(instance.collection("group-detail").doc(gid), {
                            "gid": gid,
                            "title": titleTextEditingController.text,
                            "pic": (url != null) ? url : null,
                            "description": (descriptionTextEditingController.text.isNotEmpty) ? descriptionTextEditingController.text : null,
                            "createdAt": timestamp,
                            "createdBy": widget.uid,
                            "typinglist": [],
                            "updateAt": null,
                            "timestamp": timestamp,
                            "lastMessage": null,
                            "messageBy": null,
                            "members": createGroupMembersMap(
                                adminPic: (snapshot.data!.data()!["pic"] != null) ? snapshot.data!.data()!["pic"] : null,
                                adminName: snapshot.data!.data()!["name"],
                                adminUid:widget.uid,
                                members: widget.members)
                          });
                          // for (String uid in userList) {
                          //   writeBatch.set(
                          //       instance.collection("personal-group-list").doc(uid),
                          //       {
                          //         "groupList": FieldValue.arrayUnion([gid])
                          //       },
                          //       SetOptions(merge: true));
                          // }
                          writeBatch.commit();
                          if (!mounted) return;
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                              state: 1,
                              uid: widget.uid,
                              puid: gid)));
                        } else {
                          if (!mounted) return;
                          setState(() {
                            isLoading = false;
                          });
                          final snackBar = snackbar(content: "Please fill out the title. Description is optional.");
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    child: Icon(Icons.done),
                  ),
                  appBar: AppBar(
                    centerTitle: false,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    leading: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      "Create Group",
                      style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Row(
                              children: [
                                userImagePicker(),
                                Flexible(
                                  child: Form(
                                      key: _formKey,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: title(),
                                      )),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: description(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: adminDetail(pic: (snapshot.data!.data()!["pic"] != null) ? snapshot.data!.data()!["pic"] : null, name: snapshot.data!.data()!["name"]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: memberDetail(),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return exceptionScaffold(context: context, lottieString: loadingLottie, subtitle: "Loading");
              }
            })

    );
  }

  Widget userImagePicker() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          backgroundImage: (groupPicture != null) ? Image.memory(groupPicture!).image : AssetImage("assets/noGroupProfile.jpg"),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () async {
              return await gallery().then((value) async {
                if (value != null && value.files.first.size < 52428800) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssetPageView(
                            fileList: value.files,
                            onPressed: () {
                              Navigator.pop(context);
                              if (!mounted) return;
                              setState(() {
                                groupPicture = value.files.first.bytes;
                                contentType = "image/" + value.files.first.extension!;
                              });
                            },
                          )));
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
        ),
      ],
    );
  }

  Widget title() {
    return textFormField(
        textStyle: GoogleFonts.poppins(textStyle: textStyle()),
        textEditingController: titleTextEditingController,
        hintText: "Enter Group Title",
        border: false,
        hintStyle: GoogleFonts.poppins(textStyle: textStyle(color: Color(grey))),
        validator: (value) => defaultValidator(value: value, type: "Group title"));
  }

  Widget description() {
    return textField(
        textStyle: GoogleFonts.poppins(textStyle: textStyle()),
        textEditingController: descriptionTextEditingController,
        hintText: "Enter Group Description",
        hintStyle: GoogleFonts.poppins(textStyle: textStyle(color: Color(grey))),
        border: false,
        minLines: 3,
        maxLines: 5);
  }

  Widget adminDetail({required String? pic, required String name}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Admin",
          style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: buildItem(pic: pic, name: name),
        )
      ],
    );
  }

  Widget memberDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Members", style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView.separated(
              itemCount: widget.memberlist.length,
              separatorBuilder: (context, index) => Container(
                height: 8,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                groupAdd();
                return buildItem(pic: (groupMemberList[index]["pic"] != null) ? groupMemberList[index]["pic"] : null, name: groupMemberList[index]["name"]);
              }),
        )
      ],
    );
  }

  Widget buildItem({String? pic, required String name}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          children: [
            Container(
                width: 50,
                height: 50,
                child: (pic != null)
                    ? ClipOval(
                  // child: Image.network(
                  //   pic,
                  //   fit: BoxFit.cover,
                  //   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  //     if (loadingProgress == null) return child;
                  //     return Center(
                  //       child: CircularProgressIndicator(
                  //         value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                  //       ),
                  //     );
                  //   },
                  //   errorBuilder: (context, error, stackTrace) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                  // ),
                    child: CachedNetworkImage(
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
                      errorWidget: (context, url, error) => Image.asset("assets/noProfile.jpg", fit: BoxFit.cover),
                    ))
                    : CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  backgroundImage: Image.asset("assets/noProfile.jpg", fit: BoxFit.cover).image,
                )),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  name,
                  style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}