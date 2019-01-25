import 'package:flutter/material.dart';
import 'package:munch_app/api/feed_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/places/place_card.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/separators.dart';
import 'package:munch_app/styles/texts.dart';

import 'package:intl/intl.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:url_launcher/url_launcher.dart';

DateFormat _format = DateFormat("MMM dd, yyyy");

String _formatDate(int millis) {
  return _format.format(DateTime.fromMillisecondsSinceEpoch(millis));
}

class FeedImagePage extends StatefulWidget {
  const FeedImagePage({Key key, this.item}) : super(key: key);

  final ImageFeedItem item;

  @override
  State<StatefulWidget> createState() => FeedImagePageState();

  static Future<T> push<T extends Object>(BuildContext context, ImageFeedItem item) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => FeedImagePage(item: item),
        settings: RouteSettings(name: '/feed/images'),
      ),
    );
  }
}

class FeedImagePageState extends State<FeedImagePage> {
  ImageFeedItem get item {
    return widget.item;
  }

  ScrollController _controller;
  Widget _body;
  bool clear = true;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _body = Scaffold(
      body: ListView(
        controller: _controller,
        padding: EdgeInsets.zero,
        children: <Widget>[
          _FeedItemImage(item: item),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onPressed,
            child: _FeedItemContent(item: item),
          ),
          _FeedItemPlace(item: item),
        ],
      ),
    );
    super.initState();

    MunchAnalytic.logEvent("feed_view");
  }

  void onPressed() {
    void _launch(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      }
    }

    MunchDialog.showConfirm(
      context,
      title: 'Open Instagram?',
      cancel: 'Cancel',
      confirm: 'Open',
      onPressed: () {
        _launch(item.instagram?.link);
      },
    );
  }

  _scrollListener() {
    if (_controller.offset > 120) {
      if (!clear) return;
      setState(() {
        clear = false;
      });
    } else {
      if (clear) return;
      setState(() {
        clear = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bar = AppBar(
      title: Text(
        item.places.first?.name,
        textAlign: TextAlign.center,
        style: MTextStyle.navHeader
            .copyWith(color: clear ? MunchColors.white : MunchColors.black),
      ),
      backgroundColor: clear ? MunchColors.clear : MunchColors.white,
      elevation: clear ? 0 : 2,
      iconTheme:
          IconThemeData(color: clear ? MunchColors.white : MunchColors.black),
    );

    return Stack(
      children: [
        _body,
        Container(
          color: clear ? MunchColors.clear : MunchColors.white,
          child: SafeArea(
            child: SizedBox.fromSize(
              child: bar,
              size: bar.preferredSize,
            ),
          ),
        )
      ],
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
        child: ShimmerSizeImage(
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
        const SeparatorLine(),
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
              const EdgeInsets.only(top: 16, bottom: 24, left: 24, right: 24),
          child: RichText(
            text: TextSpan(text: "by ", style: MTextStyle.h5, children: [
              TextSpan(
                text: item.instagram.username,
                style: TextStyle(color: MunchColors.secondary700),
              ),
              TextSpan(text: " on ${_formatDate(item.createdMillis)}"),
            ]),
          ),
        ),
        const SeparatorLine(),
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
