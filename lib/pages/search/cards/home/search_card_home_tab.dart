import 'package:munch_app/pages/search/search_card.dart';

String _title() {
  String salutation() {
    var date = DateTime.now();
    var total = (date.hour * 60) + date.minute;

    if (total >= 300 && total < 720) {
      return "Good Morning";
    } else if (total >= 720 && total < 1020) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  String name() {
    // UserProfile.instance?.name ?? "Samantha"
    return "Samantha";
  }

  return "${salutation()}, ${name()}. Feeling hungry?";
}

class SearchCardHomeTab extends SearchCardWidget {
  SearchCardHomeTab(SearchCard card)
      : super(card, margin: SearchCardInsets.only(left: 0, right: 0));

  Widget _buildTab(String text, String image, VoidCallback onPressed) {
    var container = Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: MunchColors.black15, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              color: MunchColors.whisper200,
              child: Image(
                image: AssetImage('assets/img/$image'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            child: Text(text, maxLines: 1),
          ),
        ],
      ),
    );

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1 / 0.75,
        child: GestureDetector(
          onTap: onPressed,
          child: container,
        ),
      ),
    );
  }

  @override
  Widget buildCard(BuildContext context) {
    List<Widget> children = [
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Text(_title(), style: MTextStyle.h2),
      )
    ];

    children.add(GestureDetector(
      onTap: () {
//        Authentication.requireAuthentication(controller: self.controller) { state in
//            guard case .loggedIn = state else {
//                return
//            }
//            self.controller.reset()
//        }
      },
      child: const Padding(
        padding: EdgeInsets.only(top: 4, left: 24, right: 24),
        child: Text("(Not Samantha? Create an account here.)",
            style: MTextStyle.h6),
      ),
    ));

    children.add(Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildTab("EatBetween", 'search_card_home_tab_between.jpg', () {
            // TODO Eat Between
          }),
          _buildTab("Inspiration", 'search_card_home_tab_feed.jpg', () {
            // TODO Feed
          }),
          _buildTab("Neighbourhoods", 'search_card_home_tab_location.jpg', () {
            SearchPage.state.push(SearchQuery.feature(SearchFeature.Location));
          }),
        ],
      ),
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
