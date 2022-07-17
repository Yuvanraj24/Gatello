import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _selectedItems = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                color: (_selectedItems.contains(index))
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.transparent,
                child: ListTile(
                  title: Text('$index'),
                  onLongPress: () {
                 if (!_selectedItems.contains(index)) {
                      setState(() {
                        _selectedItems.add(index);
                      });
                    }
                    
                  },
                  onTap: () {
                    if (_selectedItems.contains(index)) {
                      setState(() {
                        _selectedItems.add(index);
                        _selectedItems.removeWhere((val) => val == index);
                      });
                    }
                  },
                ),
              );
            }));
  }
}