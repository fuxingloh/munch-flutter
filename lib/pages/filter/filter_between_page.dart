import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:munch_app/api/api.dart';
import 'dart:convert';

import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/components/bottom_sheet.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/filter/filter_between_search.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/styles/munch.dart';
import 'package:munch_app/utils/munch_location.dart';

class FilterBetweenPage extends StatefulWidget {
  const FilterBetweenPage({Key key, this.searchQuery}) : super(key: key);

  final SearchQuery searchQuery;

  @override
  State<StatefulWidget> createState() {
    var json = jsonDecode(jsonEncode(searchQuery));
    return FilterBetweenState(SearchQuery.fromJson(json));
  }
}

class FilterBetweenState extends State<FilterBetweenPage> {
  static const _api = MunchApi.instance;

  FilterBetweenState(this.searchQuery) {
    this.searchQuery.feature = SearchFeature.Search;
    this.searchQuery.filter.location.type = SearchFilterLocationType.Between;
  }

  SearchQuery searchQuery;
  GoogleMapController mapController;

  FilterResult _result;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    setState(() {
      this._result = null;
    });

    if (searchQuery.filter.location.points.length < 2) {
      return;
    }

    _api.post('/search/filter', body: searchQuery).then((res) {
      Map<String, dynamic> data = res.data;
      return FilterResult.fromJson(data);
    }).then((result) {
      setState(() {
        this._result = result;
        mapController.clearMarkers();
        refreshMap();
      });
    }, onError: (error) {
      MunchDialog.showError(context, error);
    });
  }

  void refreshMap() {
    mapController.clearMarkers();

    final points = searchQuery.filter.location.points;
    final List<String> latLngList =
        points.map((p) => p.latLng).toList(growable: false);

    points.forEach((point) {
      var ll = point.latLng.split(",");
      var latLng = LatLng(double.parse(ll[0]), double.parse(ll[1]));
      mapController.addMarker(MarkerOptions(
        position: latLng,
        infoWindowText: InfoWindowText(point.name, null),
      ));
    });

    var box = getBoundingBox(latLngList, 0);
    mapController.moveCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(box.botLat, box.topLng),
        northeast: LatLng(box.topLat, box.botLng),
      ),
      80,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final googleMap = GoogleMap(
      onMapCreated: _onMapCreated,
      options: GoogleMapOptions(
        scrollGesturesEnabled: false,
        compassEnabled: false,
        myLocationEnabled: false,
      ),
    );

    final center = const Center(
      child: SizedBox(
        height: 40,
        width: 40,
        child: Icon(
          MunchIcons.suggest_place,
          color: MunchColors.secondary900,
          size: 40,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          googleMap,
          _FilterBetweenBar(),
          _result != null ? center : Container(),
        ],
      ),
      bottomNavigationBar: _FilterBetweenBottom(
        result: _result,
        points: searchQuery.filter.location.points,
        onRemove: _onRemove,
        onApply: _onApply,
        onAdd: _onAdd,
      ),
    );
  }

  void _onRemove(i) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MunchBottomSheet(
          children: [
            MunchBottomSheetTile(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  searchQuery.filter.location.points.removeAt(i);
                  refresh();
                });
              },
              icon: Icon(Icons.delete),
              child: Text("Remove Location"),
            ),
            MunchBottomSheetTile(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _onApply() {
    Navigator.of(context).pop(searchQuery);
  }

  void _onAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => FilterBetweenSearchPage()),
    ).then((point) {
      if (point == null) return;

      setState(() {
        searchQuery.filter.location.points.add(point);
        refresh();
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(1.305270, 103.8),
          zoom: 11.0,
        ),
      ));
    });
  }
}

class _FilterBetweenBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: const Text("EatBetween"),
      backgroundColor: MunchColors.clear,
      elevation: 0,
      iconTheme: const IconThemeData(color: MunchColors.black),
    );

    return Container(
      decoration: const BoxDecoration(color: MunchColors.clear),
      child: SafeArea(
        child: SizedBox.fromSize(
          child: appBar,
          size: appBar.preferredSize,
        ),
      ),
    );
  }
}

class _FilterBetweenBottom extends StatelessWidget {
  const _FilterBetweenBottom({
    Key key,
    @required this.points,
    @required this.onAdd,
    @required this.onRemove,
    @required this.onApply,
    @required this.result,
  }) : super(key: key);

  final List<SearchFilterLocationPoint> points;
  final ValueChanged<int> onRemove;
  final VoidCallback onAdd;
  final VoidCallback onApply;
  final FilterResult result;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      const Padding(
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 8),
        child: Text("Enter everyone’s location and we’ll find the "
            "most ideal spot for a meal together."),
      )
    ];

    if (points.isNotEmpty) {
      children.add(_FilterBetweenRow(points: points, onRemove: onRemove));
    } else {
      children.add(const SizedBox(
        height: 48,
        child: Center(child: Text("Require 2 Locations")),
      ));
    }

    children.add(Padding(
      padding: const EdgeInsets.only(top: 8),
      child: _FilterBetweenAction(
        onAdd: onAdd,
        onApply: onApply,
        result: result,
        points: points,
      ),
    ));

    return Container(
      decoration:
          const BoxDecoration(boxShadow: elevation2, color: MunchColors.white),
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _FilterBetweenRow extends StatelessWidget {
  const _FilterBetweenRow({
    Key key,
    @required this.points,
    @required this.onRemove,
  }) : super(key: key);

  final List<SearchFilterLocationPoint> points;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
        itemCount: points.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => onRemove(i),
            child: Container(
              decoration: const BoxDecoration(
                color: MunchColors.whisper100,
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Center(child: Text('${i + 1}. ${points[i].name}')),
            ),
          );
        },
        separatorBuilder: (c, _) => SizedBox(width: 16),
      ),
    );
  }
}

class _FilterBetweenAction extends StatelessWidget {
  _FilterBetweenAction({
    Key key,
    @required this.onAdd,
    @required this.onApply,
    @required this.result,
    @required this.points,
  }) : super(key: key);

  final List<SearchFilterLocationPoint> points;
  final VoidCallback onAdd;
  final VoidCallback onApply;
  final FilterResult result;

  final MunchButtonStyle fade = MunchButtonStyle.secondary.copyWith(
      background: MunchColors.secondary050,
      borderColor: MunchColors.secondary050,
      textColor: MunchColors.secondary700);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 12),
          child: _addButton,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 24),
            child: _applyButton,
          ),
        ),
      ],
    );
  }

  MunchButton get _addButton {
    if (points.length < 10) {
      return MunchButton.text(
        "+ Location",
        onPressed: onAdd,
        style: MunchButtonStyle.secondaryOutline,
      );
    } else {
      return MunchButton.text(
        "Max 10",
        onPressed: null,
        style: fade,
      );
    }
  }

  MunchButton get _applyButton {
    if (points.length < 2) {
      return MunchButton.text(
        "Require 2",
        onPressed: null,
        style: fade,
      );
    }

    if (result == null) {
      return MunchButton.text(
        "Loading...",
        onPressed: null,
        style: fade,
      );
    } else if (result.count > 0) {
      return MunchButton.text(
        FilterManager.countTitle(count: result.count, postfix: "Places"),
        onPressed: onApply,
      );
    } else {
      return MunchButton.text(
        "No Results",
        onPressed: null,
        style: fade,
      );
    }
  }
}
