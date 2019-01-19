import 'package:flutter/material.dart';
import 'package:munch_app/pages/filter/filter_area_page.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchCardLocationBanner extends SearchCardWidget {
  SearchCardLocationBanner(SearchCard card)
      : super(card, margin: SearchCardInsets.only(left: 0, right: 0, top: 0));

  @override
  Widget buildCard(BuildContext context) {
    var image = Image.asset(
      'assets/img/search_card_home_location_banner.jpg',
      fit: BoxFit.cover,
    );
    var overlay = Container(
      color: MunchColors.black50,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Discover by Neighbourhood",
            style: MTextStyle.h1.copyWith(color: MunchColors.white),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Enter a location and we’ll tell you what’s delicious around.",
                style: MTextStyle.h5.copyWith(color: MunchColors.white),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: MunchButton.text(
              "Enter Location",
              style: MunchButtonStyle.secondaryOutline,
              onPressed: () => onLocation(context),
            ),
          )
        ],
      ),
    );

    return Container(
      constraints: BoxConstraints.loose(Size.fromHeight(264)),
      child: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: [
          Positioned(top: -18, left: 0, right: 0, height: 264, child: image),
          Positioned(top: -18, left: 0, right: 0, height: 264, child: overlay)
        ],
      ),
    );
  }

  void onLocation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterAreaPage(),
      ),
    ).then((area) {
      if (area == null) return;

      var query = SearchQuery.search();
      query.filter.location.type = SearchFilterLocationType.Where;
      query.filter.location.areas = [area];
      SearchPage.state.push(query);
    });
  }
}
