import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/api/collection_api.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';

class SearchCardHomeAwardCollection extends SearchCardWidget {
  SearchCardHomeAwardCollection(SearchCard card)
      : _collections = UserPlaceCollection.fromJsonList(card['collections']),
        super(card, margin: const SearchCardInsets.only(left: 0, right: 0));

  final List<UserPlaceCollection> _collections;

  @override
  Widget buildCard(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48) * 0.6;
    var listView = Container(
      height: width,
      margin: EdgeInsets.only(top: 24, bottom: 24),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 24, right: 24),
        itemBuilder: (context, i) {
          return Container(
            width: width,
            height: width,
            child: GestureDetector(
              onTap: () => onCollection(_collections[i]),
              child: _AwardCollectionCell(collection: _collections[i]),
            ),
          );
        },
        itemCount: _collections.length,
        separatorBuilder: (c, i) => SizedBox(width: 24),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text("Award Winning Places", style: MTextStyle.h2),
        ),
        const Padding(
          padding: const EdgeInsets.only(top: 4, left: 24, right: 24),
          child: Text(
              "If trophies were edible, you'd have em' at these joints.",
              style: MTextStyle.h6),
        ),
        listView
      ],
    );
  }

  void onCollection(UserPlaceCollection collection) {
    var query = SearchQuery.collection(
        SearchCollection(collection.name, collection.collectionId));
    SearchPage.state.push(query);
  }
}

class _AwardCollectionCell extends StatelessWidget {
  const _AwardCollectionCell({Key key, this.collection}) : super(key: key);

  final UserPlaceCollection collection;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48) * 0.6;

    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ShimmerSizeImage(
                sizes: collection.image?.sizes,
                minWidth: width,
                minHeight: width),
          ),
          Container(
            color: MunchColors.black50,
            padding: EdgeInsets.only(left: 8, right: 8),
            alignment: Alignment.center,
            child: Text(
              collection.name,
              style: MTextStyle.h3.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
