import 'package:flutter/material.dart';
import 'components.dart';

void main() => runApp(
    MaterialApp(theme: ThemeData(fontFamily: 'Questrial'), home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int test = 1;
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
            child: Center(child: MainButton("Pressed!"))));
  }
}

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
