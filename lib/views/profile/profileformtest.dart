import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/models/default.dart'as defaultModel;
import 'package:tuple/tuple.dart';

import '../../Firebase/Writes.dart';
import '../../Helpers/DateTimeHelper.dart';
import '../../Others/Routers.dart';
import '../../Others/Structure.dart';
import '../../Others/components/date_picker.dart';
import '../../Others/exception_string.dart';
import '../../Style/Colors.dart';
import '../../Style/Text.dart';
import '../../components/AssetPageView.dart';
import '../../components/SnackBar.dart';
import '../../components/TextField.dart';
import '../../components/TextFormField.dart';
import '../../components/container.dart';
import '../../components/flatButton.dart';
import '../../core/Models/Default.dart';

import '../../core/models/exception/pops_exception.dart';
import '../../handler/Network.dart';
import '../../main.dart';
import '../../validator/validator.dart';
//
// class ProfileForm extends StatefulWidget {
//   final String uid;
//    final String? username;
//    final String? fullname;
//    final String? phone;
//   final String? dob;
//   final String? email;
//   final String? designation;
//   final String? city;
//   final String? member;
//   final String? company;
//   final String? job;
//   final String? college;
//   final String? highSchool;
//   final String? interest;
//   final String? relationshipStatus;
//   final String? about;
//    final String? userPicture;
//   const ProfileForm({
//     Key? key,
//      this.member,
//      this.phone,
//     this.dob,
//     this.email,
//     this.about,
//     this.city,
//     this.college,
//      this.company,
//     this.designation,
//     this.fullname,
//     this.highSchool,
//     this.interest,
//      this.job,
//     this.relationshipStatus,
//      this.userPicture,
//     required this.uid,
//     this.username,
//   }) : super(key: key);
//
//   @override
//   _ProfileFormState createState() => _ProfileFormState();
// }
//
// class _ProfileFormState extends State<ProfileForm> {
//   Future<FilePickerResult?> gallery() async => await FilePicker.platform.pickFiles(
//     withData: true,
//     type: FileType.custom,
//     allowedExtensions: ['jpg', 'jpeg'],
//   );
//   Uint8List? userPicture;
//   // String uid = getUID();
//   DateTime selectedDate = DateTime.now();
//   // String countryCode = '+91';
//   bool loading = false;
//   final _formKey = GlobalKey<FormState>();
//   String? userPictureFileName;
//   String relationShipStatus = 'Single';
//   TextEditingController usernameTextEditingController = TextEditingController();
//   TextEditingController fullnameTextEditingController = TextEditingController();
//    TextEditingController phoneTextEditingController = TextEditingController();
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController designationTextEditingController = TextEditingController();
//   TextEditingController cityTextEditingController = TextEditingController();
//   TextEditingController companyTextEditingController = TextEditingController();
//   TextEditingController jobTextEditingController = TextEditingController();
//   TextEditingController collegeTextEditingController = TextEditingController();
//   TextEditingController schoolTextEditingController = TextEditingController();
//   TextEditingController interestTextEditingController = TextEditingController();
//   // TextEditingController relationshipStatusTextEditingController = TextEditingController();
//   TextEditingController aboutTextEditingController = TextEditingController();
//   TextEditingController memberTextEditingController = TextEditingController();
//
//   ValueNotifier<Tuple4> profileDetailsUpdateValueNotifier1 = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
//   ValueNotifier<Tuple4> profileDetailsUpdateValueNotifier2 = ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));
//
//   Future profileDetailUpdateApiCallFormData1() async {
//     return await ApiHandler().apiHandler(valueNotifier: profileDetailsUpdateValueNotifier1,
//         jsonModel: defaultFromJson, url: "http://192.168.29.93:4000/edit/profile" + "?profile_url=", requestMethod: 1, formData: [
//           Tuple4("profile_file", userPicture!, "Image", "Jpeg")
//         ], formBody: {
//            "user_id": userId,
//            "username": usernameTextEditingController.text,
//           "name": fullnameTextEditingController.text,
//           // "phone": countryCode + " " + phoneTextEditingController.text,
//           "phone": phoneTextEditingController.text,
//           "email": emailTextEditingController.text,
//         //  "phone": widget.phone!,
//           "dob": selectedDate.toString(),
//          // "email": widget.email!,
//           "designation": designationTextEditingController.text,
//           "city": cityTextEditingController.text,
//           "member": memberTextEditingController.text,
//           "company": companyTextEditingController.text,
//           "job": jobTextEditingController.text,
//           "college": collegeTextEditingController.text,
//           "high_school": schoolTextEditingController.text,
//           "interest": interestTextEditingController.text,
//           // "relationship_status": relationshipStatusTextEditingController.text,
//           "relationship_status": relationShipStatus,
//           "about": aboutTextEditingController.text,
//         });
//   }
//   Future profileDetailUpdateApiCallFormData2() async {
//     return await ApiHandler()
//         .apiHandler(valueNotifier: profileDetailsUpdateValueNotifier2,
//         jsonModel: defaultFromJson, url: "http://192.168.29.93:4000/edit/profile" + "?profile_url=", requestMethod: 1, formData: [
//           Tuple4("profile_file", userPicture!, "Image", "Jpeg")
//         ], formBody: {
//           "user_id": userId,
//           "username": usernameTextEditingController.text,
//           "name": fullnameTextEditingController.text,
//           // "phone": countryCode + " " + phoneTextEditingController.text,
//           "phone": phoneTextEditingController.text,
//           "email": emailTextEditingController.text,
//           //  "phone": widget.phone!,
//           "dob": selectedDate.toString(),
//           // "email": widget.email!,
//           "designation": designationTextEditingController.text,
//           "city": cityTextEditingController.text,
//           "member": memberTextEditingController.text,
//           "company": companyTextEditingController.text,
//           "job": jobTextEditingController.text,
//           "college": collegeTextEditingController.text,
//           "high_school": schoolTextEditingController.text,
//           "interest": interestTextEditingController.text,
//           // "relationship_status": relationshipStatusTextEditingController.text,
//           "relationship_status": relationShipStatus,
//           "about": aboutTextEditingController.text,
//         });
//   }
//   Future profileDetailUpdateApiCallBody1() async {
//     ByteData bytes = await rootBundle.load('assets/noProfile.jpg');
//     return await ApiHandler().apiHandler(
//         valueNotifier: profileDetailsUpdateValueNotifier1,
//         jsonModel: defaultFromJson,
//         url: editprofileUrl + "?profile_url=${widget.userPicture ?? ""}",
//         requestMethod: 1,
//         formData: (widget.userPicture == null) ? [Tuple4("profile_file", bytes.buffer.asUint8List(), "Image", "Jpeg")] : null,
//         formBody: {
//           "user_id": userId,
//            "username": usernameTextEditingController.text,
//           "name": fullnameTextEditingController.text,
//           // "phone": countryCode + " " + phoneTextEditingController.text,
//           "phone": phoneTextEditingController.text,
//           "email": emailTextEditingController.text,
//        //  "phone": widget.phone!,
//           "dob": selectedDate.toString(),
//        //   "email": widget.email!,
//           "designation": designationTextEditingController.text,
//           "city": cityTextEditingController.text,
//           "member": memberTextEditingController.text,
//           "company": companyTextEditingController.text,
//           "job": jobTextEditingController.text,
//           "college": collegeTextEditingController.text,
//           "high_school": schoolTextEditingController.text,
//           "interest": interestTextEditingController.text,
//           // "relationship_status": relationshipStatusTextEditingController.text,
//           "relationship_status": relationShipStatus,
//           "about": aboutTextEditingController.text,
//         });
//   }
//   Future profileDetailUpdateApiCallBody2() async {
//     ByteData bytes = await rootBundle.load('assets/noProfile.jpg');
//     return await ApiHandler().apiHandler(
//         valueNotifier: profileDetailsUpdateValueNotifier2,
//         jsonModel: defaultFromJson,
//         url: editprofileUrl + "?profile_url=${widget.userPicture ?? ""}",
//         requestMethod: 1,
//         formData: (widget.userPicture == null) ? [Tuple4("profile_file", bytes.buffer.asUint8List(), "Image", "Jpeg")] : null,
//         formBody: {
//           "user_id": userId,
//           "username": usernameTextEditingController.text,
//           "name": fullnameTextEditingController.text,
//           // "phone": countryCode + " " + phoneTextEditingController.text,
//           "phone": phoneTextEditingController.text,
//           "email": emailTextEditingController.text,
//           //  "phone": widget.phone!,
//           "dob": selectedDate.toString(),
//           //   "email": widget.email!,
//           "designation": designationTextEditingController.text,
//           "city": cityTextEditingController.text,
//           "member": memberTextEditingController.text,
//           "company": companyTextEditingController.text,
//           "job": jobTextEditingController.text,
//           "college": collegeTextEditingController.text,
//           "high_school": schoolTextEditingController.text,
//           "interest": interestTextEditingController.text,
//           // "relationship_status": relationshipStatusTextEditingController.text,
//           "relationship_status": relationShipStatus,
//           "about": aboutTextEditingController.text,
//         });
//   }
//
//   @override
//   void initState() {
//     this.initialiser();
//     super.initState();
//   }
//
//   dispose() {
//     super.dispose();
//     profileDetailsUpdateValueNotifier1.dispose();
//     profileDetailsUpdateValueNotifier2.dispose();
//     usernameTextEditingController.dispose();
//     fullnameTextEditingController.dispose();
//     designationTextEditingController.dispose();
//     cityTextEditingController.dispose();
//     companyTextEditingController.dispose();
//     phoneTextEditingController.dispose();
//     jobTextEditingController.dispose();
//     collegeTextEditingController.dispose();
//     schoolTextEditingController.dispose();
//     interestTextEditingController.dispose();
//     memberTextEditingController.dispose();
//     aboutTextEditingController.dispose();
//   }
//
//   initialiser() async {
//     if (widget.username != null) {
//       usernameTextEditingController.text = widget.username!;
//     }
//     // if (widget.fullname != null) {
//     //   fullnameTextEditingController.text = widget.fullname!;
//     // }
//     // if (widget.phone != null) {
//     //   phoneTextEditingController.text = widget.phone!.split(" ").last;
//     //   countryCode = widget.phone!.split(" ").first;
//     // }
//     // if (widget.dob != null) {
//     //   selectedDate = DateTime.parse(widget.dob!);
//     // }
//     if (widget.designation != null) {
//       designationTextEditingController.text = widget.designation!;
//     }
//     // if (widget.city != null) {
//     //   cityTextEditingController.text = widget.city!;
//     // }
//     if (widget.company != null) {
//       companyTextEditingController.text = widget.company!;
//     }
//     if (widget.job != null) {
//       jobTextEditingController.text = widget.job!;
//     }
//     if (widget.phone != null) {
//       phoneTextEditingController.text = widget.job!;
//     }
//     // if (widget.college != null) {
//     //   collegeTextEditingController.text = widget.college!;
//     // }
//     // if (widget.highSchool != null) {
//     //   schoolTextEditingController.text = widget.highSchool!;
//     // }
//     // if (widget.interest != null) {
//     //   interestTextEditingController.text = widget.interest!;
//     // }
//     // if (widget.relationshipStatus != null) {
//     //   // relationshipStatusTextEditingController.text = widget.relationshipStatus!;
//     //   relationShipStatus = widget.relationshipStatus!;
//     // }
//     // if (widget.about != null) {
//     //   aboutTextEditingController.text = widget.about!;
//     // }
//     // if (widget.member != null) {
//     //   memberTextEditingController.text = widget.member!;
//     // }
//     // if (widget.userPicture != null) {
//     //   userPicture = await downloadToBytes(widget.userPicture!);
//     // }
//     if (!mounted) return;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: AnimatedBuilder(
//         animation: Listenable.merge([profileDetailsUpdateValueNotifier1,profileDetailsUpdateValueNotifier2]),
//         builder: (context, child) {
//           return ResponsiveBuilder(
//             builder: (context, sizingInformation) => Scaffold(
//               backgroundColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//               appBar: AppBar(
//                 centerTitle: false,
//                 automaticallyImplyLeading: false,
//                 elevation: 0,
//                 title: Text(
//                   "Edit Profile",
//                   style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
//                 ),
//                 leading: IconButton(
//                   splashColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   hoverColor: Colors.transparent,
//                   icon: Icon(Icons.arrow_back, size: 30),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//               body: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: userImagePicker(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: username(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: fullname(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: designation(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: dateOfBirth(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: phone(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 15),
//                           child: city(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: member(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: company(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: job(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: college(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: highSchool(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: interest(),
//                         ),
//                         // Padding(
//                         //   padding: const EdgeInsets.only(top: 10),
//                         //   child: relationshipStatus(),
//                         // ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 15),
//                           child: about(),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: saveButton(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget userImagePicker() {
//     return Stack(
//       children: [
//         CircleAvatar(
//           radius: 50,
//           backgroundColor: Colors.transparent,
//           backgroundImage: (userPicture != null)
//               ? Image.memory(userPicture!).image
//               : (widget.userPicture != null)
//               ? Image.network(widget.userPicture!).image
//               : AssetImage("assets/noProfile.jpg"),
//         ),
//         Positioned(
//           bottom: 0,
//           right: 0,
//           child: flatButton(
//               backgroundColor: Color(accent),
//               size: Size(30, 30),
//               radius: 30,
//               onPressed: () async {
//                 return await gallery().then((value) async {
//                   if (value != null && value.files.first.size < 52428800) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => AssetPageView(
//                               fileList: value.files,
//                               onPressed: () {
//                                 Navigator.pop(context);
//                                 if (!mounted) return;
//                                 setState(() {
//                                   userPicture = value.files.first.bytes;
//                                   userPictureFileName = value.files.first.name;
//                                 });
//                               },
//                             )));
//                   }
//                 });
//               },
//               child: Icon(
//                 Linecons.camera,
//                 size: 20,
//               )),
//         ),
//       ],
//     );
//   }
//
//   Widget username() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "User Name",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//               fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//               borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//               // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//               textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//               textEditingController: usernameTextEditingController,
//               labelText: "User name",
//               labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//              // validator: (value) => usernameValidator(value)
//     ),
//         ),
//       ],
//     );
//   }
//
//   Widget fullname() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "Full Name",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textFormField(
//               fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//               borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//               // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//               textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//               textEditingController: fullnameTextEditingController,
//               labelText: "Full name",
//               labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//               validator: (value) => defaultValidator(value: value, type: "Full Name")),
//         ),
//       ],
//     );
//   }
//
//   Widget designation() {
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "Designation",
//             style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: designationTextEditingController,
//             labelText: "Designation",
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//            //  validator: (value) => defaultValidator(value: value, type: "Designation"),
//           ),
//         ),
//       ],
//     );
//   }
//   Widget phone() {
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "Designation",
//             style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: phoneTextEditingController,
//             labelText: "phone",
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//              //validator: (value) => defaultValidator(value: value, type: "Designation"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget dateOfBirth() {
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "Date of Birth",
//             style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//           ),
//         ),
//         GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: () async {
//             return await datePicker(context: context, selectedDate: selectedDate, startDate: DateTime(DateTime.now().year - 100), endDate: DateTime.now()).then((value) {
//               if (value != null) {
//                 if (!mounted) return;
//                 setState(() {
//                   selectedDate = value;
//                 });
//               }
//             });
//           },
//           child: container(
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
//             shadow: false,
//             border: true,
//             radius: 5,
//             backgroundColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             child: Text(
//               formatDate(selectedDate),
//               style: GoogleFonts.poppins(textStyle: textStyle()),
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   // Widget phone() {
//   //   return Column(
//   //     children: [
//   //       // Align(
//   //       //   alignment: Alignment.centerLeft,
//   //       //   child: Text(
//   //       //     "Phone",
//   //       //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//   //       //   ),
//   //       // ),
//   //       Padding(
//   //         padding: const EdgeInsets.only(top: 8),
//   //         child: textFormField(
//   //             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//   //             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//   //             enabled: (widget.phone == null) ? true : false,
//   //             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//   //             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//   //             keyboardType: TextInputType.phone,
//   //             textEditingController: phoneTextEditingController,
//   //             labelText: "Phone Number",
//   //             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//   //             // contentPadding: const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
//   //             // prefix: CountryCodePicker(
//   //             //   onChanged: (code) => countryCode = code.dialCode!,
//   //             //   initialSelection: '+91',
//   //             //   favorite: ['+91'],
//   //             // ),
//   //             prefix: Container(
//   //                 height: 30,
//   //                 child: CountryCodePicker(
//   //                   showFlag: false,
//   //                   textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//   //                   onChanged: (widget.phone == null)
//   //                       ? (code) {
//   //                           countryCode = code.dialCode!;
//   //                         }
//   //                       : null,
//   //                   initialSelection: '+91',
//   //                   favorite: ['+91'],
//   //                 )),
//   //             validator: (value) => phoneValidator(countryCode + value!)),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   Widget city() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "City",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: cityTextEditingController,
//             labelText: "City",
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//             // validator: (value) => defaultValidator(value: value, type: "City"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Widget member() {
//   //   return Column(
//   //     children: [
//   //       // Align(
//   //       //   alignment: Alignment.centerLeft,
//   //       //   child: Text(
//   //       //     "Member",
//   //       //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//   //       //   ),
//   //       // ),
//   //       Padding(
//   //         padding: const EdgeInsets.only(top: 8),
//   //         child: textField(
//   //             enabled: false,
//   //             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//   //             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//   //             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//   //             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//   //             textEditingController: memberTextEditingController,
//   //             labelText: "Member",
//   //             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//   //            // validator: (value) => defaultValidator(value: value, type: "Member")
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//   Widget member() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "Company",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: memberTextEditingController,
//             labelText: "member",
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//             // validator: (value) => defaultValidator(value: value, type: "Company"),
//           ),
//         ),
//       ],
//     );
//   }
//   Widget company() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "Company",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: companyTextEditingController,
//             labelText: "Company",
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//             // validator: (value) => defaultValidator(value: value, type: "Company"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget job() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "Job",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: jobTextEditingController,
//             labelText: "Job",
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//             // validator: (value) => defaultValidator(value: value, type: "Job"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget college() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "College",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: collegeTextEditingController,
//             labelText: "College",
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//             // validator: (value) => defaultValidator(value: value, type: "College"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget highSchool() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "High School",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: schoolTextEditingController,
//             labelText: "High School",
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//             // validator: (value) => defaultValidator(value: value, type: "High School"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget interest() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "Interest",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: interestTextEditingController,
//             labelText: "Interest",
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//             // validator: (value) => defaultValidator(value: value, type: "Interest"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget relationshipStatus() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "Relationship Status",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           // child: textFormField(
//           //     fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//           //     borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//           //     // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//           //     textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//           //     textEditingController: relationshipStatusTextEditingController,
//           //     labelText: "Relationship Status",
//           //     labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//           //     validator: (value) => defaultValidator(value: value, type: "Relationship Status")),
//           child: DropdownButtonFormField<String>(
//             decoration: InputDecoration(
//               labelText: "Relationship Status",
//               labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//               fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(5),
//                 borderSide: BorderSide(
//                   width: 2,
//                   color: (themedata.value.index == 0) ? Color(black) : Color(white),
//                 ),
//               ),
//             ),
//             validator: (value) => defaultValidator(value: value, type: "Relationship Status"),
//             items: relationshipStatusList.map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (value) {
//               if (!mounted) return;
//               setState(() {
//                 relationShipStatus = value!;
//               });
//             },
//             value: relationShipStatus,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget about() {
//     return Column(
//       children: [
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Text(
//         //     "About",
//         //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
//         //   ),
//         // ),
//         Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: textField(
//             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
//             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
//             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
//             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
//             textEditingController: aboutTextEditingController,
//             labelText: "About",
//             minLines: 3,
//             maxLines: 5,
//             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
//             // validator: (value) => defaultValidator(value: value, type: "About"),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget saveButton() {
//     return flatButton(
//         onPressed: (!loading)
//             ? () async {
//           if (!mounted) return;
//           setState(() {
//             loading = true;
//           });
//           if (userPicture != null) {
//             return await profileDetailUpdateApiCallFormData1().whenComplete(() =>profileDetailUpdateApiCallFormData1().whenComplete(
//                 () async {
//               if (profileDetailsUpdateValueNotifier1.value.item1 == 1||profileDetailsUpdateValueNotifier2.value.item1) {
//                 await updateFirestore();
//                 if (!mounted) return;
//                 setState(() {
//                   loading = false;
//                 });
//                 Navigator.pop(context, true);
//               }
//               else if (profileDetailsUpdateValueNotifier1.value.item1 == 2 || profileDetailsUpdateValueNotifier1.value.item1 == 3) {
//                 if (!mounted) return;
//                 setState(() {
//                   loading = false;
//                 });
//                 final snackBar = snackbar(content: profileDetailsUpdateValueNotifier1.value.item3);
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//               }
//             }));
//
//           }
//           else {
//             return await profileDetailUpdateApiCallBody1().whenComplete(() =>profileDetailUpdateApiCallBody2().    whenComplete(
//                     () async {
//                   if (profileDetailsUpdateValueNotifier1.value.item1 == 1) {
//                     await updateFirestore();
//                     if (!mounted) return;
//                     setState(() {
//                       loading = false;
//                     });
//                     Navigator.pop(context, true);
//                   } else if (profileDetailsUpdateValueNotifier1.value.item1 == 2 || profileDetailsUpdateValueNotifier1.value.item1 == 3) {
//                     if (!mounted) return;
//                     setState(() {
//                       loading = false;
//                     });
//                     final snackBar = snackbar(content: profileDetailsUpdateValueNotifier1.value.item3);
//                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                   }
//                 }) );
//
//           }
//           // if (DateTime.now().year - selectedDate.year >= 16) {
//           //   if (_formKey.currentState!.validate()) {
//           //     if (userPicture != null) {
//           //       return await profileDetailUpdateApiCallFormData().whenComplete(() async {
//           //         if (profileDetailsUpdateValueNotifier.value.item1 == 1) {
//           //           await updateFirestore();
//           //           if (!mounted) return;
//           //           setState(() {
//           //             loading = false;
//           //           });
//           //           Navigator.pop(context, true);
//           //         } else if (profileDetailsUpdateValueNotifier.value.item1 == 2 || profileDetailsUpdateValueNotifier.value.item1 == 3) {
//           //           if (!mounted) return;
//           //           setState(() {
//           //             loading = false;
//           //           });
//           //           final snackBar = snackbar(content: profileDetailsUpdateValueNotifier.value.item3);
//           //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           //         }
//           //       });
//           //     }
//           //     else {
//           //       return await profileDetailUpdateApiCallBody().whenComplete(() async {
//           //         if (profileDetailsUpdateValueNotifier.value.item1 == 1) {
//           //           await updateFirestore();
//           //           if (!mounted) return;
//           //           setState(() {
//           //             loading = false;
//           //           });
//           //           Navigator.pop(context, true);
//           //         } else if (profileDetailsUpdateValueNotifier.value.item1 == 2 || profileDetailsUpdateValueNotifier.value.item1 == 3) {
//           //           if (!mounted) return;
//           //           setState(() {
//           //             loading = false;
//           //           });
//           //           final snackBar = snackbar(content: profileDetailsUpdateValueNotifier.value.item3);
//           //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           //         }
//           //       });
//           //     }
//           //   } else {
//           //     if (!mounted) return;
//           //     setState(() {
//           //       loading = false;
//           //     });
//           //     final snackBar = snackbar(content: "Please fill all the fields");
//           //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           //   }
//           // }
//           // else {
//           //   if (!mounted) return;
//           //   setState(() {
//           //     loading = false;
//           //   });
//           //   final snackBar = snackbar(content: "Users should be greater than or equal to 16 years old");
//           //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//           // }
//         }
//             : null,
//         size: Size(MediaQuery.of(context).size.width, 50),
//         width: MediaQuery.of(context).size.width / 5,
//         backgroundColor: Color(accent),
//         child: Text(
//           "Save",
//           style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14)),
//         ));
//   }
//
//   Future updateFirestore() async {
//     FirebaseFirestore instance = FirebaseFirestore.instance;
//     String? url;
//     if (userPicture != null) {
//       var taskSnapshot = await Write(uid:userId ).userProfile(uid: userId, file: userPicture!, fileName: userPictureFileName!, contentType: "Image/jpeg");
//       url = await taskSnapshot.ref.getDownloadURL();
//     }
//     String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//     instance.collection("user-detail").doc(userId).update({
//       "name": fullnameTextEditingController.text,
//       "description": aboutTextEditingController.text,
//       "pic": url,
//       "updatedAt": timestamp,
//     });
//     // Future<QuerySnapshot<Map<String, dynamic>>> personalChatRoomDetails =
//     //     instance.collection("personal-chat-room-detail").where("roomId", isGreaterThanOrEqualTo: userId, isLessThanOrEqualTo: userId + '\uf8ff').get();
//     // await personalChatRoomDetails.then((value) {
//     //   if (value.docs.isNotEmpty) {
//     //     value.docs.forEach((element) async {
//     //       await instance.collection("personal-chat-room-detail").doc(element.id).update({
//     //         "members.${userId}.name": fullnameTextEditingController.text,
//     //         "members.${userId}.pic": url,
//     //       });
//     //     });
//     //   }
//     // });
//
//     Future<QuerySnapshot<Map<String, dynamic>>> personalChatRoomDetailsNotBlocked =
//     instance.collection("personal-chat-room-detail").where("members.${userId}.isBlocked", isEqualTo: false).get();
//     await personalChatRoomDetailsNotBlocked.then((value) {
//       if (value.docs.isNotEmpty) {
//         value.docs.forEach((element) async {
//           await instance.collection("personal-chat-room-detail").doc(element.id).update({
//             "members.${userId}.name": fullnameTextEditingController.text,
//             "members.${userId}.pic": url,
//           });
//         });
//       }
//     });
//
//     Future<QuerySnapshot<Map<String, dynamic>>> personalChatRoomDetailsBlocked =
//     instance.collection("personal-chat-room-detail").where("members.${userId}.isBlocked", isEqualTo: true).get();
//     await personalChatRoomDetailsBlocked.then((value) {
//       if (value.docs.isNotEmpty) {
//         value.docs.forEach((element) async {
//           await instance.collection("personal-chat-room-detail").doc(element.id).update({
//             "members.${userId}.name": fullnameTextEditingController.text,
//             "members.${userId}.pic": url,
//           });
//         });
//       }
//     });
//
//     Future<QuerySnapshot<Map<String, dynamic>>> groupDetailsRemoved = instance.collection("group-detail").where("members.${userId}.isRemoved", isEqualTo: true).get();
//     await groupDetailsRemoved.then((value) {
//       if (value.docs.isNotEmpty) {
//         value.docs.forEach((element) async {
//           await instance.collection("group-detail").doc(element.id).update({
//             "members.${userId}.name": fullnameTextEditingController.text,
//             "members.${userId}.pic": url,
//           });
//         });
//       }
//     });
//     Future<QuerySnapshot<Map<String, dynamic>>> groupDetailsNotRemoved = instance.collection("group-detail").where("members.${userId}.isRemoved", isEqualTo: false).get();
//     await groupDetailsNotRemoved.then((value) {
//       if (value.docs.isNotEmpty) {
//         value.docs.forEach((element) async {
//           await instance.collection("group-detail").doc(element.id).update({
//             "members.${userId}.name": fullnameTextEditingController.text,
//             "members.${userId}.pic": url,
//           });
//         });
//       }
//     });
//   }
//
//
//
// }

class ProfileForm extends StatefulWidget {
  final String uid;
  final String? username;
  final String? fullname;
  final String? phone;
  final String? dob;
  final String? email;
  final String? designation;
  final String? city;
  final String? member;
  final String? company;
  final String? job;
  final String? college;
  final String? highSchool;
  final String? interest;
  final String? relationshipStatus;
  final String? about;
  final String? userPicture;

  const ProfileForm({
    Key? key,
    this.member,
    this.phone,
    this.dob,
    this.email,
    this.about,
    this.city,
    this.college,
    this.company,
    this.designation,
    this.fullname,
    this.highSchool,
    this.interest,
    this.job,
    this.relationshipStatus,
    this.userPicture,
    required this.uid,
    this.username,
  }) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  String? userId;
  Future<FilePickerResult?> gallery() async =>
      await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg'],
      );
  Uint8List? userPicture;
  // String uid = getUID();
  DateTime selectedDate = DateTime.now();
  // String countryCode = '+91';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore instance = FirebaseFirestore.instance;
  String? userPictureFileName;
  String relationShipStatus = 'Single';
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController fullnameTextEditingController = TextEditingController();
  // TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController designationTextEditingController =
  TextEditingController();
  TextEditingController cityTextEditingController = TextEditingController();
  TextEditingController companyTextEditingController = TextEditingController();
  TextEditingController jobTextEditingController = TextEditingController();
  TextEditingController collegeTextEditingController = TextEditingController();
  TextEditingController schoolTextEditingController = TextEditingController();
  TextEditingController interestTextEditingController = TextEditingController();
  // TextEditingController relationshipStatusTextEditingController = TextEditingController();
  TextEditingController aboutTextEditingController = TextEditingController();
  TextEditingController memberTextEditingController = TextEditingController();

  ValueNotifier<Tuple4> profileDetailsUpdateValueNotifier =
  ValueNotifier<Tuple4>(Tuple4(-1, exceptionFromJson(alert), "Null", null));

  Future profileDetailUpdateApiCallFormData() async {
    return await ApiHandler().apiHandler(
        valueNotifier: profileDetailsUpdateValueNotifier,
        jsonModel: defaultFromJson,
        url: "http://3.110.105.86:4000/edit/profile" + "?profile_url=",
        requestMethod: 1,
        formData: [
          Tuple4("profile_file", userPicture!, "Image", "Jpeg")
        ],
        formBody: {
          "user_id": userId.toString(),
          "username": usernameTextEditingController.text,
          "name": fullnameTextEditingController.text,
          // "phone": countryCode + " " + phoneTextEditingController.text,
          "phone": widget.phone!,
          "dob": selectedDate.toString(),
          "email": widget.email!,
          "designation": designationTextEditingController.text,
          "city": cityTextEditingController.text,
          "member": memberTextEditingController.text,
          "company": companyTextEditingController.text,
          "job": jobTextEditingController.text,
          "college": collegeTextEditingController.text,
          "high_school": schoolTextEditingController.text,
          "interest": interestTextEditingController.text,
          // "relationship_status": relationshipStatusTextEditingController.text,
          "relationship_status": relationShipStatus,
          "about": aboutTextEditingController.text,
        });
  }
  Future<void> _getUID() async {
    print('uidapi');
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    userId = sharedPrefs.getString("userid");

    print("ShardPref ${userId}");
  }
  Future profileDetailUpdateApiCallBody() async {
    ByteData bytes = await rootBundle.load('assets/noProfile.jpg');
    return await ApiHandler().apiHandler(
        valueNotifier: profileDetailsUpdateValueNotifier,
        jsonModel: defaultFromJson,
        url: "http://3.110.105.86:4000/edit/profile" + "?profile_url=${widget.userPicture ?? ""}",
        requestMethod: 1,
        formData: (widget.userPicture == null)
            ? [
          Tuple4(
              "profile_file", bytes.buffer.asUint8List(), "Image", "Jpeg")
        ]
            : null,
        formBody: {
          "user_id": userId.toString(),
          "username": usernameTextEditingController.text,
          "name": fullnameTextEditingController.text,
          // "phone": countryCode + " " + phoneTextEditingController.text,
          "phone": widget.phone!,
          "dob": selectedDate.toString(),
          "email": widget.email!,
          "designation": designationTextEditingController.text,
          "city": cityTextEditingController.text,
          "member": memberTextEditingController.text,
          "company": companyTextEditingController.text,
          "job": jobTextEditingController.text,
          "college": collegeTextEditingController.text,
          "high_school": schoolTextEditingController.text,
          "interest": interestTextEditingController.text,
          // "relationship_status": relationshipStatusTextEditingContro
          //
          //
          // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ller.text,
          "relationship_status": relationShipStatus,
          "about": aboutTextEditingController.text,
        });
  }
  Future profileDetailUpdateApiCall() async {
    print('api called');
    ByteData bytes = await rootBundle.load('assets/noProfile.jpg');
    return await ApiHandler().apiHandler(
        valueNotifier: profileDetailsUpdateValueNotifier,
        jsonModel: defaultModel.defaultFromJson,
        url: "http://3.110.105.86:4000/edit/profile",
        requestMethod: 1,
        // formData: (widget.userPicture == null)
        //     ? [
        //   Tuple4(
        //       "profile_file", bytes.buffer.asUint8List(), "Image", "Jpeg")
        // ]
        //     : null,
        // formData:[],
        body: {
          "user_id": "zQLtsL3rDwcbn8Tx59hqXxO4hZx2",


          // "phone": widget.phone.toString(),
          // "dob": selectedDate.toString(),
          //"email": widget.email!,
          "college": collegeTextEditingController.text


        });
  }

  @override
  void initState() {
    this.initialiser();
    super.initState();
  }

  dispose() {
    super.dispose();
    profileDetailsUpdateValueNotifier.dispose();
    usernameTextEditingController.dispose();
    fullnameTextEditingController.dispose();
    designationTextEditingController.dispose();
    cityTextEditingController.dispose();
    companyTextEditingController.dispose();
    jobTextEditingController.dispose();
    collegeTextEditingController.dispose();
    schoolTextEditingController.dispose();
    interestTextEditingController.dispose();
    memberTextEditingController.dispose();
    aboutTextEditingController.dispose();
  }

  initialiser() async {
    if (widget.username != null) {
      usernameTextEditingController.text = widget.username!;
    }
    if (widget.fullname != null) {
      fullnameTextEditingController.text = widget.fullname!;
    }
    // if (widget.phone != null) {
    //   phoneTextEditingController.text = widget.phone!.split(" ").last;
    //   countryCode = widget.phone!.split(" ").first;
    // }
    if (widget.dob != null) {
      selectedDate = DateTime.parse(widget.dob!);
    }
    if (widget.designation != null) {
      designationTextEditingController.text = widget.designation!;
    }
    if (widget.city != null) {
      cityTextEditingController.text = widget.city!;
    }
    if (widget.company != null) {
      companyTextEditingController.text = widget.company!;
    }
    if (widget.job != null) {
      jobTextEditingController.text = widget.job!;
    }
    if (widget.college != null) {
      collegeTextEditingController.text = widget.college!;
    }
    if (widget.highSchool != null) {
      schoolTextEditingController.text = widget.highSchool!;
    }
    if (widget.interest != null) {
      interestTextEditingController.text = widget.interest!;
    }
    if (widget.relationshipStatus != null) {
      // relationshipStatusTextEditingController.text = widget.relationshipStatus!;
      relationShipStatus = widget.relationshipStatus!;
    }
    if (widget.about != null) {
      aboutTextEditingController.text = widget.about!;
    }
    if (widget.member != null) {
      memberTextEditingController.text = widget.member!;
    }
    // if (widget.userPicture != null) {
    //   userPicture = await downloadToBytes(widget.userPicture!);
    // }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: AnimatedBuilder(
        animation: Listenable.merge([profileDetailsUpdateValueNotifier]),
        builder: (context, child) {
          return FutureBuilder(
              future: _getUID(),
              builder: (context,_) {
                print('Lotus96${userId}');
                return ResponsiveBuilder(
                  builder: (context, sizingInformation) => Scaffold(
                    backgroundColor: (themedata.value.index == 0)
                        ? Color(white)
                        : Color(materialBlack),
                    appBar: AppBar(
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      title: InkWell(
                        onTap: (){
                          print('Lotus55${userId}');
                        },
                        child: Text(
                          "Edit Profile",
                          style: GoogleFonts.poppins(
                              textStyle:
                              textStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                      ),
                      leading: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Icon(Icons.arrow_back, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: userImagePicker(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: username(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: fullname(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: designation(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: dateOfBirth(),
                              // ),
                              // // Padding(
                              // //   padding: const EdgeInsets.only(top: 10),
                              // //   child: phone(),
                              // // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 15),
                              //   child: city(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: member(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: company(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: job(),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: college(),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: highSchool(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: interest(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: relationshipStatus(),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 15),
                              //   child: about(),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: saveButton(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
          );
        },
      ),
    );
  }

  Widget userImagePicker() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          backgroundImage: (userPicture != null)
              ? Image.memory(userPicture!).image
              : (widget.userPicture != null)
              ? Image.network(widget.userPicture!).image
              : AssetImage("assets/noProfile.jpg"),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: flatButton(
              backgroundColor: Color(accent),
              size: Size(30, 30),
              radius: 30,
              onPressed: () async {
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
                                  userPicture = value.files.first.bytes;
                                  userPictureFileName =
                                      value.files.first.name;
                                });
                              },
                            )));
                  }
                });
              },
              child: Icon(
                Linecons.camera,
                size: 20,
              )),
        ),
      ],
    );
  }

  Widget username() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "User Name",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textFormField(
              fillColor: (themedata.value.index == 0)
                  ? Color(white)
                  : Color(materialBlack),
              borderColor:
              (themedata.value.index == 0) ? Color(black) : Color(white),
              // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
              textStyle: GoogleFonts.poppins(textStyle: textStyle()),
              textEditingController: usernameTextEditingController,
              labelText: "User name",
              labelStyle: GoogleFonts.poppins(
                  textStyle: textStyle(
                      color: (themedata.value.index == 0)
                          ? Color(black)
                          : Color(white))),
              validator: (value) => usernameValidator(value)),
        ),
      ],
    );
  }

  Widget fullname() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "Full Name",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textFormField(
              fillColor: (themedata.value.index == 0)
                  ? Color(white)
                  : Color(materialBlack),
              borderColor:
              (themedata.value.index == 0) ? Color(black) : Color(white),
              // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
              textStyle: GoogleFonts.poppins(textStyle: textStyle()),
              textEditingController: fullnameTextEditingController,
              labelText: "Full name",
              labelStyle: GoogleFonts.poppins(
                  textStyle: textStyle(
                      color: (themedata.value.index == 0)
                          ? Color(black)
                          : Color(white))),
              validator: (value) =>
                  defaultValidator(value: value, type: "Full Name")),
        ),
      ],
    );
  }

  Widget designation() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "Designation",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textField(
            fillColor: (themedata.value.index == 0)
                ? Color(white)
                : Color(materialBlack),
            borderColor:
            (themedata.value.index == 0) ? Color(black) : Color(white),
            // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
            textStyle: GoogleFonts.poppins(textStyle: textStyle()),
            textEditingController: designationTextEditingController,
            labelText: "Designation",
            labelStyle: GoogleFonts.poppins(
                textStyle: textStyle(
                    color: (themedata.value.index == 0)
                        ? Color(black)
                        : Color(white))),
            // validator: (value) => defaultValidator(value: value, type: "Designation"),
          ),
        ),
      ],
    );
  }

  Widget dateOfBirth() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Date of Birth",
            style: GoogleFonts.poppins(
                textStyle: textStyle(color: Color(black), fontSize: 12)),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            return await datePicker(
                context: context,
                selectedDate: selectedDate,
                startDate: DateTime(DateTime.now().year - 100),
                endDate: DateTime.now())
                .then((value) {
              if (value != null) {
                if (!mounted) return;
                setState(() {
                  selectedDate = value;
                });
              }
            });
          },
          child: container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 10),
            shadow: false,
            border: true,
            radius: 5,
            backgroundColor: (themedata.value.index == 0)
                ? Color(white)
                : Color(materialBlack),
            borderColor:
            (themedata.value.index == 0) ? Color(black) : Color(white),
            child: Text(
              formatDate(selectedDate),
              style: GoogleFonts.poppins(textStyle: textStyle()),
            ),
          ),
        )
      ],
    );
  }

  // Widget phone() {
  //   return Column(
  //     children: [
  //       // Align(
  //       //   alignment: Alignment.centerLeft,
  //       //   child: Text(
  //       //     "Phone",
  //       //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
  //       //   ),
  //       // ),
  //       Padding(
  //         padding: const EdgeInsets.only(top: 8),
  //         child: textFormField(
  //             fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
  //             borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
  //             enabled: (widget.phone == null) ? true : false,
  //             // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
  //             textStyle: GoogleFonts.poppins(textStyle: textStyle()),
  //             keyboardType: TextInputType.phone,
  //             textEditingController: phoneTextEditingController,
  //             labelText: "Phone Number",
  //             labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
  //             // contentPadding: const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
  //             // prefix: CountryCodePicker(
  //             //   onChanged: (code) => countryCode = code.dialCode!,
  //             //   initialSelection: '+91',
  //             //   favorite: ['+91'],
  //             // ),
  //             prefix: Container(
  //                 height: 30,
  //                 child: CountryCodePicker(
  //                   showFlag: false,
  //                   textStyle: GoogleFonts.poppins(textStyle: textStyle()),
  //                   onChanged: (widget.phone == null)
  //                       ? (code) {
  //                           countryCode = code.dialCode!;
  //                         }
  //                       : null,
  //                   initialSelection: '+91',
  //                   favorite: ['+91'],
  //                 )),
  //             validator: (value) => phoneValidator(countryCode + value!)),
  //       ),
  //     ],
  //   );
  // }

  Widget city() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "City",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textField(
            fillColor: (themedata.value.index == 0)
                ? Color(white)
                : Color(materialBlack),
            borderColor:
            (themedata.value.index == 0) ? Color(black) : Color(white),
            // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
            textStyle: GoogleFonts.poppins(textStyle: textStyle()),
            textEditingController: cityTextEditingController,
            labelText: "City",
            labelStyle: GoogleFonts.poppins(
                textStyle: textStyle(
                    color: (themedata.value.index == 0)
                        ? Color(black)
                        : Color(white))),
            // validator: (value) => defaultValidator(value: value, type: "City"),
          ),
        ),
      ],
    );
  }

  Widget member() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "Member",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textFormField(
              enabled: false,
              fillColor: (themedata.value.index == 0)
                  ? Color(white)
                  : Color(materialBlack),
              borderColor:
              (themedata.value.index == 0) ? Color(black) : Color(white),
              // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
              textStyle: GoogleFonts.poppins(textStyle: textStyle()),
              textEditingController: memberTextEditingController,
              labelText: "Member",
              labelStyle: GoogleFonts.poppins(
                  textStyle: textStyle(
                      color: (themedata.value.index == 0)
                          ? Color(black)
                          : Color(white))),
              validator: (value) =>
                  defaultValidator(value: value, type: "Member")),
        ),
      ],
    );
  }

  Widget company() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "Company",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textField(
            fillColor: (themedata.value.index == 0)
                ? Color(white)
                : Color(materialBlack),
            borderColor:
            (themedata.value.index == 0) ? Color(black) : Color(white),
            // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
            textStyle: GoogleFonts.poppins(textStyle: textStyle()),
            textEditingController: companyTextEditingController,
            labelText: "Company",
            labelStyle: GoogleFonts.poppins(
                textStyle: textStyle(
                    color: (themedata.value.index == 0)
                        ? Color(black)
                        : Color(white))),
            // validator: (value) => defaultValidator(value: value, type: "Company"),
          ),
        ),
      ],
    );
  }

  Widget job() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "Job",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textField(
            fillColor: (themedata.value.index == 0)
                ? Color(white)
                : Color(materialBlack),
            borderColor:
            (themedata.value.index == 0) ? Color(black) : Color(white),
            // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
            textStyle: GoogleFonts.poppins(textStyle: textStyle()),
            textEditingController: jobTextEditingController,
            labelText: "Job",
            labelStyle: GoogleFonts.poppins(
                textStyle: textStyle(
                    color: (themedata.value.index == 0)
                        ? Color(black)
                        : Color(white))),
            // validator: (value) => defaultValidator(value: value, type: "Job"),
          ),
        ),
      ],
    );
  }

  Widget college() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "College",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textField(
            fillColor: (themedata.value.index == 0)
                ? Color(white)
                : Color(materialBlack),
            borderColor:
            (themedata.value.index == 0) ? Color(black) : Color(white),
            // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
            textStyle: GoogleFonts.poppins(textStyle: textStyle()),
            textEditingController: collegeTextEditingController,
            labelText: "College",
            labelStyle: GoogleFonts.poppins(
                textStyle: textStyle(
                    color: (themedata.value.index == 0)
                        ? Color(black)
                        : Color(white))),
            // validator: (value) => defaultValidator(value: value, type: "College"),
          ),
        ),
      ],
    );
  }

  Widget highSchool() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "High School",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textField(
            fillColor: (themedata.value.index == 0)
                ? Color(white)
                : Color(materialBlack),
            borderColor:
            (themedata.value.index == 0) ? Color(black) : Color(white),
            // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
            textStyle: GoogleFonts.poppins(textStyle: textStyle()),
            textEditingController: schoolTextEditingController,
            labelText: "High School",
            labelStyle: GoogleFonts.poppins(
                textStyle: textStyle(
                    color: (themedata.value.index == 0)
                        ? Color(black)
                        : Color(white))),
            // validator: (value) => defaultValidator(value: value, type: "High School"),
          ),
        ),
      ],
    );
  }

  Widget interest() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "Interest",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textField(
            fillColor: (themedata.value.index == 0)
                ? Color(white)
                : Color(materialBlack),
            borderColor:
            (themedata.value.index == 0) ? Color(black) : Color(white),
            // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
            textStyle: GoogleFonts.poppins(textStyle: textStyle()),
            textEditingController: interestTextEditingController,
            labelText: "Interest",
            labelStyle: GoogleFonts.poppins(
                textStyle: textStyle(
                    color: (themedata.value.index == 0)
                        ? Color(black)
                        : Color(white))),
            // validator: (value) => defaultValidator(value: value, type: "Interest"),
          ),
        ),
      ],
    );
  }

  Widget relationshipStatus() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "Relationship Status",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          // child: textFormField(
          //     fillColor: (themedata.value.index == 0) ? Color(white) : Color(materialBlack),
          //     borderColor: (themedata.value.index == 0) ? Color(black) : Color(white),
          //     // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
          //     textStyle: GoogleFonts.poppins(textStyle: textStyle()),
          //     textEditingController: relationshipStatusTextEditingController,
          //     labelText: "Relationship Status",
          //     labelStyle: GoogleFonts.poppins(textStyle: textStyle(color: (themedata.value.index == 0) ? Color(black) : Color(white))),
          //     validator: (value) => defaultValidator(value: value, type: "Relationship Status")),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Relationship Status",
              labelStyle: GoogleFonts.poppins(
                  textStyle: textStyle(
                      color: (themedata.value.index == 0)
                          ? Color(black)
                          : Color(white))),
              fillColor: (themedata.value.index == 0)
                  ? Color(white)
                  : Color(materialBlack),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  width: 2,
                  color: (themedata.value.index == 0)
                      ? Color(black)
                      : Color(white),
                ),
              ),
            ),
            validator: (value) =>
                defaultValidator(value: value, type: "Relationship Status"),
            items: relationshipStatusList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              if (!mounted) return;
              setState(() {
                relationShipStatus = value!;
              });
            },
            value: relationShipStatus,
          ),
        ),
      ],
    );
  }

  Widget about() {
    return Column(
      children: [
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Text(
        //     "About",
        //     style: GoogleFonts.poppins(textStyle: textStyle(color: Color(black), fontSize: 12)),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: textField(
            fillColor: (themedata.value.index == 0)
                ? Color(white)
                : Color(materialBlack),
            borderColor:
            (themedata.value.index == 0) ? Color(black) : Color(white),
            // errorStyle: GoogleFonts.poppins(textStyle: textStyle(fontsize: 12, color: Color(white))),
            textStyle: GoogleFonts.poppins(textStyle: textStyle()),
            textEditingController: aboutTextEditingController,
            labelText: "About",
            minLines: 3,
            maxLines: 5,
            labelStyle: GoogleFonts.poppins(
                textStyle: textStyle(
                    color: (themedata.value.index == 0)
                        ? Color(black)
                        : Color(white))),
            // validator: (value) => defaultValidator(value: value, type: "About"),
          ),
        ),
      ],
    );
  }

  Widget saveButton() {
    return flatButton(
        onPressed: (){
          print('button pressed');
          print('userid${userId.toString()}');

          profileDetailUpdateApiCall();
           updateFirestore();
        },
        child: Text('send')
      // onPressed: (!loading)
      //     ? () async {
      //   if (!mounted) return;
      //   setState(() {
      //     loading = true;
      //   });
      //   if (DateTime.now().year - selectedDate.year >= 16) {
      //     if (_formKey.currentState!.validate()) {
      //       if (userPicture != null) {
      //         return await profileDetailUpdateApiCallFormData().whenComplete(() async {
      //           if (profileDetailsUpdateValueNotifier.value.item1 == 1) {
      //             await updateFirestore();
      //             if (!mounted) return;
      //             setState(() {
      //               loading = false;
      //             });
      //             Navigator.pop(context, true);
      //           } else if (profileDetailsUpdateValueNotifier.value.item1 == 2 || profileDetailsUpdateValueNotifier.value.item1 == 3) {
      //             if (!mounted) return;
      //             setState(() {
      //               loading = false;
      //             });
      //             final snackBar = snackbar(content: profileDetailsUpdateValueNotifier.value.item3);
      //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //           }
      //         });
      //       } else {
      //         return await profileDetailUpdateApiCallBody().whenComplete(() async {
      //           if (profileDetailsUpdateValueNotifier.value.item1 == 1) {
      //             await updateFirestore();
      //             if (!mounted) return;
      //             setState(() {
      //               loading = false;
      //             });
      //             Navigator.pop(context, true);
      //           } else if (profileDetailsUpdateValueNotifier.value.item1 == 2 || profileDetailsUpdateValueNotifier.value.item1 == 3) {
      //             if (!mounted) return;
      //             setState(() {
      //               loading = false;
      //             });
      //             final snackBar = snackbar(content: profileDetailsUpdateValueNotifier.value.item3);
      //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //           }
      //         });
      //       }
      //     } else {
      //       if (!mounted) return;
      //       setState(() {
      //         loading = false;
      //       });
      //       final snackBar = snackbar(content: "Please fill all the fields");
      //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //     }
      //   }
      //   else {
      //     if (!mounted) return;
      //     setState(() {
      //       loading = false;
      //     });
      //     final snackBar = snackbar(content: "Users should be greater than or equal to 16 years old");
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   }
      // }
      //     : null,
      // size: Size(MediaQuery.of(context).size.width, 50),
      // width: MediaQuery.of(context).size.width / 5,
      // backgroundColor: Color(accent),
      // child: Text(
      //   "Save",
      //   style: GoogleFonts.poppins(textStyle: textStyle(fontSize: 14)),
      // )
    );
  }


  Future updateFirestore() async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    // String? url;
    // if (userPicture != null) {
    //   var taskSnapshot = await Write(uid: userId).userProfile(
    //       uid: userId.toString(),
    //       file: userPicture!,
    //       fileName: userPictureFileName!,
    //       contentType: "Image/jpeg");
    //   url = await taskSnapshot.ref.getDownloadURL();
    // }
    // String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    instance.collection("user-detail").doc(userId).update({
      //"name": fullnameTextEditingController.text,
      "college": collegeTextEditingController.text,

      // "pic": url,
      // "updatedAt": timestamp,
    });
    // Future<QuerySnapshot<Map<String, dynamic>>> personalChatRoomDetails =
    //     instance.collection("personal-chat-room-detail").where("roomId", isGreaterThanOrEqualTo: userId, isLessThanOrEqualTo: userId + '\uf8ff').get();
    // await personalChatRoomDetails.then((value) {
    //   if (value.docs.isNotEmpty) {
    //     value.docs.forEach((element) async {
    //       await instance.collection("personal-chat-room-detail").doc(element.id).update({
    //         "members.${userId}.name": fullnameTextEditingController.text,
    //         "members.${userId}.pic": url,
    //       });
    //     });
    //   }
    // });
    //
    // Future<QuerySnapshot<Map<String, dynamic>>>
    // personalChatRoomDetailsNotBlocked = instance
    //     .collection("personal-chat-room-detail")
    //     .where("members.${userId}.isBlocked", isEqualTo: false)
    //     .get();
    // await personalChatRoomDetailsNotBlocked.then((value) {
    //   if (value.docs.isNotEmpty) {
    //     value.docs.forEach((element) async {
    //       await instance
    //           .collection("personal-chat-room-detail")
    //           .doc(element.id)
    //           .update({
    //         "members.${userId}.name": fullnameTextEditingController.text,
    //         "members.${userId}.pic": url,
    //       });
    //     });
    //   }
    // });
    //
    // Future<QuerySnapshot<Map<String, dynamic>>> personalChatRoomDetailsBlocked =
    // instance
    //     .collection("personal-chat-room-detail")
    //     .where("members.${userId}.isBlocked", isEqualTo: true)
    //     .get();
    // await personalChatRoomDetailsBlocked.then((value) {
    //   if (value.docs.isNotEmpty) {
    //     value.docs.forEach((element) async {
    //       await instance
    //           .collection("personal-chat-room-detail")
    //           .doc(element.id)
    //           .update({
    //         "members.${userId}.name": fullnameTextEditingController.text,
    //         "members.${userId}.pic": url,
    //       });
    //     });
    //   }
    // });
    //
    // Future<QuerySnapshot<Map<String, dynamic>>> groupDetailsRemoved = instance
    //     .collection("group-detail")
    //     .where("members.${userId}.isRemoved", isEqualTo: true)
    //     .get();
    // await groupDetailsRemoved.then((value) {
    //   if (value.docs.isNotEmpty) {
    //     value.docs.forEach((element) async {
    //       await instance.collection("group-detail").doc(element.id).update({
    //         "members.${userId}.name": fullnameTextEditingController.text,
    //         "members.${userId}.pic": url,
    //       });
    //     });
    //   }
    // });
    // Future<QuerySnapshot<Map<String, dynamic>>> groupDetailsNotRemoved =
    // instance
    //     .collection("group-detail")
    //     .where("members.${userId}.isRemoved", isEqualTo: false)
    //     .get();
    // await groupDetailsNotRemoved.then((value) {
    //   if (value.docs.isNotEmpty) {
    //     value.docs.forEach((element) async {
    //       await instance.collection("group-detail").doc(element.id).update({
    //         "members.${userId}.name": fullnameTextEditingController.text,
    //         "members.${userId}.pic": url,
    //       });
    //     });
    //   }
    // });
  }
}
