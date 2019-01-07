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
          child: Text("Discover Nearby", style: MTextStyle.h2),
          margin: EdgeInsets.only(bottom: 18),
        ),
        AspectRatio(
          aspectRatio: 1 / 0.4,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(MunchColors.black50, BlendMode.srcOver),
                image:
                    AssetImage('assets/img/search_card_home_nearby_banner.jpg'),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    "Discover Places Near You",
                    style: MTextStyle.h4.copyWith(color: MunchColors.white),
                  ),
                ),
                MunchButton.text(
                  "Discover",
                  onPressed: () => onPressed(context).catchError((error) {
                        MunchDialog.showError(context, error);
                      }),
                  style: MunchButtonStyle.secondaryOutline,
                )
              ],
            ),
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
