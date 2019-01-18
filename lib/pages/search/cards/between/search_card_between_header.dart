import 'package:flutter/material.dart';
import 'package:munch_app/pages/filter/filter_between_page.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:share/share.dart';

class SearchBetweenAnchor {
  SearchBetweenAnchor({this.title, this.uniqueId});

  String title;
  String uniqueId;

  static List<SearchBetweenAnchor> fromJsonList(List<dynamic> list) {
    return list.map((map) {
      return SearchBetweenAnchor(
        title: map['title'],
        uniqueId: map['uniqueId'],
      );
    }).toList(growable: false);
  }
}

class SearchCardBetweenHeader extends SearchCardWidget {
  final List<SearchBetweenAnchor> _anchors;
  final String title;

  SearchCardBetweenHeader(SearchCard card)
      : _anchors = SearchBetweenAnchor.fromJsonList(card['anchors']),
        title = card['title'],
        super(
          card,
          margin: SearchCardInsets.only(left: 0, right: 0),
        );

  @override
  Widget buildCard(BuildContext context) {
    final query = SearchPage.state.searchQuery;
    final length = query.filter.location.points.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 16),
                    child: Text(title, style: MTextStyle.h2),
                  ),
                  GestureDetector(
                    onTap: () => onEdit(context),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8, left: 24, right: 16),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(MunchIcons.rip_edit, size: 16),
                          ),
                          Text("Between $length Locations"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: MunchButton.text(
                "SHARE",
                style: MunchButtonStyle.borderSmall,
                onPressed: () => onShare(context),
              ),
            )
          ],
        ),
        Container(
          height: 48,
          margin: const EdgeInsets.only(top: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 24, right: 24),
            itemBuilder: (c, i) => _AnchorBetweenCell(anchor: _anchors[i]),
            separatorBuilder: (c, i) => SizedBox(width: 16),
            itemCount: _anchors.length,
          ),
        )
      ],
    );
  }

  static double height(BuildContext context, SearchCard card) {
    const insets = SearchCardInsets.only();
    return insets.vertical +
        48 +
        16 +
        MTextStyle.h2.fontSize +
        8 +
        MTextStyle.regular.fontSize;
  }

  void onEdit(BuildContext context) {
    final searchQuery = SearchPage.state.searchQuery;

    Future<SearchQuery> future = Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (c) => FilterBetweenPage(searchQuery: searchQuery),
    ));

    future.then((searchQuery) {
      if (searchQuery == null) return;

      SearchPage.state.push(searchQuery);
    });
  }

  void onShare(BuildContext context) {
    final qid = SearchPage.state.qid;
    Share.share("https://www.munch.app/search?qid=$qid&g=GB10");
  }
}

class _AnchorBetweenCell extends StatelessWidget {
  const _AnchorBetweenCell({Key key, this.anchor}) : super(key: key);

  final SearchBetweenAnchor anchor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        padding: const EdgeInsets.only(left: 16, right: 16),
        decoration: const BoxDecoration(
          color: MunchColors.whisper100,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        alignment: Alignment.center,
        child: Text(anchor.title, style: MTextStyle.h5),
      ),
    );
  }

  void onPressed() {
    SearchPage.state.scrollTo(anchor.uniqueId);
  }
}
