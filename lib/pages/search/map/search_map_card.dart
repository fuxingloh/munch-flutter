import 'package:flutter/material.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/places/place_card.dart';

class SearchCardMapDelegator {
  static Widget delegate(SearchCard card) {
    switch(card.cardId) {
      case "Place_2018-12-29":
        return SearchMapCardPlace(card);
    }

    debugPrint('Required Card ${card.cardId} Not Found.');
    return Container();
  }
}

class SearchCardMapInsets extends EdgeInsets {
  const SearchCardMapInsets.only({
    double left = 12,
    double right = 12,
    double top = 12,
    double bottom = 12,
  }) : super.fromLTRB(left, top, right, bottom);
}

abstract class SearchMapCard extends StatelessWidget {
  SearchMapCard(
      this.card, {
        this.margin = const SearchCardMapInsets.only(),
      }) : super(key: Key('${card.cardId}-${card.uniqueId}'));

  final SearchCard card;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context),
      child: Container(margin: margin, child: buildCard(context)),
    );
  }

  @protected
  void onTap(BuildContext context) {}

  @protected
  Widget buildCard(BuildContext context);
}

class SearchMapCardPlace extends SearchMapCard {
  SearchMapCardPlace(SearchCard card) : super(card);

  @override
  Widget buildCard(BuildContext context) {
    final Place place = Place.fromJson(card['place']);
    return PlaceCard(place: place);
  }
}
