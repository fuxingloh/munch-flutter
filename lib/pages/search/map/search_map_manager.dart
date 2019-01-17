import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/utils/munch_location.dart';

class MapPlace {
  MapPlace(this.place);

  Place place;
  Marker marker;

  LatLng get latLng {
    List<String> ll = place.location.latLng.split(",");
    return LatLng(double.parse(ll[0]), double.parse(ll[1]));
  }
}

class SearchMapManager {
  static const MunchApi _api = MunchApi.instance;

  final SearchQuery searchQuery;
  int _page = 0;

  List<SearchCard> _cards = [];
  List<MapPlace> _places = [];

  /// Whether this card manager is currently loading more content
  bool _loading = false;

  bool get loading => _loading;

  /// Whether this card manager still contains more content to be loaded  bool more = true;
  bool _more = true;

  bool get more => _more;

  StreamController<List<MapPlace>> _controller;

  SearchMapManager(this.searchQuery);

  Stream<List<MapPlace>> stream() {
    _controller = StreamController<List<MapPlace>>();
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  /// Start the stream of cards,
  /// The stream output the entire list.
  Future start() async {
    return MunchLocation.instance.request().timeout(Duration(seconds: 6)).then(
      (latLng) {
        if (_cards.length == 1 && _cards[0]?.cardId == 'SearchCardError') {
          _cards = [];
        }
      },
      onError: (error) {
        _controller.addError(error);
      },
    ).whenComplete(() {
      return _search();
    });
  }

  Future append() {
    return _search();
  }

  Future _search() {
    if (_loading || !_more) return Future.value();

    _loading = true;
    final body = searchQuery.toJson();
    return _api.post('/search?page=$_page', body: body).then((res) {
      List<dynamic> list = res.data;
      var cards = list.map((data) => SearchCard(data));
      return cards.toList(growable: false);
    }).then((List<SearchCard> cards) {
      // Append parsed cards
      this._append(cards);
      this._more = cards.isNotEmpty;
      this._page += 1;
    }, onError: (error) {
      _controller.addError(error);

      debugPrint(error);
      this._more = false;
    }).whenComplete(() {
      this._loading = false;
      _controller.add(_places);
    });
  }

  void _append(List<SearchCard> cards) {
    cards.forEach((card) {
      if (_cards.contains(card)) return;
      _cards.add(card);

      if (card.cardId == 'Place_2018-12-29') {
        _places.add(MapPlace(Place.fromJson(card['place'])));
      }
    });
  }
}
