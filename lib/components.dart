import 'package:flutter/material.dart';
import 'main.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Global Variables
List recentWords = [];

// Widgets
class MainButton extends StatefulWidget {
  final String message;
  MainButton({this.message});

  @override
  _MainButtonState createState() => _MainButtonState();
}

class _MainButtonState extends State<MainButton> {
  Image button;
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text;

  @override
  initState() {
    super.initState();
    button = Image.asset('assets/img/Syno-Button.png');
    _speech = stt.SpeechToText();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(button.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          width: 230.0,
          height: 230.0,
          child: AvatarGlow(
              animate: _isListening,
              glowColor: orange,
              endRadius: 200,
              duration: Duration(milliseconds: 1500),
              showTwoGlows: true,
              child: Container(
                  height: 180,
                  width: 180,
                  child: RawMaterialButton(
                      fillColor: white,
                      shape: CircleBorder(),
                      elevation: 2.0,
                      child: Container(
                          foregroundDecoration: _isListening
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[400],
                                  backgroundBlendMode: BlendMode.hardLight,
                                )
                              : null,
                          child: button),
                      onPressed: _listen)))),
      Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            _isListening ? "Listening ..." : "Tap to start",
          ))
    ]);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) => {
                if (val == 'listening')
                  {_text = '', print("Listening ...")}
                else if (val == 'notListening')
                  {
                    print("Stopped listening: $_text"),
                    if (_text.length != null && _text != '' && _text.length > 0)
                      {
                        recentWords.add(_text),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondPage(word: _text)))
                      },
                    _speech.stop(),
                    setState(() => _isListening = false)
                  }
              },
          onError: (val) => {_speech.stop(), _isListening = false});

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
      child: Column(
        children: <Widget>[
          Container(
              height: 100.0,
              child: DrawerHeader(
                child: Text('Recent',
                    style: TextStyle(fontSize: 30.0, color: grey)),
              )),
          Expanded(
              child: ListView(
                  children: recentWords.length > 0
                      ? recentWords
                          .map((word) {
                            return Card(
                                child: ListTile(
                                    title: Text(word),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SecondPage(word: word)));
                                    }));
                          })
                          .toList()
                          .reversed
                          .toList()
                      : [
                          Center(
                              child: Text(
                            "No recent words",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[400]),
                          ))
                        ]))
        ],
      ),
    ));
  }
}

//  Styling
var white = Color(0xFFFAFAFA);
var grey = Color(0xFF555555);
var orange = Color(0xFFe39768);
