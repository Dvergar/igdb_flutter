import 'package:firebase_remote_config/firebase_remote_config.dart';

String apiKey;

class ApiFactory {
  static Future<String> loadKey() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();

    var apiKey = remoteConfig.getString('igdb_api_key');

    return apiKey;
  }
}
