import 'package:flutter/material.dart';
class AppBarListView extends StatefulWidget {
  @override
  State<AppBarListView> createState() => _AppBarListViewState();
}

class _AppBarListViewState extends State<AppBarListView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      // Your code starts here
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue.shade100,
              height: 70,
              width: double.infinity,
              child: Row(children: [

                Padding(
                  padding:  EdgeInsets.only(left: 20),
                  child: Icon(Icons.phone),
                ),
                Padding(
                  padding:  EdgeInsets.only(left:20),
                  child: Container(color: Colors.red,height: 30,width: 300,child: ListView.builder(scrollDirection: Axis.horizontal,itemBuilder: (context,index){return Text('Lotus');})),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 20),
                  child: Icon(Icons.phone),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 20),
                  child: Icon(Icons.phone),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 20),
                  child: Icon(Icons.phone),
                ),
              ],),
            ),
          ],
        ),
        // NestedScrollView to hold a Body Widget (your list) and a SliverAppBar.
        // body: NestedScrollView(
        //   // SingleChildScrollView to not getting overflow warning
        //     body: SingleChildScrollView(child: Container() /* Your listview goes here */),
        //     // SliverAppBar goes inside here
        //     headerSliverBuilder: (context, isOk) {
        //       return <Widget>[
        //         SliverAppBar(
        //             expandedHeight: 70.0,
        //             flexibleSpace:  FlexibleSpaceBar(
        //               title: ListView.builder(scrollDirection: Axis.horizontal,itemBuilder: (context,index){
        //                 return Text('Test');
        //               }),
        //             ),
        //             actions: <Widget>[
        //               IconButton(
        //                 icon:  Icon(Icons.add_circle),
        //                 tooltip: 'Add new entry',
        //                 onPressed: () { /* ... */ },
        //               ),
        //             ]
        //         )
        //       ];
        //     }),
      ),
    );
  }
}