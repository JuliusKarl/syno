import 'package:flutter/material.dart';

// Widgets
class MainButton extends StatefulWidget {
  String message;

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
            print(widget.message);
          },
        ));
  }
}

//  Styling
var white = Color(0xFFFAFAFA);
var grey = Color(0xFF555555);
