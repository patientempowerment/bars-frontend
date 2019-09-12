import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

ensureDirExistence(String path) async {
  final dir = new Directory(path);
  dir.exists().then((isThere) async {
    if (!isThere) await dir.create(recursive: true);
  });
}

legacyReadJSON(String path) async {
  String json = await rootBundle.loadString(path);
  return jsonDecode(json);
}

directoryContents(String subDir) async {
  List<String> files = [];
  final rootDir = await getApplicationDocumentsDirectory();
  await ensureDirExistence(rootDir.path + '/' + subDir);
  final dir = new Directory(rootDir.path + '/' + subDir);

  await for (FileSystemEntity entity
  in dir.list(recursive: false, followLinks: false)) {
    files.add(entity.path.split('/').last.replaceAll('.json', ''));
  }
  return files;
}

readJSON(String subDir, String name) async {
  final rootDir = await getApplicationDocumentsDirectory();
  if (!subDir.endsWith('/')) subDir += '/';
  ensureDirExistence(rootDir.path + '/' + subDir); // TODO: need this?
  String json = await new File(rootDir.path + '/' + subDir + name + '.json')
      .readAsString();
  return jsonDecode(json);
}

writeJSON(String subDir, String filename, Map<String, dynamic> content) async {
  String json = jsonEncode(content);
  if (!subDir.endsWith('/')) subDir += '/';
  final rootDir = await getApplicationDocumentsDirectory();
  ensureDirExistence(rootDir.path + '/' + subDir);
  await new File(rootDir.path + '/' + subDir + filename + '.json')
      .writeAsString(json);
}