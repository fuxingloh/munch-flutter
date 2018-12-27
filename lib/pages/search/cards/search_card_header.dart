import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/texts.dart';

class SearchCardHeader extends SearchCardWidget {
  SearchCardHeader(SearchCard card) : super(card, margin: SearchCardWidget.edge(bottom: 0));

  @override
  Widget buildCard(BuildContext context) {
    // TODO: implement buildCard
    return Text(
      card['title'] ?? "",
      style: MTextStyle.h2,
    );
  }

  @override
  void onTap(BuildContext context) {}
}