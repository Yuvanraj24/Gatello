import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Assets/GatelloIcon.dart';
import '../Others/components/LottieComposition.dart';
import '../Others/lottie_strings.dart';
import '../Style/Text.dart';
import '../components/SnackBar.dart';
import '../components/flatButton.dart';

class ContactList extends StatefulWidget {
  ///* 0-> invite ; 1-> share
  final int state;

  const ContactList({Key? key, required this.state}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  List<String> selectedContactsId = [];
  List<Contact> selectedContacts = [];
  late Future<List<Contact>> _contacts;
  List<Contact> contacts = [];

  @override
  void initState() {
    _contacts = getContacts();
    super.initState();
  }

  Future<List<Contact>> getContacts() async {
    PermissionStatus contactpermission = await Permission.contacts.request();
    List<Contact> contactList = [];
    if (contactpermission.isGranted || contactpermission.isLimited) {
      contacts = await FastContacts.allContacts;

      // for (Contact contact in contacts) {
      //   var userDoc = await instance
      //       .collection("user-detail")
      //       .where("phone", isGreaterThanOrEqualTo: contact.phones.first)
      //       .where("phone", isGreaterThanOrEqualTo: contact.phones.first + '\uf8ff')
      //       .get();
      //   if (userDoc.docs.isEmpty) {
      //     contactList.add(contact);
      //   }
      // }
    } else {
      final snackBar = snackbar(content: "Please enable contact permission");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return contacts;
    // return contactList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ResponsiveBuilder(
            builder: (context, sizingInformation) => Scaffold(
              resizeToAvoidBottomInset: false,
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
                  (selectedContactsId.isEmpty) ? 'Contact List' : '${selectedContacts.length}/${contacts.length} Selected',
                  style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
              ),
              floatingActionButton: (widget.state == 0)
                  ? null
                  : (contacts.isNotEmpty)
                  ? FloatingActionButton(
                child: Icon(
                  Icons.send,
                ),
                onPressed: () => Navigator.pop(context, selectedContacts),
              )
                  : null,
              body: FutureBuilder<List<Contact>>(
                  future: _contacts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (snapshot.data == null) {
                                return Container();
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: ListTile(
                                    title: Text(snapshot.data![index].displayName),
                                    subtitle: Text(snapshot.data![index].phones[0]),
                                    trailing: (widget.state == 0)
                                        ? Icon(DeejosIcon.chat_2_outline)
                                        : (selectedContactsId.contains(snapshot.data![index].id))
                                        ? Icon(Icons.done)
                                        : null,
                                    onTap: (widget.state == 0)
                                        ? () async {
                                      String uri =
                                          'sms:${snapshot.data![index].phones[0]}?body=${Uri.encodeComponent('''Hi ${snapshot.data![index].displayName}! I am using Gatello. You can download it from https://play.google.com/store/apps/details?id=com.gatello.user''')}';
                                      if (await canLaunch(uri)) {
                                        await launch(uri);
                                      } else {
                                        throw 'Could not launch $uri';
                                      }
                                    }
                                        : () async {
                                      if (!selectedContactsId.contains(snapshot.data![index].id)) {
                                        if (!mounted) return;
                                        setState(() {
                                          selectedContactsId.add(snapshot.data![index].id);
                                          selectedContacts.add(snapshot.data![index]);
                                        });
                                      } else {
                                        if (!mounted) return;
                                        setState(() {
                                          selectedContactsId.remove(snapshot.data![index].id);
                                          selectedContacts.remove(snapshot.data![index]);
                                        });
                                      }
                                    },
                                  ),
                                );
                              }
                            });
                      } else {
                        return Container(
                            child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      lottieAnimation(invalidLottie),
                                      Text("No Contacts Found"),
                                      flatButton(
                                          onPressed: () async {
                                            _contacts = getContacts();
                                          },
                                          child: Text("Retry"))
                                    ],
                                  ),
                                )));
                      }
                    } else if (snapshot.connectionState == ConnectionState.none) {
                      return Container(
                          child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    lottieAnimation(invalidLottie),
                                    Text("No Contacts Found"),
                                    flatButton(
                                        onPressed: () async {
                                          _contacts = getContacts();
                                        },
                                        child: Text("Retry"))
                                  ],
                                ),
                              )));
                    } else {
                      return Container(
                          child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [lottieAnimation(loadingLottie, repeat: true), Text("Loading")],
                                ),
                              )));
                    }
                  }),
            )));
  }


}
