import 'package:flutter/widgets.dart';
import 'package:munch_app/api/places_api.dart';
import 'package:munch_app/pages/places/cards/rip_card_article.dart';

import 'package:munch_app/pages/places/cards/rip_card_banner.dart';
import 'package:munch_app/pages/places/cards/rip_card_loading.dart';
import 'package:munch_app/pages/places/cards/rip_card_location.dart';
import 'package:munch_app/pages/places/cards/rip_card_name_tag.dart';

export 'package:flutter/widgets.dart';
export 'package:munch_app/api/places_api.dart';
export 'package:munch_app/styles/texts.dart';
export 'package:munch_app/styles/colors.dart';

class RIPCardDelegator {
  static List<RIPCardWidget> delegate(PlaceData data) {
    if (data == null) {
      return const [RIPCardLoadingBanner(), RIPCardLoadingName()];
    }

    List<RIPCardWidget> widgets = [];
    widgets.add(RIPCardBanner(data));

    if (RIPCardClosed.isAvailable(data)) widgets.add(RIPCardClosed(data));
//        appendTo(type: RIPCardPreference.self)
    widgets.add(RIPCardNameTag(data));

    widgets.add(RIPCardLocation(data));
//        appendTo(type: RIPSuggestEditCard.self)

    if (RIPCardArticle.isAvailable(data)) widgets.add(RIPCardArticle(data));
//        appendTo(type: RIPGalleryHeaderCard.self)
    return widgets;
  }

//        appendTo(type: RIPHourCard.self)
//        appendTo(type: RIPPriceCard.self)
//        appendTo(type: RIPPhoneCard.self)
//        appendTo(type: RIPWebsiteCard.self)
//        appendTo(type: RIPAboutFirstDividerCard.self)
//
//        appendTo(type: RIPDescriptionCard.self)
//        appendTo(type: RIPAwardCard.self)
//        appendTo(type: RIPMenuWebsiteCard.self)
//        appendTo(type: RIPAboutSecondDividerCard.self)


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
  const RIPCardWidget(
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
