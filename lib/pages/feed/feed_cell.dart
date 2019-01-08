import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/feed/feed_item_page.dart';
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
        const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text("Never eat ‘Anything’ ever again."),
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
          MaterialPageRoute(builder: (context) => FeedItemPage(item: item)),
        );
      },
      child: AspectRatio(
        aspectRatio: item.image.aspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: ShimmerSizeImage(
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
        color: MunchColors.secondary500,
        size: 24.0,
      ),
    );
  }
}
