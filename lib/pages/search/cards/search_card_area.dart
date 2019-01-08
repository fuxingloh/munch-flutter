// AreaClusterList_2018-06-21

import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchCardAreaClusterList extends SearchCardWidget {
  final List<Area> _areas;

  SearchCardAreaClusterList(SearchCard card)
      : _areas = Area.fromJsonList(card['areas']),
        super(
          card,
          margin: SearchCardInsets.only(left: 0, right: 0),
        );

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24, bottom: 18),
          child: Text("Discover Locations", style: MTextStyle.h2),
        ),
        Container(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 24, right: 24),
            itemBuilder: (context, i) {
              return _SearchCardAreaCell(area: _areas[i]);
            },
            separatorBuilder: (c, i) => SizedBox(width: 18),
            itemCount: _areas.length,
          ),
        ),
      ],
    );
  }
}

class _SearchCardAreaCell extends StatelessWidget {
  const _SearchCardAreaCell({Key key, this.area}) : super(key: key);

  final Area area;

  @override
  Widget build(BuildContext context) {
    List<ImageSize> sizes = area.images.isNotEmpty ? area.images[0].sizes : [];

    var container = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: MunchColors.black15, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2), topRight: Radius.circular(2)),
              child: ShimmerSizeImage(sizes: sizes),
            ),
          ),
          Container(
            height: 40,
            padding: EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
            child: Text(
              area.name,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: MunchColors.black75,
              ),
            ),
          ),
        ],
      ),
    );

    return SizedBox(
      height: 110,
      width: 120,
      child: GestureDetector(
        onTap: () => onPressed(context),
        child: container,
      ),
    );
  }

  void onPressed(BuildContext context) {
    var query = SearchQuery.search();
    query.filter.location.type = SearchFilterLocationType.Where;
    query.filter.location.areas = [area];
    SearchPage.state.push(query);
  }
}

class SearchCardAreaClusterHeader extends SearchCardWidget {
  SearchCardAreaClusterHeader(SearchCard card)
      : area = Area.fromJson(card['area']),
        super(card);

  final Area area;

  @override
  Widget buildCard(BuildContext context) {
    List<Widget> children = [Text(area.name, style: MTextStyle.h2)];

    if (area.images.isNotEmpty && area.images[0].sizes.isNotEmpty) {
      children.add(
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: AspectRatio(
            aspectRatio: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: ShimmerSizeImage(sizes: area.images[0].sizes),
            ),
          ),
        ),
      );
    }

    children.add(Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("${area?.counts?.total} food spots", style: MTextStyle.h5),
          Text(area?.location?.address ?? "", style: MTextStyle.h5),
        ],
      ),
    ));

    if (area.description != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(area.description, maxLines: 4),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
