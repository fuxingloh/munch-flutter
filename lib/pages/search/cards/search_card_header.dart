import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/texts.dart';

class SearchCardHeader extends SearchCardWidget {
  static const insets = SearchCardInsets.only(bottom: 0);

  SearchCardHeader(SearchCard card) : super(card, margin: insets);

  @override
  Widget buildCard(BuildContext context) {
    return Text(
      card['title'] ?? "Header",
      style: MTextStyle.h2,
    );
  }

  static double height(BuildContext context, SearchCard card) {
    return insets.vertical + MTextStyle.h2.fontSize;
  }
}
