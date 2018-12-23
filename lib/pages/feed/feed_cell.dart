import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeedHeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Feed", style: MTextStyle.h1),
        Container(
          margin: EdgeInsets.only(top: 0, bottom: 8),
          child: const Text("Never eat ‘Anything’ ever again.",
              style: MTextStyle.regular),
        ),
      ],
    );
  }
}

class FeedImageView extends StatelessWidget {
  final ImageFeedItem item;

  const FeedImageView({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var maxSize = item.image.maxSize;
    return AspectRatio(
      aspectRatio: item.image.aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CachedNetworkImage(
          imageUrl: maxSize.url,
          errorWidget: Icon(Icons.error),
        ),
      ),
    );
  }
}

class FeedLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: MColors.secondary700,
        size: 24.0,
      ),
    );
  }
}
