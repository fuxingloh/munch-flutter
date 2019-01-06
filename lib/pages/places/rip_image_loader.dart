import 'dart:async';

import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/places_api.dart';

class RIPImageLoader {

  bool _loading = false;
  List<PlaceImage> _images = [];

  String _placeId;
  String _next;

  bool get more => _next != null;
  List<PlaceImage> get images => _images;


  StreamController<List<PlaceImage>> _controller;

  Stream<List<PlaceImage>> start(String placeId, List<PlaceImage> initial) {
    this._placeId = placeId;
    this._next = initial.last?.sort;

    _append(initial);
    _controller = StreamController<List<PlaceImage>>();
    return _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  Future append() {
    if (_images.length > 500) return Future.value();
    if (_next == null) return Future.value();

    if (_loading) return Future.value();
    _loading = true;

    return MunchApi.instance.get('/places/$_placeId/images?size=20&next.sort=$_next')
        .then((res) {
      List<dynamic> list = res.data;
      List<PlaceImage> images = list.map((data) => PlaceImage.fromJson(data))
          .toList(growable: false);
      _loading = false;
      _next = res.next['sort'];
      _append(images);
      _controller.add(_images);
    }).catchError((error) {
      _controller.addError(error);
    });
  }


  void _append(List<PlaceImage> images) {
    images.forEach((image) {
      _images.add(image);
    });
  }
}