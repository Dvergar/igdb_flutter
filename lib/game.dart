import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:igdb_flutter/game_bloc.dart';
import 'package:igdb_flutter/search_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Game extends StatefulWidget {
  int index;
  SearchEntry entry;
  Game({Key key, this.entry, this.index}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  void initState() {
    gameBloc.getGame(widget.entry.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: StreamBuilder(
            stream: gameBloc.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return Text("loading");

              var gameEntry = snapshot.data as GameEntry;
              var ratingColor = Colors.red;
              if (gameEntry.rating > 39) ratingColor = Colors.orange;
              if (gameEntry.rating > 59) ratingColor = Colors.green;

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    // primary: true,
                    pinned: true,
                    floating: true,
                    // snap: true,
                    expandedHeight: 350.0,
                    // leading: Container(),
                    // bottom: PreferredSize(
                    //   // Add this code
                    //   preferredSize: Size.fromHeight(60.0), // Add this code
                    //   child: Container(
                    //     // height: double.infinity,
                    //     color: Colors.red,
                    //     child: Row(
                    //       children: <Widget>[
                    //         IconButton(
                    //             icon: Icon(Icons.skip_previous), onPressed: null),
                    //         Expanded(
                    //           child: Text(
                    //             widget.entry.name,
                    //             style: TextStyle(fontSize: 30),
                    //             maxLines: 20,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ), // Add this code
                    // ),
                    // title: Text("ok"),

                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                      title: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width / 1.8),
                          child: AutoSizeText(
                            widget.entry.name,
                            maxLines: 2,
                          )),
                      background: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter:
                                ColorFilter.mode(Colors.grey, BlendMode.darken),
                            image: NetworkImage(widget.entry.banner),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Info'),
                            Column(
                              children: <Widget>[
                                Text(gameEntry.rating.round().toString()),
                                CircularPercentIndicator(
                                  addAutomaticKeepAlive: true,
                                  radius: 120.0,
                                  lineWidth: 13.0,
                                  animation: true,
                                  percent: gameEntry.rating / 100,
                                  center: new Text(
                                    gameEntry.rating.round().toString(),
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  footer: new Text(
                                    "Ratings",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: ratingColor,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                        padding: EdgeInsets.all(15),
                        color: Colors.black,
                        child: Text(
                          gameEntry.summary,
                          style: TextStyle(fontSize: 20),
                        ))
                  ]))
                ],
              );
            }));
  }
}
