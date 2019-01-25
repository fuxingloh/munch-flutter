import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/munch.dart';
import 'package:url_launcher/url_launcher.dart';

class RIPGalleryHeaderCard extends RIPCardWidget {
  RIPGalleryHeaderCard(PlaceData data) : super(data, margin: const RIPCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text('${data.place.name} Images', style: MTextStyle.h2),
        )
      ],
    );
  }

  static bool isAvailable(PlaceData data) {
    return data.images.isNotEmpty;
  }
}

class RIPGalleryImageCard extends StatelessWidget {
  final PlaceImage image;
  final VoidCallback onPressed;

  const RIPGalleryImageCard({Key key, this.image, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 24 - 24 - 16) / 2;

    ImageSize max = image.sizes.reduce((a, b) {
      return a.width.compareTo(b.width) >= 0 ? a : b;
    });

    return GestureDetector(
      onTap: onPressed,
      child: AspectRatio(
        aspectRatio: max.width.toDouble() / max.height.toDouble(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: ShimmerSizeImage(
            minWidth: width,
            sizes: image.sizes,
          ),
        ),
      ),
    );
  }
}

class RIPGalleryFooterCard extends RIPCardWidget {
  const RIPGalleryFooterCard({this.loading = false}) : super(null);

  final bool loading;

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    if (loading) {
      return Center(
        child: SpinKitThreeBounce(
          color: MunchColors.secondary500,
          size: 24.0,
        ),
      );
    } else {
      return RIPGalleryConnectCard();
    }
  }
}

class RIPGalleryConnectCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: MunchColors.saltpan100,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text("Join as Partner, show your images.", style: MTextStyle.h5),
          ),
          MunchButton.text("Connect", onPressed: () {
            _launch('https://partner.munch.app/instagram');
          }, style: MunchButtonStyle.secondaryOutline)
        ],
      ),
    );
  }

  void _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
