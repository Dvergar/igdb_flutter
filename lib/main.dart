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
        "https://api-v3.igdb.com/games/?search=zelda&fields=name,rating,screenshots.image_id,release_dates.date,platforms.versions.platform_version_release_dates.date,platforms.abbreviation");

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
                          var releasedYear =
                              DateTime.fromMillisecondsSinceEpoch(
                                      searchEntry[index].releaseDates[0]
                                              ['date'] *
                                          1000)
                                  .year
                                  .toString();
                          return Card(
                            child: Container(
                              padding: EdgeInsets.all(8),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    searchEntry[index].name,
                                    style: TextStyle(fontSize: 25),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InputChip(
                                        backgroundColor: Colors.black,
                                        // avatar: Icon(Icons.av_timer),
                                        label: Text(
                                          searchEntry[index].platform,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () {},
                                      ),
                                      InputChip(
                                        backgroundColor: Colors.black,
                                        // avatar: Icon(Icons.av_timer),
                                        label: Text(
                                          releasedYear,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
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
  String platform;

  SearchEntry(
      {this.name,
      this.rating,
      this.id,
      this.screenshot,
      this.platform,
      this.releaseDates});

  factory SearchEntry.fromJson(Map<String, dynamic> json) {
    getFirstFromList(list) {
      return list[0]['image_id'];
    }

    // TODO: Refactor in a functional way
    getPlatform(list) {
      var abbreviation = "N/A";
      var date = 9999999999999999;

      for (var platform in list) {
        for (var version in platform['versions']) {
          if (version['platform_version_release_dates'] != null) {
            int currentDate =
                version['platform_version_release_dates'][0]['date'];

            if (currentDate < date) {
              abbreviation = platform['abbreviation'];
              date = currentDate;
            }
          }
        }
      }

      return abbreviation;
    }

    return SearchEntry(
      name: json["name"],
      rating: json["rating"],
      id: json["id"],
      screenshot: getFirstFromList(json["screenshots"]),
      releaseDates: json["release_dates"],
      platform: getPlatform(json["platforms"]),
    );
  }
}
