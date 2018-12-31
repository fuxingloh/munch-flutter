import 'dart:convert';
import 'dart:io';

import 'package:munch_app/api/search_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class RecentSearchQueryDatabase extends RecentDatabase<SearchQuery> {
  RecentSearchQueryDatabase()
      : super(
          name: "SearchQuery+${SearchQuery.version}",
          maxSize: 10,
          fromJson: (json) => SearchQuery.fromJson(json),
          toJson: (SearchQuery query) => query.toJson(),
        );
}

abstract class RecentDatabase<T> {
  final _uuid = Uuid();

  final String _name;
  final int _maxSize;

  final T Function(Map<String, dynamic> json) _fromJson;
  final Map<String, dynamic> Function(T object) _toJson;

  RecentDatabase({
    String name,
    int maxSize,
    T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> Function(T object) toJson,
  })  : this._name = name,
        this._maxSize = maxSize,
        this._fromJson = fromJson,
        this._toJson = toJson;

  Future<File> get _file async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;

    return File('$path/recent_$_name.json');
  }

  Future<List<dynamic>> get _rawList async {
    final file = await _file;
    String contents = await file.readAsString();

    return jsonDecode(contents);
  }

  Future<List<T>> get() async {
    List<dynamic> rawList = await _rawList;

    return rawList.map((data) {
      return _fromJson(data.data);
    });
  }

  Future put(T object, {String id}) async {
    List<dynamic> rawList = await _rawList;
    rawList.add({
      'id': id ?? _uuid.v4(),
      'data': _toJson(object),
      'millis': DateTime.now().millisecondsSinceEpoch
    });

    // Order by Millis for recency
    rawList.sort((raw1, raw2) {
      return raw1.millis > raw2.millis;
    });

    // Filter to maxSize
    rawList = rawList.sublist(0, _maxSize);

    // And persist
    final file = await _file;
    return file.writeAsString(jsonEncode(rawList));
  }
}