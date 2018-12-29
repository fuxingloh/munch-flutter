import 'package:munch_app/api/collection_api.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchCardCollectionHeader extends SearchCardWidget {
  final UserPlaceCollection _collection;

  SearchCardCollectionHeader(SearchCard card)
      : _collection = UserPlaceCollection.fromJson(card['collection']),
        super(card);

  @override
  Widget buildCard(BuildContext context) {
    List<Widget> children = [Text(_collection.name, style: MTextStyle.h2)];

    if (_collection.description != null) {
      children.add(Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(_collection.description, style: MTextStyle.h6),
      ));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
  }
}