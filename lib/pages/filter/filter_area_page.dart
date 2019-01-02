import 'package:flutter/material.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';

class FilterAreaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FilterAreaPageState();
}

class FilterAreaPageState extends State<FilterAreaPage> {
  static const MunchApi _api = MunchApi.instance;

  bool searching = false;
  bool loading = true;

  List<Area> _areas = [];
  List<Area> _filtered = [];

  @override
  void initState() {
    super.initState();

    _api.get('/search/filter/areas').then((res) {
      var areas = _FilterAreaAlpha.sort(Area.fromJsonList(res.data));
      setState(() {
        this.loading = false;
        this._areas = areas;
        this._filtered = List.of(areas, growable: false);
      });
    }, onError: (error) {
      MunchDialog.showError(context, error);
      setState(() {
        this.loading = false;
      });
    });
  }

  void _onSearch() {
    setState(() {
      searching = !searching;
      if (searching) {
        _filtered = [];
      } else {
        _filtered = List.of(_areas, growable: false);
      }
    });
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
        padding: EdgeInsets.only(left: 72, top: 8, bottom: 8, right: 24),
        itemBuilder: (_, i) => _FilterAreaCell(area: _filtered[i]),
        itemCount: _filtered.length,
      ),
    ));

    var _searchField = TextField(
      autofocus: true,
      onChanged: (text) {
        setState(() {
          _filtered = _FilterAreaAlpha.search(_areas, text);
        });
      },
      style: TextStyle(
          fontSize: 19, color: Colors.black, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: searching ? _searchField : Text('Locations'),
        actions: [
          IconButton(
            icon: Icon(searching ? Icons.close : Icons.search),
            onPressed: _onSearch,
          )
        ],
      ),
      body: Column(children: children),
    );
  }
}

class _FilterAreaCell extends StatelessWidget {
  const _FilterAreaCell({Key key, this.area}) : super(key: key);

  final Area area;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        margin: EdgeInsets.only(top: 16, bottom: 16),
        child: Text(
          area.name,
          style: MTextStyle.large,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void onTap(BuildContext context) {
    Navigator.of(context).pop(area);
  }
}

class _FilterAreaAlpha {
  static const _alpha = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "#"
  ];

  static List<Area> search(List<Area> areas, String text) {
    return areas.where((area) {
      return area.name.toLowerCase().contains(text.toLowerCase());
    }).toList(growable: false);
  }

  static List<Area> sort(List<Area> areas) {
    Map<String, List<Area>> mapping = {};
    _alpha.forEach((a) => mapping[a] = []);

    areas.sort((a1, a2) {
      return a1.name.toLowerCase().compareTo(a2.name.toLowerCase());
    });

    areas.forEach((area) {
      var a = area.name.substring(0, 1).toLowerCase();
      if (mapping.containsKey(a)) {
        mapping[a].add(area);
      } else {
        mapping['#'].add(area);
      }
    });

    return _alpha.expand((a) {
      return mapping[a];
    }).toList(growable: false);
  }
}
