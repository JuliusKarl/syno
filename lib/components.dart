import 'package:flutter/material.dart';
import 'main.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:localstorage/localstorage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Global Variables
List recentWords = [];
final LocalStorage storage = new LocalStorage('keys');

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
    button = Image.asset('assets/img/Syno-Button.png', gaplessPlayback: true);
    _speech = stt.SpeechToText();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(button.image, context);
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(button.image, context);
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
                          foregroundDecoration: connectionStatus
                              ? _isListening
                                  ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[400],
                                      backgroundBlendMode: BlendMode.hardLight,
                                    )
                                  : null
                              : BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white70,
                                  backgroundBlendMode: BlendMode.screen,
                                ),
                          child: button),
                      onPressed: connectionStatus ? _listen : () {})))),
      Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
              connectionStatus
                  ? _isListening ? "Listening ..." : "Tap to start"
                  : "No internet connection",
              style: connectionStatus
                  ? TextStyle(color: grey)
                  : TextStyle(color: Colors.grey[400])))
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
                        if (recentWords.contains(_text))
                          {
                            recentWords.removeWhere((word) => word == _text),
                          },
                        recentWords.add(_text),
                        storeRecentWords(),
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

getRecentWords() async {
  await storage.ready;
  if (storage.getItem('recentWords') != null) {
    recentWords = storage.getItem('recentWords');
  }
}

storeRecentWords() {
  storage.setItem('recentWords', recentWords);
}

clearRecentWords() async {
  await storage.clear();
  recentWords = [];
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
              margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text('Recent',
                          style: TextStyle(fontSize: 30.0, color: grey)),
                    ),
                    Container(
                        child: IconButton(
                      icon: Icon(Icons.delete,
                          size: 20,
                          color: recentWords.length > 0
                              ? grey
                              : Color(0x00000000)),
                      onPressed: () {
                        clearRecentWords();
                        setState(() {
                          recentWords = [];
                        });
                      },
                    ))
                  ])),
          Expanded(
              child: ListView.separated(
                  itemCount: recentWords.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 10,
                      indent: 15,
                      endIndent: 15,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 10, color: grey),
                        title: Text(recentWords.reversed.toList()[index]),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondPage(
                                      word: recentWords.reversed
                                          .toList()[index])));
                        });
                  }))
        ],
      ),
    ));
  }
}

//  Styling
var white = Color(0xFFFAFAFA);
var grey = Color(0xFF555555);
var orange = Color(0xFFe39768);
