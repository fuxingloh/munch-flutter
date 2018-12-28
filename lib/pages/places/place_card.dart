import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/munch_tag_view.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/rip_page.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/icons.dart';

MunchTagView _buildTag(Place place) {
  const MunchTagStyle priceTagStyle = MunchTagStyle(
    backgroundColor: MunchColors.peach100,
    textStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: MunchColors.black85,
    ),
  );
  const MunchTagStyle tagStyle = MunchTagStyle();
  const MunchTagData defaultEmpty = MunchTagData('Restaurant', style: tagStyle);

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

RichText _buildLocation(Place place) {
  const style = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: MunchColors.black75,
  );

  const period = TextSpan(
    text: "  •  ",
    style: TextStyle(color: MunchColors.black, fontWeight: FontWeight.w700),
  );

  const closing = TextSpan(
    text: "Closing Soon",
    style: TextStyle(color: MunchColors.close, fontWeight: FontWeight.w600),
  );

  const closed = TextSpan(
    text: "Closed Now",
    style: TextStyle(color: MunchColors.close, fontWeight: FontWeight.w600),
  );

  const opening = TextSpan(
    text: "Opening Soon",
    style: TextStyle(color: MunchColors.open, fontWeight: FontWeight.w600),
  );

  const open = TextSpan(
    text: "Open Now",
    style: TextStyle(color: MunchColors.open, fontWeight: FontWeight.w600),
  );

  List<TextSpan> children = [];

  switch (HourGrouped(hours: place.hours).isOpen()) {
    case HourOpen.open:
      children = [period, open];
      break;

    case HourOpen.opening:
      children = [period, opening];
      break;

    case HourOpen.closed:
      children = [period, closed];
      break;

    case HourOpen.closing:
      children = [period, closing];
      break;

    default:
      break;
  }

  return RichText(
    maxLines: 1,
    text: TextSpan(
      text: "${place.location.neighbourhood}",
      style: style,
      children: children,
    ),
  );
}

class PlaceHeartButton extends StatelessWidget {
  const PlaceHeartButton({Key key, @required this.placeId, this.onPressed})
      : super(key: key);

  final String placeId;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return const IconButton(
      onPressed: null,
      icon: Icon(MunchIcons.rip_heart, color: MunchColors.white),
      iconSize: 24,
      color: MunchColors.white,
      padding: EdgeInsets.all(8),
    );
  }
}

class PlaceCard extends StatefulWidget {
  const PlaceCard({Key key, @required this.place}) : super(key: key);

  final Place place;

  @override
  State<StatefulWidget> createState() => PlaceCardState(place);

  static double height(double width) {
    double height = width * 0.6;
    height += 28 + 12;
    height += 24 + 6;
    height += 19 + 8;
    return height.ceilToDouble();
  }
}

class PlaceCardState extends State<PlaceCard> {
  PlaceCardState(this.place);

  final Place place;

  @override
  Widget build(BuildContext context) {
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1 / 0.6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: ShimmerSizeImage(
                  sizes: place.images.first?.sizes,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              child: PlaceHeartButton(placeId: place.placeId),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          height: 28,
          alignment: Alignment.centerLeft,
          child: Text(
            place.name,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: MunchColors.black75,
            ),
            maxLines: 1,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          alignment: Alignment.centerLeft,
          height: 24,
          child: _buildTag(place),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          alignment: Alignment.centerLeft,
          height: 19,
          child: _buildLocation(place),
        ),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: column,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => RIPPage(place: place)),
        );
      },
    );
  }
}
