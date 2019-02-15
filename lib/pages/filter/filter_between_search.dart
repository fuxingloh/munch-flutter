import 'package:flutter/material.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:rxdart/rxdart.dart';

class FilterBetweenSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FilterBetweenSearchPageState();

  static Future<T> push<T extends Object>(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => FilterBetweenSearchPage(),
        settings: const RouteSettings(name: '/search/filter/between/search'),
      ),
    );
  }
}

class FilterBetweenSearchPageState extends State<FilterBetweenSearchPage> {
  static const MunchApi _api = MunchApi.instance;

  bool loading = false;
  List<SearchFilterLocationPoint> points = [];

  PublishSubject<String> _onTextChanged;

  @override
  void initState() {
    super.initState();

    _onTextChanged = PublishSubject<String>();

    _onTextChanged.distinct().debounce(const Duration(milliseconds: 300)).switchMap((text) async* {
      if (text.length < 2) {
        yield [false, <SearchFilterLocationPoint>[]];
      } else {
        yield [true, <SearchFilterLocationPoint>[]];

        final points = await _api.post('/search/filter/between/search', body: {'text': text.toLowerCase()}).then((res) {
          List<dynamic> data = res.data;
          return SearchFilterLocationPoint.fromJsonList(data);
        });

        yield [false, points];
      }
    }).listen((result) {
      setState(() {
        loading = result[0];
        points = result[1];
      });
    });
  }

  @override
  void dispose() {
    _onTextChanged.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (loading) {
      children.add(const SizedBox(
        height: 3,
        child: LinearProgressIndicator(
          backgroundColor: MunchColors.secondary100,
        ),
      ));
    }

    children.add(Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        itemBuilder: (_, i) => _FilterPointCell(point: points[i]),
        itemCount: points.length,
      ),
    ));

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          title: TextField(
        autofocus: true,
        autocorrect: false,
        onChanged: (text) => _onTextChanged.add(text),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search here",
          hintStyle: const TextStyle(
            fontSize: 19,
            color: MunchColors.black75,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: const TextStyle(
          fontSize: 19,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      )),
      body: Column(children: children),
    );
  }
}

class _FilterPointCell extends StatelessWidget {
  const _FilterPointCell({Key key, this.point}) : super(key: key);

  final SearchFilterLocationPoint point;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(context),
      child: Container(
        margin: const EdgeInsets.only(left: 72, right: 24, top: 16, bottom: 16),
        child: Text(
          point.name,
          style: MTextStyle.regular,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void onTap(BuildContext context) {
    Navigator.of(context).pop(point);
  }
}
