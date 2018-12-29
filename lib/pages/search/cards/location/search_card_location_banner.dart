import 'package:flutter/material.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchCardLocationBanner extends SearchCardWidget {
  SearchCardLocationBanner(SearchCard card)
      : super(card, margin: SearchCardInsets.only(left: 0, right: 0, top: 0));

  @override
  Widget buildCard(BuildContext context) {
    var image = Positioned.fill(
        child: Image.asset(
      'assets/img/search_card_home_location_banner.jpg',
      fit: BoxFit.cover,
    ));
    return Container(
      height: 264,
      child: Stack(
        children: <Widget>[
          image,
          Container(
            color: MunchColors.black50,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
            ),
          )
        ],
      ),
    );
  }

  void onLocation(BuildContext context) {
//        let controller = FilterLocationSearchController(searchQuery: SearchQuery()) { query in
//            if let query = query {
//                self.controller.push(searchQuery: query)
//            }
//        }
//        self.controller.present(controller, animated: true)
  }
}