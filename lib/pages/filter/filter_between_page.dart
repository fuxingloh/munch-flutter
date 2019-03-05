import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:munch_app/api/api.dart';
import 'dart:convert';

import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/components/bottom_sheet.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/pages/filter/location_select_page.dart';
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

  static Future<T> push<T extends Object>(BuildContext context, SearchQuery searchQuery) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => FilterBetweenPage(searchQuery: searchQuery),
        settings: const RouteSettings(name: '/search/filter/between'),
      ),
    );
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
    final List<String> latLngList = points.map((p) => p.latLng).toList(growable: false);

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
      initialCameraPosition: const CameraPosition(
        target: LatLng(1.305270, 103.8),
        zoom: 11.0,
      ),
      onMapCreated: _onMapCreated,
      scrollGesturesEnabled: false,
      compassEnabled: false,
      myLocationEnabled: false,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: false,
    );

    final center = const Center(
      child: SizedBox(height: 30, width: 30, child: Image(image: AssetImage('assets/img/rip_map_centroid.png'))),
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
              icon: const Icon(Icons.delete),
              child: const Text("Remove Location"),
            ),
            MunchBottomSheetTile(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              child: const Text("Cancel"),
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
    SearchLocationPage.push(context).then((location) {
      if (location == null) return;

      setState(() {
        var point = SearchFilterLocationPoint(location.name, location.latLng);
        searchQuery.filter.location.points.add(point);
        refresh();
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
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
        padding: EdgeInsets.only(bottom: 8),
        child: Text("Enter everyone’s location to find the most ideal spot for a meal together."),
      )
    ];

    if (points.isNotEmpty) {
      for(var i = 0; i < points.length; i++){

        children.add(_EatBetweenPoint(point: points[i], onRemove: () {
          onRemove(i);
        }));
      }
    } else {
      children.add(SizedBox(height: 8));
    }

    if (points.length < 10) {
      children.add(_SelectLocationButton(onPressed: onAdd));
    }

    children.add(Padding(
      padding: const EdgeInsets.only(top: 16),
      child: _FilterBetweenAction(
        onApply: onApply,
        result: result,
        points: points,
      ),
    ));

    return Container(
      decoration: const BoxDecoration(boxShadow: elevation2, color: MunchColors.white),
      padding: const EdgeInsets.only(top: 24, bottom: 24, left: 24, right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _FilterBetweenAction extends StatelessWidget {
  _FilterBetweenAction({
    Key key,
    @required this.onApply,
    @required this.result,
    @required this.points,
  }) : super(key: key);

  final List<SearchFilterLocationPoint> points;
  final VoidCallback onApply;
  final FilterResult result;

  final MunchButtonStyle requireStyle = MunchButtonStyle.secondary.copyWith(
      background: MunchColors.white, borderColor: MunchColors.white, textColor: MunchColors.black, padding: 0);

  final MunchButtonStyle fadedStyle = MunchButtonStyle.secondary.copyWith(
      background: MunchColors.secondary050,
      borderColor: MunchColors.secondary050,
      textColor: MunchColors.secondary700,
      padding: 0);

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return MunchButton.text("Requires at least 2 locations", onPressed: null, style: requireStyle);
    }

    if (result == null) {
      return MunchButton.text("Loading...", onPressed: null, style: fadedStyle);
    } else if (result.count > 0) {
      return MunchButton.text(
        FilterManager.countTitle(count: result.count, postfix: "Places"),
        onPressed: onApply,
      );
    } else {
      return MunchButton.text("No Results", onPressed: null, style: fadedStyle);
    }
  }
}

class _SelectLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SelectLocationButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: MunchColors.black20),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Icon(MunchIcons.location_pin, size: 24, color: MunchColors.black60),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Enter location", style: MTextStyle.regular.copyWith(color: MunchColors.black60)),
            )
          ],
        ),
      ),
    );
  }
}

class _EatBetweenPoint extends StatelessWidget {
  final VoidCallback onRemove;
  final SearchFilterLocationPoint point;

  const _EatBetweenPoint({Key key, this.onRemove, this.point}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Icon(MunchIcons.location_pin, size: 24, color: MunchColors.primary500),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(point.name, maxLines: 1,),
                ),
                const SeparatorLine()
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(MunchIcons.location_cancel, size: 20, color: MunchColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
