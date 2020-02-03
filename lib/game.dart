import 'package:flutter/material.dart';
import 'package:igdb_flutter/search_bloc.dart';

class Game extends StatefulWidget {
  int index;
  SearchEntry entry;
  Game({Key key, this.entry, this.index}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
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
                  child: Hero(
                      tag: "game-name-${widget.index}",
                      child: Material(
                          type: MaterialType.transparency,
                          child: Text(widget.entry.name,
                              style: TextStyle(fontSize: 30)))),
                )),
          ),
        ],
      ),
    );
  }
}
