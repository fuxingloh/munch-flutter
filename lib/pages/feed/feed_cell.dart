import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:munch_app/components/ShimmerCachedImage.dart';
import 'package:munch_app/pages/feed/feed_item_page.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

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
  const FeedImageView({Key key, @required this.item}) : super(key: key);

  final ImageFeedItem item;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 24 - 24 - 16) / 2;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => FeedItemPage(item: item)),
        );
      },
      child: AspectRatio(
        aspectRatio: item.image.aspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: ShimmerImageWidget(
            minWidth: width,
            sizes: item.image.sizes,
          ),
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
        color: MColors.secondary500,
        size: 24.0,
      ),
    );
  }
}
