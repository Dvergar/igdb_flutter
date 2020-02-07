import 'package:flutter/material.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

import 'game_bloc.dart';
import 'json_model.dart';

class Game extends StatefulWidget {
  String tag;
  SearchEntry entry;
  Game({Key key, this.entry, this.tag}) : super(key: key);

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
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.fromLTRB(5, 10, 20, 0),
                          child: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              })),
                      Expanded(
                        child: Hero(
                            tag: widget.tag,
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
                        if (!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());

                        var gameEntry = snapshot.data as GameEntry;
                        var ratingColor = Colors.red;
                        if (gameEntry.rating > 39) ratingColor = Colors.orange;
                        if (gameEntry.rating > 59) ratingColor = Colors.green;

                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 45.0),
                              child: Wrap(children: [
                                for (var involvedCompany
                                    in gameEntry.involvedCompanies)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text(involvedCompany.company.name),
                                  ),
                              ]),
                            ),
                            SizedBox(height: 20),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    flex: 1,
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
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: ratingColor,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Wrap(
                                      children: <Widget>[
                                        for (var genre in gameEntry.genres)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: InputChip(
                                              label: Text(
                                                genre.name,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
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
                                child: DescriptionTextWidget(
                                    text: gameEntry.summary,
                                    summaryLength: 200,
                                    style: TextStyle(fontSize: 20))),
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

class DescriptionTextWidget extends StatefulWidget {
  final TextStyle style;
  final String text;
  final int summaryLength;

  DescriptionTextWidget(
      {@required this.text,
      this.style: const TextStyle(),
      this.summaryLength: 50});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > widget.summaryLength) {
      firstHalf = widget.text.substring(0, widget.summaryLength);
      secondHalf =
          widget.text.substring(widget.summaryLength, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? new Text(firstHalf, style: widget.style)
          : new Column(
              children: <Widget>[
                new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                    style: widget.style),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        flag ? "show more" : "show less",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
