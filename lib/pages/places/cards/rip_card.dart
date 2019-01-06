import 'package:flutter/widgets.dart';
import 'package:munch_app/api/places_api.dart';
import 'package:munch_app/pages/places/cards/rip_card_about.dart';
import 'package:munch_app/pages/places/cards/rip_card_article.dart';
import 'package:munch_app/pages/places/cards/rip_card_award.dart';

import 'package:munch_app/pages/places/cards/rip_card_banner.dart';
import 'package:munch_app/pages/places/cards/rip_card_gallery.dart';
import 'package:munch_app/pages/places/cards/rip_card_hour.dart';
import 'package:munch_app/pages/places/cards/rip_card_loading.dart';
import 'package:munch_app/pages/places/cards/rip_card_location.dart';
import 'package:munch_app/pages/places/cards/rip_card_menu.dart';
import 'package:munch_app/pages/places/cards/rip_card_name_tag.dart';

export 'package:flutter/widgets.dart';
export 'package:munch_app/api/places_api.dart';
export 'package:munch_app/styles/texts.dart';
export 'package:munch_app/styles/colors.dart';

class RIPCardDelegator {
  static List<RIPCardWidget> get loading {
    return const [RIPCardLoadingBanner(), RIPCardLoadingName()];
  }

  static List<RIPCardWidget> delegate(PlaceData data) {
    List<RIPCardWidget> widgets = [];
    widgets.add(RIPCardBanner(data));

    if (RIPCardClosed.isAvailable(data)) widgets.add(RIPCardClosed(data));
//        appendTo(type: RIPCardPreference.self)
    widgets.add(RIPCardNameTag(data));


    if (RIPCardHour.isAvailable(data)) widgets.add(RIPCardHour(data));
    if (RIPCardPrice.isAvailable(data)) widgets.add(RIPCardPrice(data));
    if (RIPCardPhone.isAvailable(data)) widgets.add(RIPCardPhone(data));
    if (RIPCardWebsite.isAvailable(data)) widgets.add(RIPCardWebsite(data));
    if (RIPCardAboutDivider1.isAvailable(data)) widgets.add(RIPCardAboutDivider1(data));

    if (RIPCardDescription.isAvailable(data)) widgets.add(RIPCardDescription(data));
    if (RIPCardAward.isAvailable(data)) widgets.add(RIPCardAward(data));
    if (RIPCardMenuWebsite.isAvailable(data)) widgets.add(RIPCardMenuWebsite(data));
    if (RIPCardAboutDivider2.isAvailable(data)) widgets.add(RIPCardAboutDivider2(data));


    widgets.add(RIPCardLocation(data));
//        appendTo(type: RIPSuggestEditCard.self)

    if (RIPCardArticle.isAvailable(data)) widgets.add(RIPCardArticle(data));
    if (RIPCardGalleryHeader.isAvailable(data))
      widgets.add(RIPCardGalleryHeader(data));
    return widgets;
  }
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
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context, data),
      child: Container(margin: margin, child: buildCard(context, data)),
    );
  }

  @protected
  void onTap(BuildContext context, PlaceData data) {}

  @protected
  Widget buildCard(BuildContext context, PlaceData data);
}
