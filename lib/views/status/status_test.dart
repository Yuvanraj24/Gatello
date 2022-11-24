import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

// import 'Network.dart';
// import 'exception_string.dart';
// import 'models/Status.dart';
// import 'models/exception/pops_exception.dart';
import 'package:http/http.dart' as http;

class StatusTest extends StatefulWidget {
    String uid;
    StatusTest({
    required this.uid

  });
 // const StatusTest({Key? key}) : super(key: key);

  @override
  State<StatusTest> createState() => _StatusTestState();
}

class _StatusTestState extends State<StatusTest> {
  List statusList=[];
  String url="http://3.110.105.86:2000/";


  @override
  void initState() {
    print("UID : ${widget.uid}");
    getStatus();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('works');
    print('itemlen${statusList.length}');
    return Scaffold(
      appBar: AppBar(
        title: Text("Status"),

      ),
      body: Center(
          child:  ListView.builder(itemCount: statusList.length ,itemBuilder: (context,index){
            print('list called');
            print('itemlen${statusList.length}');
            print('statusRes${statusList[index]["status_post"]}');
            return Image.network("${url}${statusList[index]["status_post"]}",height: 100,width: 100,);
          })
      ),
    );
  }



  void getStatus() async {
    print("UID: ${widget.uid}");
    final http.Response response = await http.post(
      Uri.parse('${url}allstatus/status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': widget.uid,
      }),);

    print(response.body);
    statusList=json.decode(response.body);
    print(statusList);
    print(statusList[0]);
    // Map<String,dynamic> temp=json.decode(statusList[0].toString());
    print(statusList[0]["status_post"]);
    // status_url=statusList[0]["status_post"];
  }

}