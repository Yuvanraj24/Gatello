

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PersonalChat extends StatefulWidget {
  const PersonalChat({Key? key}) : super(key: key);

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  TextEditingController _controller = TextEditingController();
  int? nums;
  List Messages = [
    Message(
        isread: true,
        text: 'It is a long established fact',
        time: '3 :00pm',
        unreadcount: 1,
        nums: 1),
    Message(
        isread: false,
        text: 'It is a long established fact that a of reader',
        time: '3 :00pm',
        unreadcount: 1,
        nums: 0),
    Message(
        isread: true,
        text: 'It is a long established fact that a of reader',
        time: '3 :00pm',
        unreadcount: 1,
        nums: 1),
    Message(
        isread: false,
        text: 'It is a long established',
        time: '3 :00pm',
        unreadcount: 1,
        nums: 0),
    Message(
        isread: true,
        text: 'It is a long established fact that a of reader',
        time: '3 :00pm',
        unreadcount: 1,
        nums: 1),
  ];
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                  'assets/galetto_background/Gatello Doodle (10) 1 (1).png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          leading: Transform.translate(
            offset: Offset(6, 0),
            child: Row(
              children: [
                GestureDetector(
                  child: Image(
                    image: AssetImage(
                      'assets/left_arrow/Group 598.png',
                    ),
                    height: height * 0.18,
                    width: width * 0.067,
                  ),
                  onTap: () {},
                ),
                SizedBox(
                  width: width * 0.045,
                ),
                CircleAvatar(
                  radius: width * 0.052,
                  backgroundImage: AssetImage('assets/dp_image/Ellipse 3.png'),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
          centerTitle: false,
          titleSpacing: -10,
          title: Padding(
            padding: EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Angelena',
                  style: TextStyle(
                      fontSize: width * 0.039,
                      fontWeight: FontWeight.w500,
                      color: HexColor('#0C101D')),
                ),
                Text(
                  'last seen today at 9:21 am',
                  style: TextStyle(
                      fontSize: width * 0.0348,
                      fontWeight: FontWeight.w700,
                      color: HexColor('#0C101D')),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        // ignore: avoid_unnecessary_containers
        body: Column(
          children: [
            Container(
              height: height * 0.025,
              width: width * 0.21,
              decoration: BoxDecoration(

                  //color: Colors.black.withOpacity(0.2)
                  color: HexColor('#FCFCFC'),
                  // border: Border.all(color:HexColor('#CACACA'),
                  // width: 0.2)
                  borderRadius: BorderRadius.circular(width * 0.01),
                  boxShadow: [BoxShadow(blurRadius: 0.01)]
                 ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '20 Dec 2021',
                    style: TextStyle(
                        fontSize: width * 0.031, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: height*0.025),
            ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
//                    return  Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Container(

//             margin: EdgeInsets.only(top: 5,bottom: 5,left: 7,right: 10),

// padding: EdgeInsets.only(left: 7,right: 15,top: 3,bottom: 3.5),
//                         constraints: BoxConstraints(
// maxWidth: MediaQuery.of(context).size.width*0.4

//                         ),
//                         decoration: BoxDecoration(
// color: HexColor('#FCFCFC'),
//               borderRadius: BorderRadius.only(
//            topLeft:Radius.circular(width*0.045),
//                 topRight:Radius.circular(width*0.045),
//                 bottomLeft:Radius.circular(width*0.045),
//                           ),
                          
//    boxShadow: [new BoxShadow(
//             color: Colors.black,
//             blurRadius: 0,
//           ),]

//                         ),


//                         child: Column(
//                           children: [
//                             Text(
//                               Messages[index].text,
//                               style: TextStyle(fontSize:width*0.042,fontWeight: FontWeight.w400,
//                               color:HexColor('#0C101D')),

                              
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(Messages[index].time,  
//                                 style: TextStyle(fontSize:width*0.03,fontWeight: FontWeight.w400,
//                                   color:HexColor('#0C101D')),),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
//             margin: EdgeInsets.only(top: 5,bottom: 5,left: 7,right: 10),

// padding: EdgeInsets.only(left: 7,right: 15,top: 3,bottom: 3.5),
                        constraints: BoxConstraints(
maxWidth: MediaQuery.of(context).size.width*0.75

                        ),

     margin: EdgeInsets.only(top:5),
    padding: EdgeInsets.symmetric(

    horizontal: 5,
    vertical: 5  
    
    ),
                        decoration: BoxDecoration(
color: HexColor('#FCFCFC'),
              borderRadius: BorderRadius.only(
           topLeft:Radius.circular(width*0.045),
                topRight:Radius.circular(width*0.045),
                bottomRight:Radius.circular(width*0.045),
                          ),
                          
   boxShadow: [new BoxShadow(
            color: Colors.black,
            blurRadius: 0,
          ),]

                        ),


                        child: Column(
                          children: [
                            Text(
                              Messages[index].text,
                              style: TextStyle(fontSize:width*0.042,fontWeight: FontWeight.w400,
                              color:HexColor('#0C101D')),

                              
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(Messages[index].time,  
                                style: TextStyle(fontSize:width*0.03,fontWeight: FontWeight.w400,
                                  color:HexColor('#0C101D')),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
// return Row(
//   children: [
//     Container(
//       margin: EdgeInsets.only(top:5),
//     padding: EdgeInsets.symmetric(

//     horizontal: 5,
//     vertical: 5  
    
//     ),
//     decoration: BoxDecoration(

//       color: Colors.green,
//       borderRadius: BorderRadius.circular(15)
//     ),
    
//     child:  Text(Messages[index].text,style: TextStyle(
//       fontSize:width*0.042,fontWeight: FontWeight.w400,
//     ),),),
//   ],
// );
     
                }),
           Spacer(),
      
          
            Container(
                padding: EdgeInsets.only(left:6,right: 4,bottom: 3),
            
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        height: height*0.05,
                        width: width*0.7,
                     padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: HexColor('#FFFFFF'),
                        borderRadius: BorderRadius.circular(35.0),
                        boxShadow:  [
                          BoxShadow(
                         
                              blurRadius: 0.02,
                              color: Colors.grey)
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: width*0.02),
                         InkWell(

                            child:  Image(image: AssetImage('assets/smiley_icon/Group 703.png'),width: width*0.06,),
                           
                            onTap: () {},
                          ),
                          SizedBox(width: width*0.03,),
                          
                        
                          
                            Expanded(child: TextField(
                             
                    decoration: InputDecoration(
                border: InputBorder.none,
                      contentPadding:EdgeInsets.only(
                      
                      top:25,
                   
                      bottom: 9.7) ,
                      hintText: 'Ping here...',hintStyle: TextStyle(fontSize: width*0.04)),
                    
                            
                          )),
                          InkWell(

                            child:  Image(image: AssetImage('assets/attach_file_icon/Vector@2x.png'),
                   
                            width: width*0.065,
                          ),
                           
                            onTap: () {},
                          ),
                            SizedBox(width: width*0.06,),
                                         InkWell(

                        child: Icon(Icons.camera_alt_outlined,size: width*0.07,),
                       
                        onTap: () {},
                      ),
                       SizedBox(width: width*0.02),
                        ],
                      ),
                    ),
                  ),

                SizedBox(width: width*0.014,),
                Container(
                 
                  height: height*0.06,
                  width: width*0.13,
                  child: Image(image: AssetImage('assets/mic_icon/Frame 74.png'),
              height: height*0.2,
              width: width*0.10,),
                ),

                ],
              ),
            ),

             
          
          ],
        ),
      ),
    );
  }
}

