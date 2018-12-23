import 'package:flutter/material.dart';
import 'package:munch_app/api/feed_api.dart';

class FeedItemPage extends StatelessWidget {
  final ImageFeedItem item;

  const FeedItemPage({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Text("Hi"));
  }
}