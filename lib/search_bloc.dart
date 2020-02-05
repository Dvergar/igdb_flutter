import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'json_model.dart';
import 'main.dart';

class SearchBloc {
  final searchcontroller = StreamController.broadcast();

  Stream get stream => searchcontroller.stream;

  void search(String entry) {
    getsearch(entry).then((entries) => searchcontroller.sink.add(entries));
  }

  Future<dynamic> getJson(String link) async {
    var res = await http.get(Uri.encodeFull(link),
        headers: {"Accept": "application/json", "user-key": apiKey});
    if (res.statusCode == 200) {
      return json.decode(res.body);
    }
    return Future.error("NO RESULT");
  }

  Future<SearchEntries> getsearch(String gameName) async {
    print("getsearch");
    var json = await getJson(
        "https://api-v3.igdb.com/games/?search=$gameName&fields=name,screenshots.image_id,release_dates.date,platforms.versions.platform_version_release_dates.date,platforms.abbreviation,platforms.platform_logo.image_id,cover.image_id");

    return SearchEntries.fromJson({'entries': json});
  }

  void dispose() {
    searchcontroller.close();
  }
}

final searchBloc = SearchBloc();
