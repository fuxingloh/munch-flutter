import 'package:flutter/cupertino.dart';
import 'package:munch_app/api/search_api.dart';

class SuggestPage extends StatefulWidget {
  const SuggestPage({Key key, this.searchQuery}) : super(key: key);

  final SearchQuery searchQuery;

  @override
  State<StatefulWidget> createState() => SuggestPageState(searchQuery);
}

class SuggestPageState extends State<SuggestPage> {
  SuggestPageState(this.searchQuery);

  final SearchQuery searchQuery;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}