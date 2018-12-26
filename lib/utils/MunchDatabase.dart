import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MunchDatabase {
  static const String _name = "munch_database";
  static const shared = MunchDatabase();

  const MunchDatabase();

  Future<String> getPath() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _name);

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}
    return path;
  }

  Future<Database> open({
    int version = 1,
    @required OnDatabaseCreateFn onCreate,
  }) async {
    String path = await getPath();
    return openDatabase(path, version: version, onCreate: onCreate);
  }

  Future<Database> openReadOnly() async {
    String path = await getPath();
    return openReadOnlyDatabase(path);
  }
}
