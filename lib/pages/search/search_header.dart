import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/filter/filter_page.dart';
import 'package:munch_app/pages/filter/filter_token.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/pages/suggest/suggest_page.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';

class SearchAppBar extends PreferredSize {
  SearchAppBar(this.searchQuery);

  final SearchQuery searchQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: elevation1,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(child: _SearchQueryBar(searchQuery)),
            SearchActionButton(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 60);
}

class _SearchQueryBar extends StatelessWidget {
  _SearchQueryBar(this.searchQuery);

  final SearchQuery searchQuery;

  IconData get icon {
    switch (searchQuery.feature) {
      case SearchFeature.Home:
        return MunchIcons.search_header_search;

      case SearchFeature.Collection:
        return MunchIcons.search_header_back;

      case SearchFeature.Location:
        return MunchIcons.search_header_back;

      case SearchFeature.Occasion:
        return MunchIcons.search_header_back;

      case SearchFeature.Search:
        return MunchIcons.search_header_back;
    }
    return MunchIcons.search_header_search;
  }

  String get hint {
    switch (searchQuery.feature) {
      case SearchFeature.Home:
        return 'Search "Chinese"';

      case SearchFeature.Collection:
        return searchQuery.collection?.name ?? 'Collection';

      case SearchFeature.Location:
        return 'Locations';

      case SearchFeature.Occasion:
        return 'Occasions';

      case SearchFeature.Search:
        var tokens = FilterToken.getTokens(searchQuery);
        return FilterToken.getText(tokens);
    }
    return 'Search "Chinese"';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () => onSuggest(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 12, left: 24),
          child: IgnorePointer(child: SearchTextField(icon: icon, hint: hint)),
        ),
      ),
      Container(
        width: 56,
        child: GestureDetector(onTap: () => onBack(context)),
      )
    ]);
  }

  void onSuggest(BuildContext context) {
    final searchQuery = SearchPage.state.searchQuery;

    SuggestPage.push(context, searchQuery).then((searchQuery) {
      if (searchQuery != null && searchQuery is SearchQuery) {
        SearchPage.state.push(searchQuery);
      }
    });
  }

  void onBack(BuildContext context) {
    SearchPage.state.pop();
  }
}

class SearchTextField extends StatelessWidget {
  static const TextStyle _style = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: MunchColors.black75,
  );

  SearchTextField(
      {Key key,
      this.icon = MunchIcons.search_header_search,
      this.hint = 'Search "Chinese"',
      this.autofocus = false,
      this.onChanged,
      this.controller})
      : super(key: key);

  final IconData icon;
  final String hint;
  final bool autofocus;
  final ValueChanged<String> onChanged;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: MunchColors.whisper100,
          ),
          child: TextField(
            controller: controller,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            autofocus: autofocus,
            onChanged: onChanged,
            cursorColor: MunchColors.secondary500,
            maxLines: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.only(left: 40, right: 16, top: 8, bottom: 8),
              hintText: hint,
              hintStyle: _style,
            ),
            style: _style,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 12),
          alignment: Alignment.centerLeft,
          child: Icon(icon, size: 18),
        )
      ],
    );
  }
}

class SearchActionButton extends StatelessWidget {
  const SearchActionButton({
    Key key,
    this.iconData = MunchIcons.search_header_filter,
  }) : super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 18, right: 22),
      iconSize: 28,
      icon: Icon(iconData, color: MunchColors.black),
      onPressed: () => onFilter(context),
    );
  }

  void onFilter(BuildContext context) {
    final searchQuery = SearchPage.state.searchQuery;

    FilterPage.push(context, searchQuery).then((searchQuery) {
      if (searchQuery != null && searchQuery is SearchQuery) {
        SearchPage.state.push(searchQuery);
      }
    });
  }
}
