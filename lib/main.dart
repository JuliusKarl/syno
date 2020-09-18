import 'package:flutter/material.dart';
import 'components.dart';

void main() => runApp(
    MaterialApp(theme: ThemeData(fontFamily: 'Questrial'), home: Home()));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Container(width: 250.0, child: drawer),
        appBar: AppBar(
          iconTheme: IconThemeData(color: grey),
          backgroundColor: white,
          title: Image.asset('assets/img/Syno-AppBar.png',
              height: 150, fit: BoxFit.fitHeight),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 80.0),
            child: Center(child: mainButton)));
  }
}

var white = Color(0xFFFAFAFA);
var grey = Color(0xFF555555);
