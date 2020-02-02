import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Color(0xff424242),
                child: TextField(
                  onSubmitted: (entry) => searchBloc.search(entry),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                      hintText: "SEARCH GAMES",
                      hintStyle: TextStyle(fontSize: 20)),
                )),
          ),
          Expanded(
            child: StreamBuilder(
                stream: searchBloc.stream,
                builder: (context, snapshot) {
                  var searchEntry = snapshot.data as List<SearchEntry>;
                  return snapshot.data == null
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          child: ListView.builder(
                              itemCount: searchEntry.length,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              itemBuilder: (context, index) {
                                var releasedYear =
                                    searchEntry[index].releaseDate;

                                return Card(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.grey, BlendMode.darken),
                                        image: NetworkImage(
                                            searchEntry[index].screenshot),
                                        fit: BoxFit.fitWidth,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              backgroundColor: Colors.amber,
                                              // avatar: Icon(Icons.av_timer),
                                              label: Text(
                                                searchEntry[index]
                                                    .platform
                                                    .name,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
          ),
        ],
      ),
    );
  }
}
