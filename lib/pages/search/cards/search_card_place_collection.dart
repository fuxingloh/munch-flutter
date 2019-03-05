import 'package:flutter/cupertino.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/places/place_card.dart';

class SearchCardPlaceCollection extends StatelessWidget {
  const SearchCardPlaceCollection({Key key, this.places}) : super(key: key);

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48) * 0.85;

    return Container(
      height: PlaceCard.height(width),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 24, right: 24),
        itemBuilder: (context, i) {
          return Container(
            width: width,
            child: PlaceCard(place: places[i]),
          );
        },
        itemCount: places.length,
        separatorBuilder: (c, i) => const SizedBox(width: 24),
      ),
    );
  }
}

class SearchCardMiniPlaceList extends StatelessWidget {
  final List<Place> places;

  const SearchCardMiniPlaceList({Key key, this.places}) : super(key: key);

  int get itemCount {
    if (places.length > 1) {
      return 2;
    }
    return places.length;
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 24 * 3) / 2;

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0,
          child: Container(
            width: width,
            child: MiniPlaceCard(place: places[0]),
          ),
        ),
        Positioned.fill(
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 24, right: 24),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              return Container(
                width: width,
                child: MiniPlaceCard(place: places[i]),
              );
            },
            separatorBuilder: (_, i) => SizedBox(width: 24),
            itemCount: itemCount,
          ),
        ),
      ],
    );
  }
}
