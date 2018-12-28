import 'package:flutter/widgets.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/search/cards/search_card_header.dart';
import 'package:munch_app/pages/search/cards/search_card_local.dart';
import 'package:munch_app/pages/search/cards/search_card_place.dart';

export 'package:flutter/widgets.dart';
export 'package:munch_app/api/search_api.dart';

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

    }

    debugPrint('Required Card ${card.cardId} Not Found.');

    return Container(
      child: Text(card.cardId),
      padding: EdgeInsets.all(24),
    );
  }

//        register(SearchShimmerPlaceCard.self)

//        register(SearchNoLocationCard.self)

//        register(SearchCardCollectionHeader.self)

//        register(SearchCardHomeDTJE.self)

//        register(SearchHomeTabCard.self)
//        register(SearchHomeNearbyCard.self)
//        register(SearchCardHomeRecentPlace.self)
//        register(SearchCardHomePopularPlace.self)
//        register(SearchCardHomeAwardCollection.self)

//        register(SearchCardLocationBanner.self)
//        register(SearchCardLocationArea.self)

//        register(SearchAreaClusterListCard.self)
//        register(SearchAreaClusterHeaderCard.self)
//        register(SearchTagSuggestion.self)


// TODO Later
//        register(SearchCardBetweenHeader.self)
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
