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
    getRecentWords();
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
  Future<Synonyms> futureSynonym;
  Future<Definition> futureDefinition;

  @override
  void initState() {
    super.initState();
    futureSynonym = fetchSynonym(widget.word);
    futureDefinition = fetchDefinition(widget.word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: white,
            iconTheme: IconThemeData(color: grey),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: grey,
                ),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
            ],
            title: Text(widget.word,
                style: TextStyle(color: grey, fontWeight: FontWeight.bold))),
        body: Column(children: [
          Container(
              padding: EdgeInsets.all(20),
              child: FutureBuilder<Definition>(
                  future: futureDefinition,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (!snapshot.data.definition.isEmpty) {
                        return Container(
                            alignment: Alignment(-1.0, -1.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      snapshot.data.definition[0]
                                          ['partOfSpeech'],
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 20,
                                          color: Colors.grey[400])),
                                  Text(
                                      snapshot.data.definition[0]['definition'],
                                      style: TextStyle(fontSize: 25))
                                ]));
                      } else {
                        return Center(
                            child: Text(
                          "No definition",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[400]),
                        ));
                      }
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Text("");
                  })),
          Expanded(
              child: FutureBuilder<Synonyms>(
            future: futureSynonym,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.synonym != null) {
                  if (snapshot.data.synonym.length == 0) {
                    return Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 50.0),
                        child: Text(
                          "No synonyms",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[400]),
                        ));
                  } else {
                    return ListView.separated(
                        itemCount: snapshot.data.synonym.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 10,
                            indent: 15,
                            endIndent: 15,
                          );
                        },
                        itemBuilder: (BuildContext ctxt, int index) {
                          return ListTile(
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: 10, color: grey),
                              title: Text(snapshot.data.synonym[index]),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SecondPage(
                                            word: snapshot.data.synonym[index]
                                                .toString())));
                              });
                        });
                  }
                } else {
                  return Center(
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 50.0),
                          child: Text(
                            '"${widget.word}" not found',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[400]),
                          )));
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
          ))
        ]));
  }
}

// HTTP Fetch Synonym
Future<Synonyms> fetchSynonym(word) async {
  final worduri = word.replaceAll(new RegExp(r'(?!\-)[^\w\s]+'), '');
  print(worduri);
  final response = await http.get(
      'https://wordsapiv1.p.rapidapi.com/words/$worduri/synonyms',
      headers: {
        'x-rapidapi-host': 'wordsapiv1.p.rapidapi.com',
        'x-rapidapi-key': 'cf27a39d17msh2f698d0bc5123d6p13a834jsnb4c356ae1541'
      });
  return Synonyms.fromJson(json.decode(response.body));
}

// HTTP Fetch Definition
Future<Definition> fetchDefinition(word) async {
  final worduri = word.replaceAll(new RegExp(r'(?!\-)[^\w\s]+'), '');
  final response = await http.get(
      'https://wordsapiv1.p.rapidapi.com/words/$worduri/definitions',
      headers: {
        'x-rapidapi-host': 'wordsapiv1.p.rapidapi.com',
        'x-rapidapi-key': 'cf27a39d17msh2f698d0bc5123d6p13a834jsnb4c356ae1541'
      });
  if (response.statusCode != 200) {
    return null;
  } else {
    return Definition.fromJson(json.decode(response.body));
  }
}

class Synonyms {
  final synonym;
  Synonyms({this.synonym});

  factory Synonyms.fromJson(Map<String, dynamic> json) {
    return Synonyms(synonym: json['synonyms']);
  }
}

class Definition {
  final definition;
  Definition({this.definition});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(definition: json['definitions']);
  }
}
