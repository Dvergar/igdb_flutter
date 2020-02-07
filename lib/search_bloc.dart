import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'json_model.dart';
import 'api_factory.dart';

class SearchBloc {
  final searchcontroller = StreamController.broadcast();

  Stream get stream => searchcontroller.stream;

  Future<dynamic> getFeedJson() async {
    var res = await http.post('https://api-v3.igdb.com/games/',
        headers: {"Accept": "application/json", "user-key": apiKey},
        body:
            "fields name,screenshots.image_id,release_dates.date,platforms.versions.platform_version_release_dates.date,platforms.abbreviation,cover.image_id;"
            "sort popularity desc;");

    if (res.statusCode == 200) {
      return json.decode(res.body);
    }
    return Future.error("NO RESULT");
  }

  void feed() {
    getFeedJson().then((json) {
      var entries = SearchEntries.fromJson({'entries': json});
      searchcontroller.sink.add(entries);
    });
  }

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
        "https://api-v3.igdb.com/games/?search=$gameName&fields=name,screenshots.image_id,release_dates.date,platforms.versions.platform_version_release_dates.date,platforms.abbreviation,cover.image_id");

    return SearchEntries.fromJson({'entries': json});
  }

  void dispose() {
    searchcontroller.close();
  }
}

final searchBloc = SearchBloc();
