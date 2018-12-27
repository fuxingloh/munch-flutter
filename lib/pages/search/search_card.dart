import 'package:flutter/widgets.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/search/cards/search_card_header.dart';
import 'package:munch_app/pages/search/cards/search_card_place.dart';

export 'package:flutter/widgets.dart';

class SearchCardDelegator {
  Widget delegate(SearchCard card) {
    switch (card.cardId) {
      case "Place_2018-12-29":
        return SearchCardPlace(card);

      case "Header_2018-11-29":
        return SearchCardHeader(card);
    }

    return Container(
      child: Text(card.cardId),
      padding: EdgeInsets.all(24),
    );
  }

//        register(SearchStaticTopCard.self)
//        register(SearchStaticNoResultCard.self)
//        register(SearchStaticLoadingCard.self)
//        register(SearchStaticErrorCard.self)
//        register(SearchStaticUnsupportedCard.self)
//        register(SearchShimmerPlaceCard.self)
//
//        register(SearchNoLocationCard.self)
//        register(SearchNoResultCard.self)
//
//        register(SearchCardCollectionHeader.self)
//
//        register(SearchCardHomeDTJE.self)
//
//        register(SearchHomeTabCard.self)
//        register(SearchHomeNearbyCard.self)
//        register(SearchCardHomeRecentPlace.self)
//        register(SearchCardHomePopularPlace.self)
//        register(SearchCardHomeAwardCollection.self)
//
//        register(SearchCardLocationBanner.self)
//        register(SearchCardLocationArea.self)
//
//        register(SearchCardBetweenHeader.self)
//
//        register(SearchHeaderCard.self)
//        register(SearchPlaceCard.self)
//
//        register(SearchAreaClusterListCard.self)
//        register(SearchAreaClusterHeaderCard.self)
//        register(SearchTagSuggestion.self)
}

abstract class SearchCardWidget extends StatelessWidget {
  static EdgeInsets edge({
    double left = 24,
    double right = 24,
    double top = 18,
    double bottom = 18,
  }) {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  SearchCardWidget(this.card,
      {this.margin = const EdgeInsets.fromLTRB(24, 18, 24, 18)})
      : super(key: Key('${card.cardId}-${card.uniqueId}'));

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
  void onTap(BuildContext context);

  @protected
  Widget buildCard(BuildContext context);
}
