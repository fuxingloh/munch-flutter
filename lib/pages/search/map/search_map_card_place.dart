import 'package:flutter/material.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/munch_tag_view.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/rip_page.dart';
import 'package:munch_app/pages/search/map/search_map_bottom.dart';
import 'package:munch_app/pages/search/map/search_map_manager.dart';
import 'package:munch_app/styles/munch.dart';

class MapPlaceCard extends StatefulWidget {
  const MapPlaceCard({
    Key key,
    this.mapPlace,
    this.focused = false,
  }) : super(key: key);

  final MapPlace mapPlace;
  final bool focused;

  @override
  _MapPlaceCardState createState() => _MapPlaceCardState();
}

class _MapPlaceCardState extends State<MapPlaceCard> {
  Place get place {
    return widget.mapPlace.place;
  }

  void onPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => RIPPage(place: place)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ImageSize> sizes =
        place.images.isNotEmpty ? place.images.first.sizes : [];

    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: ShimmerSizeImage(sizes: sizes, fit: BoxFit.cover),
                ),
                Container(
                  height: 4,
                  width: double.infinity,
                  color: widget.focused
                      ? MunchColors.primary500
                      : MunchColors.clear,
                )
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          alignment: Alignment.centerLeft,
          child: Text(
            place.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: MunchColors.black75,
            ),
            maxLines: 1,
          ),
        ),
        Container(
          height: 23,
          margin: const EdgeInsets.only(top: 6),
          alignment: Alignment.centerLeft,
          child: _MapPlaceCardTag(place: place),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: AspectRatio(
        aspectRatio: SearchMapBottomList.fraction,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: column,
          onTap: onPressed,
        ),
      ),
    );
  }
}

class _MapPlaceCardTag extends StatelessWidget {
  const _MapPlaceCardTag({Key key, this.place}) : super(key: key);

  final Place place;

  static const MunchTagStyle priceTagStyle = MunchTagStyle(
      backgroundColor: MunchColors.peach100,
      textStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: MunchColors.black85,
      ),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4));

  static const MunchTagStyle tagStyle = MunchTagStyle(
      textStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: MunchColors.black85,
      ),
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4));

  static const MunchTagData defaultEmpty = MunchTagData(
    'Restaurant',
    style: tagStyle,
  );

  @override
  Widget build(BuildContext context) {
    List<MunchTagData> list = [];

    if (place.price?.perPax != null) {
      list.add(MunchTagData("\$${place.price?.perPax}", style: priceTagStyle));
    }

    place.tags.forEach((tag) {
      if (tag.type == TagType.Timing) return;
      return list.add(MunchTagData(tag.name, style: tagStyle));
    });

    if (list.isEmpty) {
      list.add(defaultEmpty);
    }
    return MunchTagView(tags: list);
  }
}
