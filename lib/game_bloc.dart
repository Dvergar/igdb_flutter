import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'json_model.dart';
import 'api_factory.dart';

class GameBloc {
  final gameController = StreamController.broadcast();

  Stream get stream => gameController.stream;

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
    print("getGame2");

    var json = await getJson(
        "https://api-v3.igdb.com/games/$gameId?fields=rating,summary,genres.name,involved_companies.company.name");

    print("JSON2 ${json[0]}");

    gameController.sink.add(GameEntry.fromJson(json[0]));
  }

  void dispose() {
    gameController.close();
  }
}

final gameBloc = GameBloc();
