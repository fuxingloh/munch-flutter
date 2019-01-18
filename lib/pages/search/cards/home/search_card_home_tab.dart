import 'package:flutter/material.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/pages/filter/filter_between_page.dart';
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
      onTap: () => _onLogin(context),
      child: const Padding(
        padding: const EdgeInsets.only(top: 4, left: 24, right: 24),
        child: Text("(Not Samantha? Create an account here.)",
            style: MTextStyle.h6),
      ),
    ));

    children.add(Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: <Widget>[
          _buildTab("EatBetween", 'search_card_home_tab_between.jpg',
              () => _onBetween(context)),
          _buildTab("Neighbourhoods", 'search_card_home_tab_location.jpg',
              () => _onLocation(context)),
        ],
      ),
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  void _onLogin(BuildContext context) {
    Authentication.instance.requireAuthentication(context).then((state) {
      if (state != AuthenticationState.loggedIn) {
        return;
      }

      SearchPage.state.reset();
    });
  }

  void _onLocation(BuildContext context) {
    SearchPage.state.push(SearchQuery.feature(SearchFeature.Location));
  }

  void _onBetween(BuildContext context) {
    final searchQuery = SearchPage.state.searchQuery;

    Future<SearchQuery> future = Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (c) => FilterBetweenPage(searchQuery: searchQuery),
    ));

    future.then((searchQuery) {
      if (searchQuery == null) return;

      SearchPage.state.push(searchQuery);
    });
  }
}
