import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/components/munch_tag_view.dart';
import 'package:munch_app/pages/filter/filter_token.dart';
import 'package:munch_app/pages/places/rip_page.dart';
import 'package:munch_app/pages/search/search_header.dart';
import 'package:munch_app/pages/suggest/suggest_manager.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';

class SuggestPage extends StatefulWidget {
  const SuggestPage({Key key, this.searchQuery}) : super(key: key);

  final SearchQuery searchQuery;

  @override
  State<StatefulWidget> createState() {
    var json = jsonDecode(jsonEncode(searchQuery));
    return SuggestPageState(SearchQuery.fromJson(json));
  }

  static Future<T> push<T extends Object>(BuildContext context, SearchQuery searchQuery) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => SuggestPage(searchQuery: searchQuery),
        settings: const RouteSettings(name: '/search/suggest'),
      ),
    );
  }
}

class SuggestPageState extends State<SuggestPage> {
  SuggestPageState(this.searchQuery);

  final SearchQuery searchQuery;
  final TextEditingController _controller = TextEditingController();
  SuggestManager suggestManager;

  List<SuggestItem> items = [];

  @override
  void initState() {
    super.initState();

    suggestManager = SuggestManager(searchQuery);
    suggestManager.stream(searchQuery).listen((items) {
      setState(() {
        this.items = items;
      });
    });
  }

  @override
  void dispose() {
    suggestManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (items.isEmpty) {
      children.add(const SizedBox(
        height: 3,
        child: LinearProgressIndicator(
          backgroundColor: MunchColors.secondary100,
        ),
      ));
    }

    children.add(Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        itemCount: items.length,
        itemBuilder: _itemBuilder,
      ),
    ));

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _SuggestHeaderBar(
        controller: _controller,
        onCancel: () {
          Navigator.of(context).pop();
        },
        onChanged: (text) {
          suggestManager.onChanged(text);
        },
      ),
      body: Column(children: children),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    SuggestItem item = items[index];

    if (item is SuggestItemQuery) {
      return _SuggestQueryCell(item: item);
    } else if (item is SuggestItemAssumption) {
      return _SuggestAssumptionCell(item: item);
    } else if (item is SuggestItemPlace) {
      return _SuggestPlaceCell(item: item);
    } else if (item is SuggestItemText) {
      return _SuggestTextCell(
        item: item,
        onTap: () {
          suggestManager.onChanged(item.text);
          _controller.text = item.text;
        },
      );
    } else if (item is SuggestItemNoResult) {
      return _SuggestNoResultCell();
    }

    return Container();
  }
}

class _SuggestHeaderBar extends PreferredSize {
  final VoidCallback onCancel;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  _SuggestHeaderBar({this.onCancel, this.onChanged, this.controller});

  @override
  Widget get child {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: elevation1,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12, left: 24),
                child: SearchTextField(
                  autofocus: true,
                  onChanged: onChanged,
                  controller: controller,
                ),
              ),
            ),
            GestureDetector(
              onTap: onCancel,
              child: const Padding(
                padding: EdgeInsets.only(right: 24, left: 18),
                child: Text(
                  "CANCEL",
                  style: TextStyle(
                    color: MunchColors.black85,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 64);
}

class _SuggestQueryCell extends StatelessWidget {
  const _SuggestQueryCell({Key key, this.item}) : super(key: key);

  final SuggestItemQuery item;

  @override
  Widget build(BuildContext context) {
    var tokens = FilterToken.getTokens(item.searchQuery);
    String text = FilterToken.getText(tokens);

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(item.searchQuery),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 24, left: 24),
        child: Row(
          children: [
            Icon(item.iconData),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(text, style: MTextStyle.regular),
            )
          ],
        ),
      ),
    );
  }
}

class _SuggestPlaceCell extends StatelessWidget {
  const _SuggestPlaceCell({Key key, this.item}) : super(key: key);

  final SuggestItemPlace item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RIPPage.push(context, item.place);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 24, left: 24),
        child: Row(
          children: [
            const Icon(MunchIcons.suggest_place),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(item.place.name, style: MTextStyle.regular),
            )
          ],
        ),
      ),
    );
  }
}

class _SuggestAssumptionCell extends StatelessWidget {
  const _SuggestAssumptionCell({Key key, this.item}) : super(key: key);

  final SuggestItemAssumption item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(item.assumptionQueryResult.searchQuery),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 24, left: 24),
        child: Row(
          children: [
            const Icon(MunchIcons.suggest_pointer),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: _buildTag(item.assumptionQueryResult.tokens),
            )
          ],
        ),
      ),
    );
  }

  MunchTagView _buildTag(List<AssumptionToken> tokens) {
    const MunchTagStyle textStyle = MunchTagStyle(
      backgroundColor: MunchColors.clear,
      padding: EdgeInsets.only(top: 5, bottom: 5),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: MunchColors.black85,
      ),
    );
    const MunchTagStyle tagStyle = MunchTagStyle(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: MunchColors.black85,
      ),
    );

    List<MunchTagData> tags = tokens.map((token) {
      switch (token.type) {
        case AssumptionType.tag:
          return MunchTagData(token.text, style: tagStyle);
        case AssumptionType.text:
          return MunchTagData(token.text, style: textStyle);
        case AssumptionType.others:
          return MunchTagData(token.text, style: textStyle);
      }
    }).toList(growable: false);

    return MunchTagView(tags: tags);
  }
}

class _SuggestTextCell extends StatelessWidget {
  const _SuggestTextCell({Key key, this.item, this.onTap}) : super(key: key);

  final SuggestItemText item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 12, right: 24, left: 24),
        child: Text(
          "Did you mean ${item.text}",
          style: MTextStyle.regular.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _SuggestNoResultCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12, right: 24, left: 24),
      child: Text(
        "No Results",
        style: MTextStyle.regular.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
