import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/components/munch_tag_view.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/pages/filter/filter_token.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';

class FilterAppBar extends PreferredSize {
  FilterAppBar(this._manager);

  final FilterManager _manager;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: elevation1,
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              padding: const EdgeInsets.only(left: 18, right: 18),
              icon: Icon(Icons.arrow_back, color: MunchColors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(child: _FilterAppBarTags(manager: _manager)),
            IconButton(
              padding: const EdgeInsets.only(left: 18, right: 23),
              icon: Icon(MunchIcons.search_header_reset,
                  color: MunchColors.black),
              onPressed: () => _manager.reset(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 80);
}

class _FilterAppBarTags extends StatelessWidget {
  const _FilterAppBarTags({Key key, this.manager}) : super(key: key);

  final FilterManager manager;

  @override
  Widget build(BuildContext context) {
    const MunchTagStyle _style = MunchTagStyle(
      backgroundColor: MunchColors.whisper100,
      padding: EdgeInsets.only(left: 12, right: 12, top: 7, bottom: 7),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: MunchColors.black75,
      ),
    );


    List<FilterToken> tokens = FilterToken.getTokens(manager.searchQuery);
    List<MunchTagData> list = FilterToken.getTextPart(tokens).map((text) {
      return MunchTagData(text, style: _style);
    }).toList(growable: false);

    return MunchTagView(tags: list);
  }
}
