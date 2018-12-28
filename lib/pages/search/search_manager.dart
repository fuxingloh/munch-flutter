import 'dart:async';

import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/utils/munch_location.dart';

class SearchManager {
  static const MunchApi _api = MunchApi.instance;

  final DateTime _date = DateTime.now();

  final SearchQuery searchQuery;
  int _page = 0;

  // TODO Shimmer cards
  List<SearchCard> _cards = [];

  /// Whether this card manager is currently loading more content
  bool _loading = false;
  bool get loading => _loading;

  /// Whether this card manager still contains more content to be loaded  bool more = true;
  bool _more = true;

  bool get more => _more;

  StreamController<List<SearchCard>> _controller;

  SearchManager(this.searchQuery);

  Stream<List<SearchCard>> stream() {
    _controller = StreamController<List<SearchCard>>();
    _controller.add(_cards);
    return _controller.stream;
  }

  /// Start the stream of cards,
  /// The stream output the entire list.
  Future start() async {
    return MunchLocation.instance.request().timeout(Duration(seconds: 6)).then(
      (latLng) {
        // TODO Replace Error Card
        // Reset error cards if succeed
        // if self.cards.get(0) is SearchStaticErrorCard {
        // self.cards = []
        // }
      },
      onError: (error) {
        // TODO Create Error Card
        // self.cards = [SearchStaticErrorCard.create(type: .location)]
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
    var body = searchQuery.toJson();
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
      print(error);
      // if let error = res.meta.error, let type = error.type {
      //                        if type == "UnsupportedException" {
      //                            return [SearchStaticUnsupportedCard.card]
      //                        } else {
      //                            return [SearchStaticErrorCard.create(type: .message(type, error.message))]
      //                        }
      //                    }
      // TODO Error handling
      //                        if let error = error as? MoyaError {
//                            switch error {
//                            case let .statusCode(response):
//                                let type = response.meta.error?.type ?? "Unknown Error"
//                                let message = response.meta.error?.message
//                                self.cards.append(SearchStaticErrorCard.create(type: .message(type, message)))
//
//                            case let .underlying(error, _):
//                                self.cards.append(SearchStaticErrorCard.create(type: .error(error)))
//
//                            default: break
//                            }
//                        }
      this._more = false;
    }).whenComplete(() {
      this._loading = false;
      _controller.add(_cards);
    });
  }

  void _append(List<SearchCard> cards) {
    cards.forEach((card) {
      if (_cards.contains(card)) return;
      _cards.add(card);
    });
  }
}
