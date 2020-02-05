import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'json_model.dart';
import 'main.dart';

class GameBloc {
  final gameController = StreamController.broadcast();
  final gameController2 = StreamController.broadcast();

  Stream get stream => gameController.stream;
  Stream get stream2 => gameController2.stream;

  Future<dynamic> getJson(String link) async {
    var res = await http.get(Uri.encodeFull(link),
        headers: {"Accept": "application/json", "user-key": apiKey});
    print("body ${res.body}");
    if (res.statusCode == 200) {
      return json.decode(res.body);
    }
    return Future.error("NO RESULT");
  }

  getGame(int gameId) async {
    print("getGame");

    var json = await getJson(
        "https://api-v3.igdb.com/games/$gameId?fields=rating,summary,genres.name");

    var data = json as List;

    print("JSON ${data[0]}");

    gameController.sink.add(GameEntry.fromJson(data[0]));
  }

  getGame2(int gameId) async {
    print("getGame2");

    var json = await getJson(
        "https://api-v3.igdb.com/games/$gameId?fields=rating,summary,genres.name,involved_companies.company.name");

    print("JSON2 ${json[0]}");

    gameController2.sink.add(GameEntry2.fromJson(json[0]));
  }

  void dispose() {
    gameController.close();
    gameController2.close();
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
      if (jsonGenres == null) return [];
      return jsonGenres.map<String>((json) => json['name']).toList();
    }

    return GameEntry(
      rating: json["rating"] ?? 0,
      summary: json["summary"] ?? "No summary available",
      genres: getGenres(json["genres"]),
    );
  }
}
