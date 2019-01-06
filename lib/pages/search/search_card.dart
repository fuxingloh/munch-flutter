import 'package:flutter/widgets.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/search/cards/collection/search_card_collection.dart';
import 'package:munch_app/pages/search/cards/home/search_card_home_award_collection.dart';
import 'package:munch_app/pages/search/cards/home/search_card_home_dtje.dart';
import 'package:munch_app/pages/search/cards/home/search_card_home_nearby.dart';
import 'package:munch_app/pages/search/cards/home/search_card_home_popular_place.dart';
import 'package:munch_app/pages/search/cards/home/search_card_home_recent_place.dart';
import 'package:munch_app/pages/search/cards/home/search_card_home_tab.dart';
import 'package:munch_app/pages/search/cards/location/search_card_location_area.dart';
import 'package:munch_app/pages/search/cards/location/search_card_location_banner.dart';
import 'package:munch_app/pages/search/cards/search_card_area.dart';
import 'package:munch_app/pages/search/cards/search_card_header.dart';
import 'package:munch_app/pages/search/cards/search_card_injected.dart';
import 'package:munch_app/pages/search/cards/search_card_local.dart';
import 'package:munch_app/pages/search/cards/search_card_place.dart';
import 'package:munch_app/pages/search/cards/search_card_tag.dart';

export 'package:flutter/widgets.dart';
export 'package:munch_app/pages/search/search_page.dart';
export 'package:munch_app/api/search_api.dart';
export 'package:munch_app/styles/texts.dart';
export 'package:munch_app/styles/buttons.dart';
export 'package:munch_app/styles/colors.dart';

class SearchCardDelegator {
  Widget delegate(SearchCard card) {
    switch (card.cardId) {
      case "Header_2018-11-29":
        return SearchCardHeader(card);

      case "Place_2018-12-29":
        return SearchCardPlace(card);

      case "SearchCardUnsupported":
        return SearchCardUnsupported(card);

      case "SearchCardError":
        return SearchCardError(card);

      case "SearchCardNoResult":
      case "NoResult_2017-12-08":
        return SearchCardNoResult(card);

      case "SearchCardShimmer":
        return SearchCardShimmer(card);

      case "NoLocation_2017-10-20":
        return SearchCardNoLocation(card);

      case "CollectionHeader_2018-12-11":
        return SearchCardCollectionHeader(card);

      case "HomeTab_2018-11-29":
        return SearchCardHomeTab(card);

      case "HomeNearby_2018-12-10":
        return SearchCardHomeNearby(card);

      case "HomePopularPlace_2018-12-10":
        return SearchCardHomePopularPlace(card);

      case "HomeDTJE_2018-12-17":
        return SearchCardHomeDTJE(card);

      case "HomeRecentPlace_2018-12-10":
        return SearchCardHomeRecentPlace(card);

      case "HomeAwardCollection_2018-12-10":
        return SearchCardHomeAwardCollection(card);

      case "LocationBanner_2018-12-10":
        return SearchCardLocationBanner(card);

      case "LocationArea_2018-12-10":
        return SearchCardLocationArea(card);

      case "AreaClusterList_2018-06-21":
        return SearchCardAreaClusterList(card);

      case "AreaClusterHeader_2018-06-21":
        return SearchCardAreaClusterHeader(card);

      case "SuggestedTag_2018-05-11":
        return SearchCardTagSuggestion(card);

//        register(SearchCardBetweenHeader.self)
    }

    debugPrint('Required Card ${card.cardId} Not Found.');
    return Container();
  }
}

class SearchCardInsets extends EdgeInsets {
  const SearchCardInsets.only({
    double left = 24,
    double right = 24,
    double top = 18,
    double bottom = 18,
  }) : super.fromLTRB(left, top, right, bottom);
}

abstract class SearchCardWidget extends StatelessWidget {
  SearchCardWidget(
    this.card, {
    this.margin = const SearchCardInsets.only(),
  }) : super(key: Key('${card.cardId}-${card.uniqueId}'));

  final SearchCard card;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(margin: margin, child: buildCard(context)),
    );
  }

  @protected
  void onTap(BuildContext context) {}

  @protected
  Widget buildCard(BuildContext context);
}
