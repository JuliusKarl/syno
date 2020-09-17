import 'package:flutter/material.dart';

void main() => runApp(
    MaterialApp(theme: ThemeData(fontFamily: 'Questrial'), home: Home()));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        title: Image.asset('assets/img/Syno-AppBar.png',
            height: 150, fit: BoxFit.fitHeight),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Greetings Earth!',
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey[600],
                fontFamily: 'Questrial')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text('Click'),
      ),
    );
  }
}
