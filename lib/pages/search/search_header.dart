import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/pages/filter/filter_token.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';

class SearchHeaderBar extends PreferredSize {
  SearchHeaderBar({
    VoidCallback onBack,
    VoidCallback onSuggest,
    VoidCallback onFilter,
  })  : _textFieldState =
            _SearchTextFieldState(onBack: onBack, onSuggest: onSuggest),
        _filterButton = _SearchFilterButton(onPressed: onFilter);

  final _SearchTextFieldState _textFieldState;
  final _SearchFilterButton _filterButton;

  set searchQuery(SearchQuery searchQuery) {
    _textFieldState.searchQuery = searchQuery;
  }

  @override
  Widget get child => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: elevation1,
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(child: _SearchTextField(state: _textFieldState)),
              _filterButton,
            ],
          ),
        ),
      );

  @override
  Size get preferredSize => Size(double.infinity, 64);
}

class _SearchTextField extends StatefulWidget {
  final _SearchTextFieldState state;

  const _SearchTextField({Key key, this.state}) : super(key: key);

  @override
  State<StatefulWidget> createState() => state;
}

class _SearchTextFieldState extends State<_SearchTextField> {
  static const TextStyle _textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: MunchColors.black75,
  );

  _SearchTextFieldState({this.onBack, this.onSuggest});

  final VoidCallback onBack;
  final VoidCallback onSuggest;

  String hintText = 'Search "Chinese"';
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
        update(MunchIcons.search_header_back,
            getText(FilterToken.getTokens(searchQuery)));
        break;
    }
  }

  String getText(List<FilterToken> tokens) {
    String text = '';

    if (tokens.length > 0) {
      text = tokens[0].text;
    }

    if (tokens.length > 1) {
      text += '  •  ';
      text = tokens[1].text;
    }

    var count = tokens.length - 2;
    if (count > 0) {
      text += '  •  ';
      text = "+$count";
    }

    return text;
  }

  void update(IconData icon, String hint) {
    if (mounted) {
      setState(() {
        this.hintText = hint;
        this.icon = icon;
      });
    } else {
      this.hintText = hint;
      this.icon = icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        margin: const EdgeInsets.only(top: 12, bottom: 12, left: 24),
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: MunchColors.whisper100,
        ),
        child: Center(child: _buildTextField()),
      ),
      Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        child: IconButton(
          splashColor: Colors.white,
          padding: const EdgeInsets.only(left: 38, right: 16),
          iconSize: 20,
          icon: Icon(icon),
          onPressed: onBack,
        ),
      )
    ]);
  }

  TextField _buildTextField() {
    return TextField(
      onTap: onSuggest,
      decoration: InputDecoration(
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.only(left: 42, right: 24, top: 10, bottom: 10),
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: _textStyle,
      ),
    );
  }
}

class _SearchFilterButton extends StatelessWidget {
  const _SearchFilterButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.only(left: 20, right: 23),
      iconSize: 28,
      icon: const Icon(MunchIcons.search_header_filter),
      onPressed: onPressed,
    );
  }
}
