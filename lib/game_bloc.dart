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
    var rest = await getRest(
        "https://api-v3.igdb.com/games/$gameId?fields=rating,summary,genres.name");

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
  List<String> genres;

  GameEntry({this.rating, this.summary, this.genres});

  factory GameEntry.fromJson(Map<String, dynamic> json) {
    List<String> getGenres(List<dynamic> jsonGenres) {
      if(jsonGenres == null) return [];
      return jsonGenres.map<String>((json) => json['name']).toList();
    }

    return GameEntry(
      rating: json["rating"] ?? 0,
      summary: json["summary"] ?? "No summary available",
      genres: getGenres(json["genres"]),
    );
  }
}
