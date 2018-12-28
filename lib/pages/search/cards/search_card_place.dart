import 'package:flutter/cupertino.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/places/place_card.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchCardPlace extends SearchCardWidget {
  SearchCardPlace(SearchCard card) : super(card);

  @override
  Widget buildCard(BuildContext context) {
    final Place place = Place.fromJson(card['place']);
    return PlaceCard(place: place);
  }
}
