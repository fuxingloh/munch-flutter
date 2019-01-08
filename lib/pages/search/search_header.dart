import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/filter/filter_token.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';

class SearchAppBar extends PreferredSize {
  SearchAppBar({
    VoidCallback onBack,
    VoidCallback onSuggest,
    VoidCallback onFilter,
  })  : _fieldState =
            _SearchQueryBarState(onBack: onBack, onSuggest: onSuggest),
        _actionButton = SearchActionButton(onPressed: onFilter);

  final _SearchQueryBarState _fieldState;
  final SearchActionButton _actionButton;

  set searchQuery(SearchQuery searchQuery) {
    _fieldState.searchQuery = searchQuery;
  }

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
            Expanded(child: _SearchQueryBar(state: _fieldState)),
            _actionButton,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 60);
}

class _SearchQueryBar extends StatefulWidget {
  final _SearchQueryBarState state;

  const _SearchQueryBar({Key key, this.state}) : super(key: key);

  @override
  State<StatefulWidget> createState() => state;
}

class _SearchQueryBarState extends State<_SearchQueryBar> {
  _SearchQueryBarState({this.onBack, this.onSuggest});

  final VoidCallback onBack;
  final VoidCallback onSuggest;

  String hint = 'Search "Chinese"';
  IconData icon = MunchIcons.search_header_search;

  set searchQuery(SearchQuery searchQuery) {
    switch (searchQuery.feature) {
      case SearchFeature.Home:
        update(MunchIcons.search_header_search, 'Search "Chinese"');
        break;

      case SearchFeature.Collection:
        update(MunchIcons.search_header_back,
            searchQuery.collection?.name ?? "Collection");
        break;

      case SearchFeature.Location:
        update(MunchIcons.search_header_back, 'Locations');
        break;

      case SearchFeature.Occasion:
        update(MunchIcons.search_header_back, 'Occasions');
        break;

      case SearchFeature.Search:
        var tokens = FilterToken.getTokens(searchQuery);
        String text = FilterToken.getText(tokens);
        update(MunchIcons.search_header_back, text);
        break;
    }
  }

  void update(IconData icon, String hint) {
    if (mounted) {
      setState(() {
        this.hint = hint;
        this.icon = icon;
      });
    } else {
      this.hint = hint;
      this.icon = icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: onSuggest,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 12, left: 24),
          child: IgnorePointer(child: SearchTextField(icon: icon, hint: hint)),
        ),
      ),
      Container(
        width: 56,
        child: GestureDetector(onTap: onBack),
      )
    ]);
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
              contentPadding: const EdgeInsets.only(
                  left: 42, right: 18, top: 8, bottom: 8),
              hintText: hint,
              hintStyle: _style,
            ),
            style: _style,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 14),
          alignment: Alignment.centerLeft,
          child: Icon(icon, size: 20),
        )
      ],
    );
  }
}

class SearchActionButton extends StatelessWidget {
  const SearchActionButton({
    Key key,
    this.onPressed,
    this.iconData = MunchIcons.search_header_filter,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 18, right: 23),
      iconSize: 24,
      icon: Icon(iconData, color: MunchColors.black),
      onPressed: onPressed,
    );
  }
}
