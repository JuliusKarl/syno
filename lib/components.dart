import 'package:flutter/material.dart';

var mainButton = Container(
    width: 200.0,
    height: 200.0,
    child: new RawMaterialButton(
      fillColor: white,
      shape: new CircleBorder(),
      elevation: 2.0,
      child: Image.asset('assets/img/Syno-Button.png'),
      onPressed: () {
        print("Pressed!");
      },
    ));

var drawer = Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      Container(
          height: 100.0,
          child: DrawerHeader(
            child:
                Text('Recent', style: TextStyle(fontSize: 30.0, color: grey)),
          )),
      ListTile(
        title: Text('Item 1'),
        onTap: () {},
      ),
      ListTile(
        title: Text('Item 2'),
        onTap: () {},
      ),
    ],
  ),
);

var white = Color(0xFFFAFAFA);
var grey = Color(0xFF555555);
