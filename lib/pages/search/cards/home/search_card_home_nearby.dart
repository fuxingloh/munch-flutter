import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';

class SearchCardHomeNearby extends SearchCardWidget {
  SearchCardHomeNearby(SearchCard card) : super(card);

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(child: Text("Discover Nearby", style: MTextStyle.h2),
          margin: EdgeInsets.only(bottom: 18),),
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
                image: AssetImage('assets/img/search_card_home_nearby_banner.jpg'),
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
                MunchButton.text("Discover", onPressed: () => onPressed(context),
                  style: MunchButtonStyle.secondaryOutline,)
              ],
            ),
          ),
        )
      ],
    );
  }

  void onPressed(BuildContext context) {
    UserSearchPreference.get().then((pref) {
      var query = SearchQuery.search(pref);
      SearchPage.state.push(query);
    }, onError: (error) {
      MunchDialog.showError(context, error);
    });
  }
}
