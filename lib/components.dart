import 'package:flutter/material.dart';

// Widgets
class MainButton extends StatefulWidget {
  String message;
  int count = 0;

  MainButton(message) {
    this.message = message;
  }
  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200.0,
        height: 200.0,
        child: new RawMaterialButton(
          fillColor: white,
          shape: new CircleBorder(),
          elevation: 2.0,
          child: Image.asset('assets/img/Syno-Button.png'),
          onPressed: () {
            print(widget.count);
            setState(() {
              widget.count += 1;
            });
          },
        ));
  }
}

class RecentWords extends StatefulWidget {
  List<String> recentWords = ['Apple', 'Whoa', 'Lamp'];
  @override
  _RecentWordsState createState() => _RecentWordsState();
}

class _RecentWordsState extends State<RecentWords> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              height: 100.0,
              child: DrawerHeader(
                child: Text('Recent',
                    style: TextStyle(fontSize: 30.0, color: grey)),
              )),
          Column(
              children: widget.recentWords.map((word) {
            return ListTile(title: Text(word), onTap: () {});
          }).toList())
        ],
      ),
    ));
  }
}

//  Styling
var white = Color(0xFFFAFAFA);
var grey = Color(0xFF555555);
