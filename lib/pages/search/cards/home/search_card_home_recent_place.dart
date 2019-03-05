import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/places/place_card.dart';
import 'package:munch_app/pages/search/cards/search_card_place_collection.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/munch_horizontal_snap.dart';
import 'package:munch_app/styles/texts.dart';

class SearchCardHomeRecentPlace extends SearchCardWidget {
  final List<Place> _places;

  SearchCardHomeRecentPlace(SearchCard card)
      : _places = Place.fromJsonList(card['places']),
        super(card, margin: SearchCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Text("Your Recent Places", style: MTextStyle.h2),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4, left: 24, right: 24),
          child: Text("Don't worry, we won't tell anybody.", style: MTextStyle.h6),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: MunchHorizontalSnap(
            itemWidth: width,
            sampleBuilder: (context) {
              return PlaceCard(place: _places[0]);
            },
            itemBuilder: (context, i) {
              return PlaceCard(place: _places[i]);
            },
            itemCount: _places.length,
            spacing: 16,
            padding: const EdgeInsets.only(left: 24, right: 24),
          ),
        ),
      ],
    );
  }
}
