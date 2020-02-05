import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:igdb_flutter/game.dart';
import 'package:igdb_flutter/json_model.dart';
import 'search_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    const searchStyle = TextStyle(fontSize: 20);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: Color(0xff424242)),
                  child: TextField(
                    onSubmitted: (entry) {
                      searchBloc.search(entry);
                    },
                    style: searchStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                      hintText: "SEARCH GAMES",
                      hintStyle: searchStyle,
                      labelStyle: searchStyle,
                    ),
                  )),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder(
                    stream: searchBloc.stream,
                    builder: (context, snapshot) {
                      var searchEntries = snapshot.data as SearchEntries;
                      return snapshot.data == null
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                              child: ListView.builder(
                                  itemCount: searchEntries.entries.length,
                                  itemBuilder: (context, index) {
                                    var searchEntry =
                                        searchEntries.entries[index];

                                    return GestureDetector(
                                      onTap: () {
                                        print("ok");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Game(
                                                  entry: searchEntry,
                                                  index: index)),
                                        );
                                      },
                                      child: Card(
                                        child: Container(
                                          height: 120,
                                          padding: EdgeInsets.all(9),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            image: DecorationImage(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.grey,
                                                  BlendMode.darken),
                                              image: NetworkImage(
                                                  searchEntry.banner),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topCenter,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Hero(
                                                tag: "game-name-$index",
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: Text(
                                                    searchEntry.name,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  InputChip(
                                                    backgroundColor:
                                                        Colors.amber,
                                                    // avatar: Icon(Icons.av_timer),
                                                    label: Text(
                                                      searchEntry.platform,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                  InputChip(
                                                    backgroundColor:
                                                        Colors.black,
                                                    // avatar: Icon(Icons.av_timer),
                                                    label: Text(
                                                      searchEntry.releaseDate,
                                                      style: TextStyle(
                                                          fontSize: 15),
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
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        elevation: 5,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                      ),
                                    );
                                  }),
                            );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
