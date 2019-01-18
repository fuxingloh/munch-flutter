import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:munch_app/utils/munch_location.dart';

class SearchCardHomeNearby extends SearchCardWidget {
  SearchCardHomeNearby(SearchCard card) : super(card);

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(MunchColors.black40, BlendMode.srcOver),
              image:
                  AssetImage('assets/img/search_card_home_nearby_banner.jpg'),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32, top: 8),
                  child: Text(
                    "Explore places around you",
                    style: MTextStyle.h4.copyWith(color: MunchColors.white),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: MunchButton.text(
                  "Discover Nearby",
                  onPressed: () => onPressed(context).catchError((error) {
                        MunchDialog.showError(context, error);
                      }),
                  style: MunchButtonStyle.secondaryOutline,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Future onPressed(BuildContext context) async {
    var latLng = await MunchLocation.instance.request(force: true, permission: true);
    if (latLng == null) return;

    var query = SearchQuery.search();
    query.filter.location.type = SearchFilterLocationType.Nearby;
    SearchPage.state.push(query);
  }
}
