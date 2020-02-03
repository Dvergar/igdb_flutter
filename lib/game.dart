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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("hoho"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter:
                        ColorFilter.mode(Colors.grey, BlendMode.darken),
                    image: NetworkImage(widget.entry.banner),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                child: SafeArea(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Hero(
                          tag: "game-name-${widget.index}",
                          child: Material(
                              type: MaterialType.transparency,
                              child: Text(widget.entry.name,
                                  style: TextStyle(fontSize: 30)))),
                      StreamBuilder(
                        stream: gameBloc.stream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) return Container();

                          var gameEntry = snapshot.data as GameEntry;
                          var ratingColor = Colors.red;
                          if (gameEntry.rating > 39)
                            ratingColor = Colors.orange;
                          if (gameEntry.rating > 59) ratingColor = Colors.green;

                          return Column(
                            children: <Widget>[
                              SizedBox(height:20),
                              CircularPercentIndicator(
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
                              SizedBox(height:20),
                              Container(
                                padding: EdgeInsets.all(15),
                                color: Colors.black.withOpacity(0.8),
                                child: Text(gameEntry.summary, style: TextStyle(fontSize:20),))
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
