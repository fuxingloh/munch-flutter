import 'dart:async';

import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/utils/MunchDatabase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

class PlaceSavedDatabase {
  static PlaceSavedDatabase instance = PlaceSavedDatabase();

  MunchApi _api = MunchApi.instance;
  Database _database;

  StreamController<List<UserSavedPlace>> _controller;

  Future<Database> _openDB() async {
    if (_database == null) {
      _database = await MunchDatabase.shared.open(onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE PlaceSavedDatabase (
            placeId TEXT PRIMARY KEY,
            createdMillis INTEGER NOT NULL,
            json TEXT NOT NULL
          );''');
      });
    }

    return _database;
  }

  Observable<List<Object>> observe() {
    _controller = StreamController<List<UserSavedPlace>>();
    _notifyObserver();
    return new Observable<List<Object>>(_controller.stream);
  }

  Future<bool> isSaved(String placeId) {
    return _openDB().then((database) async {
      List<Map> maps = await database.query("PlaceSavedDatabase",
          where: 'placeId = ?', whereArgs: [placeId]);

      return maps.isNotEmpty;
    });
  }

  Future reset({bool reload = true}) {
    return _openDB().then((database) async {
      await database.delete("PlaceSavedDatabase");
    }).then((i) {
      if (reload) _load();
    });
  }

  Future _load({int next}) {
    String qs = '${next != null ? '?next.createdMillis=$next' : ''}';
    return _api.get('/users/saved/places$qs').then((res) async {
      await _openDB().then((database) async {
        List<dynamic> places = res.data;
        places.forEach((json) async {
          await database.insert(
            "PlaceSavedDatabase",
            {
              'placeId': json['placeId'],
              'json': jsonEncode(json),
              'createdMillis': json['createdMillis'],
            },
          );
        });
      });

      _notifyObserver();

      var millis = res.next != null ? res.next['createdMillis'] : null;
      if (millis != null) _load(next: millis);
    });
  }

  Future<bool> toggle(String placeId) {
    return isSaved(placeId).then((saved) async {
      if (saved) {
        await delete(placeId);
        return false;
      } else {
        await put(placeId);
        return true;
      }
    });
  }

  Future put(String placeId) {
    return _api.put('/users/recent/places/$placeId').then((res) {
      return reset();
    });
  }

  Future delete(String placeId) {
    return _api.delete('/users/recent/places/$placeId').then((res) {
      return reset();
    });
  }

  void _notifyObserver() {
    _openDB().then((database) async {
      var places = await database
          .query("PlaceSavedDatabase", orderBy: "createdMillis desc")
          .then((list) {
        return list.map((map) {
          return UserSavedPlace.fromJson(jsonDecode(map['json']));
        }).toList(growable: false);
      });

      _controller.add(places);
    });
  }
}
