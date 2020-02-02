import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';

class SearchBloc {
  final searchController =
      StreamController.broadcast(); // create a StreamController

  Stream get stream =>
      searchController.stream; // create a getter for our stream

   void search(String entry) {
    getSearch(entry).then((entries) => searchController.sink.add(entries));
  }

  Future<List> getRest(String link) async {
    var res = await http.get(Uri.encodeFull(link),
        headers: {"Accept": "application/json", "user-key": apiKey});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      // print(data);
      var rest = data as List;
      print(rest);
      return rest;
    }
  }

  Future<List<SearchEntry>> getSearch(String gameName) async {
    print("getSearch");
    var rest = await getRest(
        "https://api-v3.igdb.com/games/?search=$gameName&fields=name,rating,screenshots.image_id,release_dates.date,platforms.versions.platform_version_release_dates.date,platforms.abbreviation,platforms.platform_logo.image_id");

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
  double rating;
  int id;
  String screenshot;
  List releaseDates;
  Platform platform;

  SearchEntry(
      {this.name,
      this.rating,
      this.id,
      this.screenshot,
      this.platform,
      this.releaseDates});

  factory SearchEntry.fromJson(Map<String, dynamic> json) {
    getFirstFromList(list) {
      return list[0]['image_id'];
    }

    // TODO: Refactor in a functional way
    getPlatform(list) {
      var abbreviation = "N/A";
      var logo = "";
      var date = 9999999999999999;

      for (var platform in list) {
        for (var version in platform['versions']) {
          if (version['platform_version_release_dates'] != null) {
            int currentDate =
                version['platform_version_release_dates'][0]['date'];

            if (currentDate < date) {
              abbreviation = platform['abbreviation'];
              date = currentDate;
              logo = platform['platform_logo']['image_id'];
            }
          }
        }
      }
      print("LOGO $logo");

      return Platform(name: abbreviation, logo: logo);
    }

    return SearchEntry(
      name: json["name"],
      rating: json["rating"],
      id: json["id"],
      screenshot: getFirstFromList(json["screenshots"]),
      releaseDates: json["release_dates"],
      platform: getPlatform(json["platforms"]),
    );
  }
}
