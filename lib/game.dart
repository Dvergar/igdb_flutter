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
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: Text("OK LOL"),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken),
            image: NetworkImage(widget.entry.banner),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      Expanded(
                        child: Hero(
                            tag: "game-name-${widget.index}",
                            child: Material(
                                type: MaterialType.transparency,
                                child: Text(widget.entry.name,
                                    style: TextStyle(fontSize: 30)))),
                      ),
                    ],
                  )),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    StreamBuilder(
                      stream: gameBloc.stream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) return Text("Loading");

                        var gameEntry = snapshot.data as GameEntry;
                        var ratingColor = Colors.red;
                        if (gameEntry.rating > 39) ratingColor = Colors.orange;
                        if (gameEntry.rating > 59) ratingColor = Colors.green;

                        return Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                Flexible(
                                  flex:1,
                                                                    child: CircularPercentIndicator(
                                    radius: 80.0,
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
                                ),
                                Flexible(
                                  flex:2,
                                                                    child: Wrap(
                                    children: <Widget>[
                                      for (var genre in gameEntry.genres)
                                        Padding(
                                          padding: const EdgeInsets.only(right:8.0),
                                          child: InputChip(
                                            label: Text(genre),
                                            backgroundColor: Colors.red,
                                            onPressed: () {},
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              ]),
                            SizedBox(height: 20),
                            Container(height: 10, color: Colors.red),
                            Container(
                                padding: EdgeInsets.all(15),
                                color: Colors.black,
                                child: Text(
                                  gameEntry.summary,
                                  style: TextStyle(fontSize: 20),
                                ))
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
