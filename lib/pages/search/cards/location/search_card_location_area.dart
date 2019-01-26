import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/search/cards/search_card_place_collection.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchCardLocationArea extends SearchCardWidget {
  SearchCardLocationArea(SearchCard card)
      : _area = Area.fromJson(card['area']),
        _places = Place.fromJsonList(card['places']),
        super(card, margin: const SearchCardInsets.only(bottom: 36, left: 0, right: 0));

  final Area _area;
  final List<Place> _places;

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text("Discover ${_area.name}", style: MTextStyle.h2),
        ),
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 24),
          child: SearchCardPlaceCollection(places: _places),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: MunchButton.text(
            "Show all places in ${_area.name}",
            onPressed: () => onPressed(context),
            style: MunchButtonStyle.secondaryOutline,
          ),
        ),
      ],
    );
  }

  void onPressed(BuildContext context) {
    var query = SearchQuery.search();
    query.filter.location.type = SearchFilterLocationType.Where;
    query.filter.location.areas = [_area];
    SearchPage.state.push(query);
  }
}
