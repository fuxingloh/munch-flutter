import 'package:flutter/cupertino.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/places/place_card.dart';
import 'package:munch_app/pages/places/rip_page.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchCardPlace extends SearchCardWidget {
  final Place place;

  SearchCardPlace(SearchCard card)
      : place = Place.fromJson(card['place']),
        super(card);

  @override
  Widget buildCard(BuildContext context) {
    return PlaceCard(place: place);
  }

  @override
  void onTap(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (c) => RIPPage(place: place)),
    );
  }
}