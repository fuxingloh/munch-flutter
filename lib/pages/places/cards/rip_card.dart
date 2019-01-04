import 'package:flutter/widgets.dart';
import 'package:munch_app/api/places_api.dart';
import 'package:munch_app/pages/places/cards/rip_card_article.dart';

import 'package:munch_app/pages/places/cards/rip_card_banner.dart';
import 'package:munch_app/pages/places/cards/rip_card_location.dart';
import 'package:munch_app/pages/places/cards/rip_card_name_tag.dart';

export 'package:flutter/widgets.dart';
export 'package:munch_app/api/places_api.dart';
export 'package:munch_app/styles/texts.dart';
export 'package:munch_app/styles/colors.dart';

class RIPCardDelegator {
  static List<RIPCardWidget> delegate(PlaceData data) {
    if (data == null) {
      // [RIPLoadingImageCard.self, RIPLoadingNameCard.self]
      return [];
    }

    List<RIPCardWidget> widgets = [];
    widgets.add(RIPCardBanner(data));

    if (RIPCardClosed.isAvailable(data)) widgets.add(RIPCardClosed(data));
    widgets.add(RIPCardNameTag(data));
    widgets.add(RIPCardLocation(data));

    if (RIPCardArticle.isAvailable(data)) widgets.add(RIPCardArticle(data));
    return widgets;
  }

//        collectionView.register(type: RIPLoadingImageCard.self)
//        collectionView.register(type: RIPLoadingNameCard.self)
//        collectionView.register(type: RIPLoadingGalleryCard.self)
//
//        collectionView.register(type: RIPImageBannerCard.self)
//        collectionView.register(type: RIPNameTagCard.self)
//        collectionView.register(type: RIPCardPreference.self)
//        collectionView.register(type: RIPCardClosed.self)
//
//        collectionView.register(type: RIPHourCard.self)
//        collectionView.register(type: RIPPriceCard.self)
//        collectionView.register(type: RIPPhoneCard.self)
//        collectionView.register(type: RIPMenuWebsiteCard.self)
//        collectionView.register(type: RIPAboutFirstDividerCard.self)
//
//        collectionView.register(type: RIPDescriptionCard.self)
//        collectionView.register(type: RIPAwardCard.self)
//        collectionView.register(type: RIPWebsiteCard.self)
//        collectionView.register(type: RIPAboutSecondDividerCard.self)
//
//        collectionView.register(type: RIPLocationCard.self)
//        collectionView.register(type: RIPSuggestEditCard.self)
//
//        collectionView.register(type: RIPArticleCard.self)
//
//        collectionView.register(type: RIPGalleryHeaderCard.self)
//        collectionView.register(type: RIPGalleryImageCard.self)
}

class RIPCardInsets extends EdgeInsets {
  const RIPCardInsets.only({
    double left = 24,
    double right = 24,
    double top = 12,
    double bottom = 12,
  }) : super.fromLTRB(left, top, right, bottom);
}

abstract class RIPCardWidget extends StatelessWidget {
  RIPCardWidget(
    this.data, {
    this.margin = const RIPCardInsets.only(),
  });

  final PlaceData data;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(margin: margin, child: buildCard(context, data)),
    );
  }

  @protected
  void onTap(BuildContext context) {}

  @protected
  Widget buildCard(BuildContext context, PlaceData data);
}
