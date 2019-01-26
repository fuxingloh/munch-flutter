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
