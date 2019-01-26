import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/munch_tag_view.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/rip_page.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:munch_app/utils/munch_location.dart';

MunchTagView _buildTag(Place place) {
  const MunchTagStyle priceTagStyle = MunchTagStyle(
    backgroundColor: MunchColors.peach100,
    textStyle: TextStyle(
      fontSize: 14,
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
    fontSize: 14,
    fontWeight: FontWeight.w400,
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

  var distance = MunchLocation.instance.distanceAsMetric(place.location.latLng);
  if (distance != null) {
    children.add(TextSpan(text: '$distance - '));
  }

  children.add(TextSpan(text: place.location.neighbourhood));

  switch (HourGrouped(hours: place.hours).isOpen()) {
    case HourOpen.open:
      children.addAll([period, open]);
      break;

    case HourOpen.opening:
      children.addAll([period, opening]);
      break;

    case HourOpen.closed:
      children.addAll([period, closed]);
      break;

    case HourOpen.closing:
      children.addAll([period, closing]);
      break;

    default:
      break;
  }

  return RichText(
    maxLines: 1,
    text: TextSpan(
      style: style,
      children: children,
    ),
  );
}

class PlaceHeartButton extends StatelessWidget {
  const PlaceHeartButton({Key key, @required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) {
      return Container();
    }

    return IconButton(
      onPressed: onPressed,
      icon: Icon(MunchIcons.rip_heart_filled, color: MunchColors.white),
      iconSize: 24,
      color: MunchColors.white,
      padding: EdgeInsets.all(8),
    );
  }
}

class PlaceCard extends StatefulWidget {
  const PlaceCard({
    Key key,
    @required this.place,
    this.onHeart,
  }) : super(key: key);

  final Place place;
  final VoidCallback onHeart;

  @override
  State<StatefulWidget> createState() => PlaceCardState();

  static double height(double width) {
    double height = width * 0.6;
    height += 28 + 12;
    height += 27 + 6;
    height += 19 + 8;
    return height;
  }
}

class PlaceCardState extends State<PlaceCard> {
  Place get place => widget.place;

  void onPressed() {
    RIPPage.push(context, place);
  }

  @override
  Widget build(BuildContext context) {
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1 / 0.6,
              child: _PlaceCardImage(place: place),
            ),
            Container(
              alignment: Alignment.topRight,
              child: PlaceHeartButton(onPressed: widget.onHeart),
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
              fontWeight: FontWeight.w600,
              color: MunchColors.black75,
            ),
            maxLines: 1,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          alignment: Alignment.centerLeft,
          height: 27,
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
      onTap: onPressed,
    );
  }
}

class _PlaceCardImage extends StatelessWidget {
  const _PlaceCardImage({Key key, this.place}) : super(key: key);

  final Place place;

  @override
  Widget build(BuildContext context) {
    List<ImageSize> sizes = place.images.isNotEmpty ? place.images.first.sizes : [];

    if (sizes.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: MunchColors.whisper100,
        ),
        padding: const EdgeInsets.all(8),
        alignment: Alignment.bottomRight,
        child: Text("No Image Available", style: MTextStyle.smallBold),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: ShimmerSizeImage(sizes: sizes, fit: BoxFit.cover),
    );
  }
}
