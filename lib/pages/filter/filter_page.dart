import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/filter/filter_bottom.dart';
import 'package:munch_app/pages/filter/filter_cell_hour.dart';
import 'package:munch_app/pages/filter/filter_cell_location.dart';
import 'package:munch_app/pages/filter/filter_cell_price.dart';
import 'package:munch_app/pages/filter/filter_cell_tag.dart';
import 'package:munch_app/pages/filter/filter_header.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/styles/colors.dart';

import 'dart:convert';

class FilterPage extends StatefulWidget {
  const FilterPage({Key key, this.searchQuery}) : super(key: key);

  final SearchQuery searchQuery;

  @override
  State<StatefulWidget> createState() {
    var json = jsonDecode(jsonEncode(searchQuery));
    return FilterPageState(SearchQuery.fromJson(json));
  }
}

class FilterPageState extends State<FilterPage> {
  FilterPageState(SearchQuery searchQuery) {
    _manager = FilterManager(searchQuery);
  }

  List<FilterItem> _items = [];

  FilterManager _manager;

  @override
  void initState() {
    super.initState();

    _manager.stream().listen((items) {
      setState(() {
        this._items = items;
      });
    }, onError: (e, s) {
      MunchDialog.showError(context, e);
    });
    _manager.dispatch();
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  void _onApply() {
    Navigator.of(context).pop(_manager.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (_manager.loading) {
      children.add(const SizedBox(
        height: 3,
        child: LinearProgressIndicator(
          backgroundColor: MunchColors.secondary100,
        ),
      ));
    }

    children.add(Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 12, bottom: 12),
        itemBuilder: _itemBuilder,
        itemCount: _items.length,
      ),
    ));

    return Scaffold(
      appBar: FilterAppBar(_manager),
      body: Column(children: children),
      bottomNavigationBar: FilterBottomView(
        onPressed: _onApply,
        count: _manager.result?.count,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int i) {
    FilterItem item = _items[i];

    if (item is FilterItemLocation) {
      return FilterCellLocation(item);
    } else if (item is FilterItemPrice) {
      return FilterCellPrice(item);
    } else if (item is FilterItemTiming) {
      return FilterCellHour(item: item, manager: _manager);
    } else if (item is FilterItemTagHeader) {
      return FilterCellTagHeader(item);
    } else if (item is FilterItemTag) {
      return FilterCellTag(item: item, manager: _manager);
    } else if (item is FilterItemTagMore) {
      return FilterCellTagMore(item);
    }

    return null;
  }
}
