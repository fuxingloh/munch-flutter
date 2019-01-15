import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch_app/pages/search/map/search_map_card.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchMapBottomList extends StatelessWidget {
  final ScrollController controller;
  final List<SearchCard> cards;
  final bool more;

  const SearchMapBottomList({
    Key key,
    @required this.controller,
    @required this.cards,
    @required this.more,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(top: 24, bottom: 24, left: 12, right: 12),
      controller: controller,
      itemCount: cards.length + 1,
      itemBuilder: (context, i) {
        if (cards.length == i) {
          return _MapLoaderIndicator(loading: more);
        }
        return SearchCardMapDelegator.delegate(cards[i]);
      },
    );
  }
}

class _MapLoaderIndicator extends StatelessWidget {
  const _MapLoaderIndicator({Key key, @required this.loading})
      : super(key: key);

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: EdgeInsets.only(bottom: 48),
      alignment: Alignment.center,
      child: loading
          ? SpinKitThreeBounce(
              color: MunchColors.secondary500,
              size: 24.0,
            )
          : null,
    );
  }
}
