import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

var apiKey = "";
Future<String> loadAPIKey() async {
  return await rootBundle.loadString('assets/api.key');
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadAPIKey(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          apiKey = snapshot.data;
        }
        return snapshot.data == null
            ? Center(child: CircularProgressIndicator())
            : MaterialApp(
                title: 'IGDB Flutter',
                theme: ThemeData(
                    primarySwatch: Colors.blue, brightness: Brightness.dark),
                home: MyHomePage(title: 'IGDB Flutter'),
              );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List> getRest(String link) async {
    var res = await http.get(Uri.encodeFull(link),
        headers: {"Accept": "application/json", "user-key": apiKey});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      // print(data);
      var rest = data as List;
      print(rest);
      return rest;
    }
  }

  getSearch() async {
    print("getSearch");
    var rest = await getRest(
        "https://api-v3.igdb.com/games/?search=zelda&fields=name,rating,screenshots.image_id,release_dates.date");

    List<SearchEntry> list =
        rest.map<SearchEntry>((json) => SearchEntry.fromJson(json)).toList();
    print("List Size: ${list.length}");
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: getSearch(),
          builder: (context, snapshot) {
            var searchEntry = snapshot.data as List<SearchEntry>;
            return snapshot.data == null
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: ListView.builder(
                        itemCount: searchEntry.length,
                        padding: const EdgeInsets.all(2.0),
                        itemBuilder: (context, index) {
                          return Card(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.grey, BlendMode.darken),
                                  image: NetworkImage(
                                      'https://images.igdb.com/igdb/image/upload/t_screenshot_med/${searchEntry[index].screenshot}.jpg'),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      searchEntry[index].name,
                                      style: TextStyle(fontSize: 25),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(DateTime.fromMillisecondsSinceEpoch(
                                          searchEntry[index].releaseDates[0]
                                                  ['date'] *
                                              1000)
                                      .year
                                      .toString())
                                ],
                              ),
                            ),

                            // Stack(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                          );
                        }),
                  );
          }),
    );
  }
}

class SearchEntry {
  String name;
  double rating;
  int id;
  String screenshot;
  List releaseDates;
  int platformID;

  SearchEntry(
      {this.name,
      this.rating,
      this.id,
      this.screenshot,
      this.platformID,
      this.releaseDates});

  factory SearchEntry.fromJson(Map<String, dynamic> json) {
    getFirstFromList(list) {
      return list[0]['image_id'];
    }

    return SearchEntry(
      name: json["name"],
      rating: json["rating"],
      id: json["id"],
      screenshot: getFirstFromList(json["screenshots"]),
      releaseDates: json["release_dates"],
      platformID: json["platform"],
    );
  }
}
