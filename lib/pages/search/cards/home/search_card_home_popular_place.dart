import 'package:munch_app/api/collection_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/places/place_card.dart';
import 'package:munch_app/pages/search/cards/search_card_place_collection.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/munch_horizontal_snap.dart';
import 'package:munch_app/styles/texts.dart';

class SearchCardHomePopularPlace extends SearchCardWidget {
  final UserPlaceCollection _collection;
  final List<Place> _places;

  SearchCardHomePopularPlace(SearchCard card)
      : _collection = UserPlaceCollection.fromJson(card['collection']),
        _places = Place.fromJsonList(card['places']),
        super(card, margin: const SearchCardInsets.only(bottom: 36, left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Text("Popular Places in Singapore", style: MTextStyle.h2),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4, left: 24, right: 24),
          child: Text("Where the cool kids and food geeks go.", style: MTextStyle.h6),
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
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: MunchButton.text(
            "Show all popular places",
            onPressed: onPressed,
            style: MunchButtonStyle.secondaryOutline,
          ),
        ),
      ],
    );
  }

  void onPressed() {
    var query = SearchQuery.collection(SearchCollection(_collection.name, _collection.collectionId));
    SearchPage.state.push(query);
  }
}