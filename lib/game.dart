import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  int index;
  String cover;
  String name;
  Game({Key key, this.cover, this.name, this.index}) : super(key: key);

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
                    image: NetworkImage(widget.cover),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                child: SafeArea(
                  child: Hero(
                      tag: "game-name-${widget.index}",
                      child: Material(
                          type: MaterialType.transparency,
                          child: Text(widget.name,
                              style: TextStyle(fontSize: 30)))),
                )),
          ),
        ],
      ),
    );
  }
}
