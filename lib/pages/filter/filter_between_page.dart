import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:munch_app/api/munch_data.dart';
import 'dart:convert';

import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/styles/munch.dart';

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
  FilterBetweenState(this.searchQuery);

  SearchQuery searchQuery;
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              compassEnabled: false,
              myLocationEnabled: false,
            ),
          ),
          AppBar(backgroundColor: MunchColors.clear),
        ],
      ),
      bottomNavigationBar: FilterBetweenBottom(),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(1.28, 103.8),
          zoom: 16.0,
        ),
      ));
    });
  }
}

class FilterBetweenBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: const Text("EatBetween"),
      backgroundColor: MunchColors.clear,
      elevation: 0,
      iconTheme: IconThemeData(color: MunchColors.black),
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

class FilterBetweenBottom extends StatelessWidget {
  final List<Area> areas = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          const BoxDecoration(boxShadow: elevation2, color: MunchColors.white),
      height: 120,
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text("EatBetween", style: MTextStyle.h2),
          ),
          Text(
              "Enter everyone’s location and we’ll find the most ideal spot for a meal together.")
        ],
      ),
    );
  }
}
