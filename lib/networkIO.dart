import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

trainModels(Map<String, dynamic> appConfig) async {
  String db = appConfig['database']['db'];
  String subset = appConfig['database']['subset'];
  String url = '/database/' + db + '/subset/' + subset + '/train';

  Map<String, dynamic> models;
  try {
    http.Response modelsResponse = await http.post(appConfig['address'] + url);

    models = jsonDecode(modelsResponse.body);
  } catch (e) {
    // something with the web request went wrong, use local file fallback
    print(e);
  }
  return models;
}

getDatabase(Map<String, dynamic> appConfig) async {
  String db = appConfig['database']['db'];
  String url = '/database/' + db;

  Map<String, dynamic> database;
  try {
    http.Response subsetResponse = await http
        .get(appConfig['address'] + url)
        .timeout(new Duration(seconds: 5));
    if (subsetResponse.statusCode != 200)
      throw new Exception("Server Response: ${subsetResponse.statusCode}");
    database = jsonDecode(subsetResponse.body);
  } on TimeoutException catch (e) {
    throw TimeoutException("Server did not respond in time.");
  } catch (e) {
    throw e;
  }
  return database;
}

getSubset(Map<String, dynamic> appConfig) async {
  String db = appConfig['database']['db'];
  String subsetName = appConfig['database']['subset'];
  String url = '/database/' + db + '/subset/' + subsetName;

  Map<String, dynamic> subset;
  try {
    http.Response subsetResponse = await http.get(appConfig['address'] + url);
    subset = jsonDecode(subsetResponse.body);
  } catch (e) {
    print(e);
  }
  return subset;
}
