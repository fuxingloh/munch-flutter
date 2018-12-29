import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/search/cards/search_card_place_collection.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/texts.dart';

class SearchCardHomeRecentPlace extends SearchCardWidget {
  final List<Place> _places;

  SearchCardHomeRecentPlace(SearchCard card)
      :_places = Place.fromJsonList(card['places']),
        super(card,
          margin: SearchCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Text("Your Recent Places", style: MTextStyle.h2),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4, left: 24, right: 24),
          child: Text("Don't worry, we won't tell anybody.",
              style: MTextStyle.h6),
        ),
        Container(
          margin: EdgeInsets.only(top: 24, bottom: 24),
          child: SearchCardPlaceCollection(places: _places),
        ),
      ],
    );
  }
}