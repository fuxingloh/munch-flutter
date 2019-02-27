import 'dart:async';

import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/utils/munch_analytic.dart';

enum FeedStaticCell { loading, noResult }

class FeedManager {
  final MunchApi _api = MunchApi.instance;

  List<FeedItem> _items = [];
  DateTime lastEventDate;

  FeedQuery _query = FeedQuery.created();

  bool get more {
    return _loading || _from != null;
  }

  int _from = 0;
  bool _loading = false;

  StreamController<List<Object>> _controller;

  Stream<List<Object>> stream() {
    _controller = StreamController<List<Object>>();
    _controller.add(collect());
    this.append();
    return _controller.stream;
  }

  Future reset({String latLng}) {
    _query.location.latLng = latLng;

    _items.clear();
    _from = 0;
    _loading = false;
    _controller.add(collect());
    return append();
  }

  Future append() {
    if (_from == null) return Future.value();
    if (_from > 500) return Future.value();
    if (_loading) return Future.value();

    _loading = true;

    return _api.post("/feed/query?next.from=$_from", body: _query).then((res) {
      this._loading = false;
      this._from = res.next['from'];

      var items = FeedItem.fromJsonList(res.data);
      print("Before");
      print(res['places']);
      var places = Place.fromJsonMap(res['places']);
      print("After");

      items.forEach((item) {
        item.places = item.places.map((p) => places[p.placeId]).where((p) => p != null).toList(growable: false);

        // Only Add Items that have places to ensure non null constraints
        if (item.places.isEmpty) return;
        this._items.add(item);
      });

      _controller.add(collect());

      MunchAnalytic.logEvent("feed_query", parameters: {"count": _from ?? 0});
    }).catchError((error) => _controller.addError(error));
  }

  List<Object> collect() {
    List<Object> collected = [];
    collected.addAll(_items);

    if (_loading || _from != null) {
      collected.add(FeedStaticCell.loading);
    } else if (_items.isEmpty) {
      collected.add(FeedStaticCell.noResult);
    }

    return collected;
  }
}
