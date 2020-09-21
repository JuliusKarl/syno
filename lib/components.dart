import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Global Variables
var recentWords = [];

// Widgets
class MainButton extends StatefulWidget {
  final String message;
  MainButton({this.message});

  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  String message;
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text;

  @override
  initState() {
    super.initState();
    message = widget.message;
    _speech = stt.SpeechToText();
  }

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
          onPressed: _listen,
        ));
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) => {
                if (val == 'listening')
                  {print("Listening ...")}
                else if (val == 'notListening')
                  {
                    print("Stopped Listening"),
                    print(_text),
                    if (_text != '') recentWords.add(_text),
                    _speech.stop(),
                    setState(() => _isListening = false)
                  }
              },
          onError: (val) => _speech.stop());

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                }));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}

class RecentWords extends StatefulWidget {
  @override
  _RecentWordsState createState() => _RecentWordsState();
}

class _RecentWordsState extends State<RecentWords> {
  @override
  initState() {
    super.initState();
  }

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
              children: recentWords.map((word) {
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
