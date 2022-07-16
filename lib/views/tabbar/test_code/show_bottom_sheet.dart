import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ShowBottomSheet extends StatefulWidget {
  const ShowBottomSheet({Key? key}) : super(key: key);

  @override
  State<ShowBottomSheet> createState() => _ShowBottomSheetState();
}

class _ShowBottomSheetState extends State<ShowBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Sheet"),
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: (){
            showModalBottomSheet(context: context, builder: (BuildContext context){
              return Container(
                color: Colors.blue,
              );
            });
          },
          child: Text("show"),
        ),
      ),
    );
  }
}