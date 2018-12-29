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
              borderRadius: BorderRadius.circular(2),
              child: ShimmerSizeImage(sizes: sizes),
            ),
          ),
          Container(
            height: 40,
            padding: EdgeInsets.all(6),
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
        onTap: () => onPressed(context).catchError((error) {
              MunchDialog.showError(context, error);
            }),
        child: container,
      ),
    );
  }

  Future onPressed(BuildContext context) async {
    var pref = await UserSearchPreference.get();
    var query = SearchQuery.search(pref);
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
