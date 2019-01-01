import 'package:flutter/material.dart';
import 'package:munch_app/api/search_api.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key key, this.searchQuery}) : super(key: key);

  final SearchQuery searchQuery;

  @override
  State<StatefulWidget> createState() => FilterPageState(searchQuery);
}

class FilterPageState extends State<FilterPage> {
  FilterPageState(this.searchQuery);

  final SearchQuery searchQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(),
    );
  }
}