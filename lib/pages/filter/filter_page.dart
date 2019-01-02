import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/filter/filter_cell_hour.dart';
import 'package:munch_app/pages/filter/filter_cell_location.dart';
import 'package:munch_app/pages/filter/filter_cell_price.dart';
import 'package:munch_app/pages/filter/filter_cell_tag.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/styles/colors.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key key, this.searchQuery}) : super(key: key);

  final SearchQuery searchQuery;

  @override
  State<StatefulWidget> createState() => FilterPageState(searchQuery);
}

class FilterPageState extends State<FilterPage> {
  FilterPageState(this.searchQuery);

  final SearchQuery searchQuery;
  List<FilterItem> _items = [];

  FilterManager _manager;

  @override
  void initState() {
    super.initState();

    _manager = FilterManager(searchQuery);
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
    )));

    return Scaffold(
      appBar: AppBar(),
      body: Column(children: children),
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
      return FilterCellTag(item);
    } else if (item is FilterItemTagMore) {
      return FilterCellTagMore(item);
    }

    return null;
  }
}
