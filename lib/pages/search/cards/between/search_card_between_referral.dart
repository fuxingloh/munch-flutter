import 'package:flutter/material.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:share/share.dart';

class SearchCardBetweenReferral extends SearchCardWidget {
  SearchCardBetweenReferral(SearchCard card) : super(card);

  @override
  Widget buildCard(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MunchColors.primary500,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Share search results with your friends.", style: MTextStyle.h3.copyWith(color: MunchColors.white)),
          Container(
            margin: const EdgeInsets.only(top: 16),
            alignment: Alignment.centerRight,
            child: MunchButton.text(
              "SHARE",
              onPressed: () => onShare(context),
              style: MunchButtonStyle.primaryOutline,
            ),
          )
        ],
      ),
    );
  }

  void onShare(BuildContext context) {
    final qid = SearchPage.state.qid;
    MunchAnalytic.logSearchQueryShare(
      searchQuery: SearchPage.state.searchQuery,
      trigger: "search_card_between_referral",
    );
    Share.share("https://www.munch.app/search?qid=$qid&g=GB10");
  }

  static double height(BuildContext context, SearchCard card) {
    const insets = SearchCardInsets.only();
    return insets.vertical +
        24 +
        MTextStyle.h2.fontSize +
        16 +
        MTextStyle.regular.fontSize +
        24 +
        MunchButtonStyle.secondaryOutline.height +
        24;
  }
}
