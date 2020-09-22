import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'components.dart';

void main() => runApp(
    MaterialApp(theme: ThemeData(fontFamily: 'Questrial'), home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Image logo;

  @override
  void initState() {
    super.initState();
    logo = Image.asset('assets/img/Syno-AppBar.png',
        height: 150, fit: BoxFit.fitHeight);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logo.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Container(width: 250.0, child: RecentWords()),
        appBar: AppBar(
          iconTheme: IconThemeData(color: grey),
          backgroundColor: white,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: Icon(Icons.history),
                onPressed: () => Scaffold.of(context).openDrawer());
          }),
          title: logo,
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 50.0),
            child: Center(child: MainButton())));
  }
}

class SecondPage extends StatefulWidget {
  final String word;
  SecondPage({this.word});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Future<Synonyms> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum(widget.word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: white,
            iconTheme: IconThemeData(color: grey),
            centerTitle: true,
            title: Text(widget.word,
                style: TextStyle(color: grey, fontWeight: FontWeight.bold))),
        body: FutureBuilder<Synonyms>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.synonym.length == 0) {
                return Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 50.0),
                        child: Text(
                          "No results",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[400]),
                        )));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.synonym.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Card(
                          child: ListTile(
                              title: Text(snapshot.data.synonym[index]),
                              onTap: () {}));
                    });
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 50.0),
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.grey[200]))));
          },
        ));
  }
}

// HTTP Fetch
Future<Synonyms> fetchAlbum(word) async {
  final response = await http.get(
      'https://wordsapiv1.p.rapidapi.com/words/${word.replaceAll(new RegExp(r"\s+\b|\b\s"), "")}/similarTo',
      headers: {
        'x-rapidapi-host': 'wordsapiv1.p.rapidapi.com',
        'x-rapidapi-key': 'cf27a39d17msh2f698d0bc5123d6p13a834jsnb4c356ae1541'
      });

  if (response.statusCode == 200) {
    return Synonyms.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load synonyms');
  }
}

class Synonyms {
  final synonym;
  Synonyms({this.synonym});

  factory Synonyms.fromJson(Map<String, dynamic> json) {
    return Synonyms(synonym: json['similarTo']);
  }
}
