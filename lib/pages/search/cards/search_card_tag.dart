import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/search_card.dart';

class SearchCardTagSuggestion extends SearchCardWidget {
  SearchCardTagSuggestion(SearchCard card)
      : tags = FilterTag.fromJsonList(card['tags']),
        locationName = card['locationName'],
        super(card, margin: SearchCardInsets.only(left: 0, right: 0, top: 0));

  final List<FilterTag> tags;
  final String locationName;

  @override
  Widget buildCard(BuildContext context) {
    var listView = ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 24, right: 24),
      itemBuilder: (context, i) {
        return _SearchCardTagCell(tag: tags[i]);
      },
      itemCount: tags.length,
      separatorBuilder: (c, i) => SizedBox(width: 18),
    );

    return Container(
      color: MunchColors.primary500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24, top: 18),
            child: Text("Can't decide?",
                style: MTextStyle.h2.copyWith(color: MunchColors.white)),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
            child: Text(
                "Here are some suggestions of what’s good ${locationName != null ? 'in $locationName' : 'nearby'}.",
                style: MTextStyle.h6.copyWith(color: MunchColors.white)),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            height: 70,
            child: listView,
          ),
        ],
      ),
    );
  }
}

class _SearchCardTagCell extends StatelessWidget {
  const _SearchCardTagCell({Key key, this.tag}) : super(key: key);

  final FilterTag tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: 120,
        height: 70,
        decoration: BoxDecoration(
            color: MunchColors.white, borderRadius: BorderRadius.circular(3)),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 2, right: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              tag.name,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: MunchColors.black85),
            ),
            Text(
              "${tag.count} places",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MunchColors.black80),
            ),
          ],
        ),
      ),
    );
  }

  void onPressed() {
    var query = SearchQuery.search();
    query.filter.tags.add(tag);
    SearchPage.state.push(query);
  }
}
