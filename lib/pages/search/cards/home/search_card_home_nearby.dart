import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/filter/filter_between_page.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:munch_app/utils/munch_location.dart';

class SearchCardHomeNearby extends SearchCardWidget {
  SearchCardHomeNearby(SearchCard card) : super(card, margin: const SearchCardInsets.only(top: 0));

  @override
  Widget buildCard(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: _SearchCardHomeSquare(
              icon: MunchIcons.filter_between,
              message: "Find the most ideal spot for everyone.",
              onPressed: () => onEatBetween(context),
            ),
          ),
          const SizedBox(width: 24, height: 1),
          Expanded(
            child: _SearchCardHomeSquare(
              icon: MunchIcons.filter_nearby,
              message: "Explore places around you.",
              onPressed: () => onNearby(context),
            ),
          )
        ],
      ),
    );
  }

  onNearby(BuildContext context) {
    Future future = MunchLocation.instance.request(force: true, permission: true).then((latLng) {
      if (latLng == null) return;

      SearchQuery query = SearchQuery.search();
      query.filter.location.type = SearchFilterLocationType.Nearby;
      SearchPage.state.push(query);
    });

    MunchDialog.showProgress(context, future: future, error: true);
  }

  onEatBetween(BuildContext context) {
    final searchQuery = SearchPage.state.searchQuery;
    Future<SearchQuery> future = FilterBetweenPage.push(context, searchQuery);
    future.then((searchQuery) {
      if (searchQuery == null) return;

      SearchPage.state.push(searchQuery);
    });
  }
}

class _SearchCardHomeSquare extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String message;

  const _SearchCardHomeSquare({
    Key key,
    @required this.onPressed,
    @required this.message,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: MunchColors.whisper200
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(message, style: MTextStyle.h5),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Icon(
                icon,
                size: 36,
              ),
            )
          ],
        ),
      ),
    );
  }
}
