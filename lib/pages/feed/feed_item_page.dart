import 'package:flutter/material.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:munch_app/components/place_card.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/separators.dart';
import 'package:munch_app/styles/texts.dart';

import 'package:intl/intl.dart';

DateFormat _format = DateFormat("MMM dd, yyyy");

String _formatDate(int millis) {
  return _format.format(DateTime.fromMillisecondsSinceEpoch(millis));
}

class FeedItemPage extends StatelessWidget {
  final ImageFeedItem item;

  const FeedItemPage({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _FeedItemImage(item: item),
          _FeedItemContent(item: item),
          _FeedItemPlace(item: item),
        ],
      ),
    );
  }
}

class _FeedItemImage extends StatelessWidget {
  const _FeedItemImage({Key key, this.item}) : super(key: key);

  final ImageFeedItem item;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: item.image.aspectRatio,
        child: ShimmerImageWidget(
          sizes: item.image.sizes,
        ));
  }
}

class _FeedItemContent extends StatelessWidget {
  const _FeedItemContent({Key key, this.item}) : super(key: key);

  final ImageFeedItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SeparatorWidget(),
        Container(
          margin: const EdgeInsets.only(top: 16, left: 24, right: 24),
          child: Text(
            item.instagram.caption,
            style: MTextStyle.regular,
            maxLines: 2,
          ),
        ),
        Container(
          margin:
              const EdgeInsets.only(top: 8, bottom: 24, left: 24, right: 24),
          child: RichText(
            text: TextSpan(text: "by ", style: MTextStyle.h4, children: [
              TextSpan(
                text: item.instagram.username,
                style: TextStyle(color: MColors.secondary700),
              ),
              TextSpan(text: " on ${_formatDate(item.createdMillis)}"),
            ]),
          ),
        ),
        const SeparatorWidget(),
      ],
    );
  }
}

class _FeedItemPlace extends StatelessWidget {
  const _FeedItemPlace({Key key, this.item}) : super(key: key);

  final ImageFeedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 120, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Place Mentioned", style: MTextStyle.h2),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: PlaceCard(place: item.places?.first),
          ),
        ],
      ),
    );
  }
}
