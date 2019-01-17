import 'package:flutter/material.dart';
import 'package:munch_app/pages/search/map/search_map_card_place.dart';
import 'package:munch_app/pages/search/map/search_map_manager.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/elevations.dart';

class SearchMapBottomList extends StatelessWidget {
  static const double fraction = 1 / 1.75;

  final PageController controller;
  final List<MapPlace> mapPlaces;
  final bool more;

  final int focused;

  const SearchMapBottomList({
    Key key,
    @required this.controller,
    @required this.mapPlaces,
    @required this.more,
    @required this.focused,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      final double itemWidth = (constraints.maxWidth) * fraction;

      return Container(
        height: 224,
        decoration: const BoxDecoration(
          color: MunchColors.white,
          boxShadow: elevation2,
        ),
        child: ListView.custom(
          scrollDirection: Axis.horizontal,
          controller: controller,
          physics: const PageScrollPhysics(),
          padding:
              const EdgeInsets.only(top: 24, bottom: 24, left: 12, right: 12),
          itemExtent: itemWidth,
          childrenDelegate: SliverChildBuilderDelegate(
            (context, i) {
              if (mapPlaces.length == i) {
                return _MapLoaderIndicator(loading: more);
              }

              return MapPlaceCard(
                mapPlace: mapPlaces[i],
                focused: focused == i,
              );
            },
            childCount: mapPlaces.length + 1,
          ),
        ),
      );
    });
  }
}

class _MapLoaderIndicator extends StatelessWidget {
  const _MapLoaderIndicator({Key key, @required this.loading})
      : super(key: key);

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Center(
        child: loading
            ? SizedBox(
                height: 48,
                width: 48,
                child: const CircularProgressIndicator(
                  backgroundColor: MunchColors.secondary500,
                ),
              )
            : null,
      ),
    );
  }
}
