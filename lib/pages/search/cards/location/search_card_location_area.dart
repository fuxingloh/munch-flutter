import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/cards/search_card_place_collection.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchCardLocationArea extends SearchCardWidget {
  SearchCardLocationArea(SearchCard card)
      : _area = Area.fromJson(card['area']),
        _places = Place.fromJsonList(card['places']),
        super(card,
            margin: SearchCardInsets.only(bottom: 36, left: 0, right: 0));

  final Area _area;
  final List<Place> _places;

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Text("Discover ${_area.name}", style: MTextStyle.h2),
        ),
        Container(
          margin: EdgeInsets.only(top: 24, bottom: 24),
          child: SearchCardPlaceCollection(places: _places),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: MunchButton.text("Show all places in ${_area.name}",
              onPressed: () => onPressed(context), style: MunchButtonStyle.secondaryOutline),
        ),
      ],
    );
  }

  void onPressed(BuildContext context) {
    UserSearchPreference.get().then((pref) {
      var query = SearchQuery.search(pref);
      query.filter.location.type = SearchFilterLocationType.Where;
      query.filter.location.areas = [_area];
      SearchPage.state.push(query);
    }, onError: (error) {
      MunchDialog.showError(context, error);
    });
  }
}