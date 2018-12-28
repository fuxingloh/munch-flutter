import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/texts.dart';

class SearchCardHeader extends SearchCardWidget {
  SearchCardHeader(SearchCard card)
      : super(card, margin: SearchCardInsets.only(bottom: 0));

  @override
  Widget buildCard(BuildContext context) {
    return Text(
      card['title'] ?? "Header",
      style: MTextStyle.h2,
    );
  }
}
