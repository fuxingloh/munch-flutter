import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/feed/feed_cell.dart';
import 'package:munch_app/styles/texts.dart';

import 'package:rxdart/rxdart.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeedState();
}

class _FeedState extends State<FeedPage> with AutomaticKeepAliveClientMixin<FeedPage> {
  final FeedManager manager = FeedManager();
  List<Object> items = [];

  @override
  void initState() {
    super.initState();

    manager.observe().listen((items) {
      setState(() {
        this.items = items;
      });
    }, onError: (e, s) {
      print("Error: $e");
    }, onDone: () {
      print("Completed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: this.items.length,
        itemBuilder: (BuildContext context, int index) {
          Object item = this.items[index];
          switch (item) {
            case FeedStaticCell.header:
              return FeedHeaderView();

            case FeedStaticCell.loading:
              manager.append();
              return FeedLoadingView();

            default:
              return FeedImageView(item: item);
          }
        },
        staggeredTileBuilder: (int index) {
          Object item = this.items[index];
          switch (item) {
            case FeedStaticCell.header:
            case FeedStaticCell.loading:
              return StaggeredTile.fit(2);

            default:
              return StaggeredTile.fit(1);
          }
        },
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        padding: EdgeInsets.all(24),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum FeedStaticCell { header, loading }

class FeedManager {
  final MunchApi _api = MunchApi();

  List<ImageFeedItem> _items = [];
  Map<String, Place> _places = {};
  DateTime lastEventDate;

  int _from = 0;
  bool _loading = false;

  StreamController<List<Object>> _controller;

  Observable<List<Object>> observe() {
    _controller = StreamController<List<Object>>();
    _controller.add(collect());
    return new Observable<List<Object>>(_controller.stream);
  }

  void reset() {
    _items.clear();
    _places.clear();
    _from = 0;
    _loading = false;
    append();
  }

  void append() {
    if (_from == null) return;
    if (_from > 500) return;
    if (_loading) return;

    _loading = true;

    _api
        .get("/feed/images?country=sgp&latLng=1.3521,103.8198&next.from=$_from")
        .then((res) {
      this._loading = false;
      this._from = res.next['from'];

      ImageFeedResult result = ImageFeedResult.fromJson(res.data);
      this._items.addAll(result.items);
      this._places.addAll(result.places);

      _controller.add(collect());
    }).catchError((error) => _controller.addError(error));
  }

  List<Object> collect() {
    List<Object> collected = [];
    collected.add(FeedStaticCell.header);
    collected.addAll(_items);
    collected.add(FeedStaticCell.loading);
    return collected;
  }
}
