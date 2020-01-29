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
  loadAPIKey().then((data) {
    apiKey = data;
    print('API Key is $apiKey');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IGDB Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'IGDB Flutter'),
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
    var rest = await getRest(
        "https://api-v3.igdb.com/games/?search=zelda&fields=name,rating");

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
                          // return Container(
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(image:NetworkImage(
                          //         'https://placeimg.com/640/480/any',
                          //       ),
                          //         fit: BoxFit.cover,
                          //       ),
                          //   ),
                          // child:Text("hello"));
                          return Card(
                            // semanticContainer: true,
                            // clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://placeimg.com/640/480/any',
                                  ),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                              child: Text(searchEntry[index].name),
                            ),
                            // Stack(
                            //   children: <Widget>[
                            //     Image.network(
                            //       'https://placeimg.com/640/480/any',
                            //       fit: BoxFit.fitWidth,
                            //     ),

                            //     ListTile(
                            //   title: Text(
                            //     searchEntry[index].name,
                            //   ),
                            //   trailing: Text("ok"),
                            // )
                            // ],
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

  SearchEntry({this.name, this.rating});

  factory SearchEntry.fromJson(Map<String, dynamic> json) {
    return SearchEntry(name: json["name"], rating: json["rating"]);
  }
}
