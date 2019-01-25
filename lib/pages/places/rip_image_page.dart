import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/places_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/rip_image_loader.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:url_launcher/url_launcher.dart';

class RIPImagePage extends StatefulWidget {
  const RIPImagePage({
    Key key,
    this.index,
    this.imageLoader,
    this.place,
  }) : super(key: key);

  final int index;
  final Place place;
  final RIPImageLoader imageLoader;

  @override
  RIPImagePageState createState() => new RIPImagePageState();

  static Future<T> push<T extends Object>(BuildContext context, {int index, RIPImageLoader imageLoader, Place place}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => RIPImagePage(
              index: index,
              imageLoader: imageLoader,
              place: place,
            ),
        settings: RouteSettings(name: '/places/images'),
      ),
    );
  }
}

class RIPImagePageState extends State<RIPImagePage> {
  List<PlaceImage> images;
  PageController controller;

  @override
  void initState() {
    super.initState();
    this.images = widget.imageLoader.images;
    this.controller = PageController(initialPage: widget.index);

    MunchAnalytic.logEvent("rip_view_image", parameters: {"index": widget.index});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name, style: MTextStyle.navHeader),
        elevation: 2,
      ),
      body: PageView.builder(
        controller: controller,
        itemBuilder: (c, i) => _RIPImageContent(image: images[i]),
        onPageChanged: (i) {
          MunchAnalytic.logEvent("rip_view_image", parameters: {"index": i});

          if (i > images.length - 5) {
            widget.imageLoader.append().then((_) {
              setState(() => this.images = widget.imageLoader.images);
            });
          }
        },
        itemCount: images.length,
      ),
    );
  }
}

DateFormat _format = DateFormat("MMM dd, yyyy");

String _formatDate(int millis) {
  return _format.format(DateTime.fromMillisecondsSinceEpoch(millis));
}

class _RIPImageContent extends StatelessWidget {
  const _RIPImageContent({Key key, this.image}) : super(key: key);

  final PlaceImage image;

  Widget _buildTitle() {
    if (image.article != null) {
      return Text(image.title, style: MTextStyle.h4, maxLines: 1);
    } else {
      return Text(image.caption, style: MTextStyle.h4, maxLines: 1);
    }
  }

  Widget _buildAuthor() {
    final name = image.article?.domain?.name ?? image.instagram?.username;

    return RichText(
      text: TextSpan(text: "by ", style: MTextStyle.h6, children: [
        TextSpan(
          text: name,
          style: TextStyle(color: MunchColors.secondary700),
        ),
        TextSpan(text: " on ${_formatDate(image.createdMillis)}"),
      ]),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: maxSize(image.sizes).aspectRatio,
      child: Container(
        color: MunchColors.black75,
        child: ShimmerSizeImage(
          sizes: image.sizes,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _buildCaption() {
    return Text(image.caption, style: MTextStyle.regular, maxLines: 3);
  }

  Widget _buildMore(BuildContext context) {
    return MunchButton.text(
      "Read More",
      onPressed: () => _onReadMore(context),
      style: MunchButtonStyle.secondaryOutline,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Padding(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
        child: _buildTitle(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
        child: _buildAuthor(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        child: _buildImage(),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: _buildCaption(),
      ),
    ];

    if (image.article != null) {
      children.add(Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.all(24),
        child: _buildMore(context),
      ));
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 48),
      children: children,
    );
  }

  void _onReadMore(BuildContext context) {
    _launch(String url, String event) async {
      if (url == null) return;

      if (await canLaunch(url)) {
        MunchAnalytic.logEvent(event);
        await launch(url);
      }
    }

    if (image.article != null) {
      MunchDialog.showConfirm(
        context,
        content: 'Open Article?',
        cancel: 'Cancel',
        confirm: 'Open',
        onPressed: () {
          _launch(image.article?.url, "rip_click_article");
        },
      );
    } else if (image.instagram != null) {
      MunchDialog.showConfirm(
        context,
        content: 'Open Instagram?',
        cancel: 'Cancel',
        confirm: 'Open',
        onPressed: () {
          _launch(image.instagram?.link, "rip_click_image");
        },
      );
    }
  }
}
