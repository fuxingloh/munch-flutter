import 'package:munch_app/api/collection_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/search/cards/search_card_place_collection.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/texts.dart';

class SearchCardHomePopularPlace extends SearchCardWidget {
  final UserPlaceCollection _collection;
  final List<Place> _places;

  SearchCardHomePopularPlace(SearchCard card)
      : _collection = UserPlaceCollection.fromJson(card['collection']),
        _places = Place.fromJsonList(card['places']),
        super(card, margin: SearchCardInsets.only(bottom: 36, left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context) {
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
          child: SearchCardMiniPlaceList(places: _places),
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