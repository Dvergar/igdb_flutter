import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';

class GameBloc {
  final gameController = StreamController.broadcast();

  Stream get stream => gameController.stream;

  Future<List> getRest(String link) async {
    var res = await http.get(Uri.encodeFull(link),
        headers: {"Accept": "application/json", "user-key": apiKey});
    print("body ${res.body}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data as List;
      print(rest);
      return rest;
    }
    return Future.error("NO RESULT");
  }

  getGame(int gameId) async {
    print("getGame");
    var rest =
        await getRest("https://api-v3.igdb.com/games/$gameId?fields=rating,summary");

    print("REST ${rest[0]}");

    gameController.sink.add(GameEntry.fromJson(rest[0]));
  }

  void dispose() {
    gameController.close(); // close our StreamController
  }
}

final gameBloc = GameBloc();

class GameEntry {
  double rating;
  String summary;

  GameEntry({this.rating, this.summary});

  factory GameEntry.fromJson(Map<String, dynamic> json) {
    return GameEntry(
      rating: json["rating"] ?? 0,
      summary: json["summary"] ?? "No summary available",
    );
  }
}
