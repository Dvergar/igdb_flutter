import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';

class SearchBloc {
  final searchController = StreamController.broadcast();

  Stream get stream => searchController.stream;

  void search(String entry) {
    getSearch(entry).then((entries) => searchController.sink.add(entries));
  }

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

  Future<List<SearchEntry>> getSearch(String gameName) async {
    print("getSearch");
    var rest = await getRest(
        "https://api-v3.igdb.com/games/?search=$gameName&fields=name,screenshots.image_id,release_dates.date,platforms.versions.platform_version_release_dates.date,platforms.abbreviation,platforms.platform_logo.image_id,cover.image_id");

    List<SearchEntry> list =
        rest.map<SearchEntry>((json) => SearchEntry.fromJson(json)).toList();
    print("List Size: ${list.length}");
    return list;
  }

  void dispose() {
    searchController.close(); // close our StreamController
  }
}

final searchBloc = SearchBloc();

class Platform {
  String name;
  String logo;

  Platform({this.name, this.logo});
}

class SearchEntry {
  String name;
  int id;
  String releaseDate;
  Platform platform;
  String banner;

  SearchEntry(
      {this.name, this.id, this.platform, this.banner, this.releaseDate});

  factory SearchEntry.fromJson(Map<String, dynamic> json) {
    getPlatform(list) {
      var abbreviation = "N/A";
      var logo = "";
      var date = 9999999999999999;

      if (list == null) return Platform(name: abbreviation, logo: logo);

      for (var platform in list) {
        for (var version in platform['versions']) {
          if (version['platform_version_release_dates'] != null) {
            int currentDate =
                version['platform_version_release_dates'][0]['date'];

            if (currentDate < date) {
              abbreviation = platform['abbreviation'];
              date = currentDate;
              // logo = platform['platform_logo']['image_id'];
            }
          }
        }
      }

      return Platform(name: abbreviation, logo: logo);
    }

    getReleaseDate(List releaseDates) {
      return releaseDates != null
          ? DateTime.fromMillisecondsSinceEpoch(releaseDates[0]['date'] * 1000)
              .year
              .toString()
          : "N/A";
    }

    getBanner(Map<String, dynamic> json) {
      // SCREENSHOT
      var screenshots = json["screenshots"];
      if (screenshots != null)
        return 'https://images.igdb.com/igdb/image/upload/t_screenshot_med/${screenshots[0]['image_id']}.jpg';

      // OR COVER
      var cover = json["cover"];
      if (cover != null)
        return 'https://images.igdb.com/igdb/image/upload/t_screenshot_med/${cover["image_id"]}.jpg';

      // OR PLACEHOLDER
      return 'https://via.placeholder.com/150/FFFF00/000000';
    }

    return SearchEntry(
      name: json["name"],
      id: json["id"],
      releaseDate: getReleaseDate(json["release_dates"]),
      banner: getBanner(json),
      platform: getPlatform(json["platforms"]),
    );
  }
}