class Message {
  late int nums;
  late String text;
  late String time;
  late bool isread;
  late int unreadcount;
  Message(
      {required this.isread,
      required this.text,
      required this.time,
      required this.unreadcount,
      required this.nums});
}



// class SearchBar extends StatelessWidget {
//   const SearchBar({
//     Key? key,
//     required this.height,
//     required this.width,
//     required TextEditingController controller,
//   }) : _controller = controller, super(key: key);

//   final double height;
//   final double width;
//   final TextEditingController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//          children: [

//     Container(
//       height: height*0.038,
//       width: width*0.8,
//       decoration: BoxDecoration(

//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(width*0.3)
//       ),
//       child: TextFormField(
//         controller: _controller,
//       ),
//     ),
//     Image(image:AssetImage('assets/mic_icon/Frame 74.png'),
//       //  height: height*0.3,
//         width: width*0.15,)
//          ],
//     );
//   }
// }



/*container chat*/
//       return Row(
// //mainAxisAlignment: nums==0 ? MainAxisAlignment.start:MainAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.all(12),
//               color: Colors.lightGreen,
//               height: height*0.052,
//               width: width*0.6,
//               child: Column(
//                 children: [
//                   Flexible(
//                    // fit: FlexFit.values,
//                     child: Text
                    
                    
//                     (  // maxLines: 1,
//                //   softWrap: true,
//             //    overflow: TextOverflow.ellipsis,
//                   Messages[index].text,style: TextStyle(
                              
//                       fontSize: width*0.07
//                     ),),
//                   ),
//                 ],
//               )),
//           ),
//         ],
//       );

// Container(
//             margin: const EdgeInsets.all(12.0),
//             height: 60,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(35.0),
//                       boxShadow: const [
//                         BoxShadow(
//                             offset: Offset(0, 2),
//                             blurRadius: 7,
//                             color: Colors.grey)
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         IconButton(
//                             icon: const Icon(
//                               Icons.mood,
//                               color: Color(0xFF00BFA5),
//                             ),
//                             onPressed: () => callEmoji()),
//                         const Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                                 hintText: "Ping here",
//                                 hintStyle: TextStyle(color: Color(0xFF00BFA5)),
//                                 border: InputBorder.none),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.attach_file,
//                               color: Color(0xFF00BFA5)),
//                           onPressed: () => callAttachFile(),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.photo_camera,
//                               color: Color(0xFF00BFA5)),
//                           onPressed: () => callCamera(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Container(
//                   padding: const EdgeInsets.all(15.0),
//                   decoration: const BoxDecoration(
//                       color: Color(0xFF00BFA5), shape: BoxShape.circle),
//                   child: InkWell(
//                     child: Icon(
//                       Icons.keyboard_voice,
//                       color: Colors.white,
//                     ),
//                     onLongPress: () => callVoice(),
//                   ),
//                 )
//               ],
//             ),
//           )