import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/map/search_map_bottom.dart';
import 'package:munch_app/pages/search/map/search_map_manager.dart';
import 'package:munch_app/styles/munch.dart';

class SearchMapPage extends StatefulWidget {
  final SearchQuery searchQuery;

  const SearchMapPage({Key key, @required this.searchQuery}) : super(key: key);

  @override
  SearchMapPageState createState() => SearchMapPageState(searchQuery);
}

class SearchMapPageState extends State<SearchMapPage> {
  final PageController pageController = PageController(
    viewportFraction: SearchMapBottomList.fraction,
  );

  SearchMapPageState(this.searchQuery);

  SearchQuery searchQuery;
  GoogleMapController mapController;
  SearchMapManager mapManager;

  List<MapPlace> places = [];
  int focused = 0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() => onScroll(pageController.position));

    // Search Manager
    mapManager = SearchMapManager(searchQuery);
    mapManager.stream().listen((mapPlaces) {
      setState(() {
        this.places = mapPlaces;

        if (mapController == null) return;
        mapController.clearMarkers();

        places.forEach((place) {
          mapController
              .addMarker(MarkerOptions(
            flat: true,
            consumeTapEvents: true,
            position: place.latLng,
            infoWindowText: InfoWindowText(place.place.name, null),
          ))
              .then((maker) {
            place.marker = maker;
          });
        });

        var update = CameraUpdate.newLatLngZoom(places[0].latLng, 16);
        mapController.moveCamera(update);
      });
    }, onError: (error) {
      MunchDialog.showError(context, error);
    });
  }

  @override
  void dispose() {
    mapManager.dispose();
    mapController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void onScroll(ScrollPosition position) {
    if (position.pixels > position.maxScrollExtent - 100) {
      mapManager.append().then((_) {
        setState(() {});
      });
    }

    if (focused == pageController.page.ceil()) return;

    setState(() {
      focused = pageController.page.ceil();
      var latLng = places[focused]?.marker?.options?.position;
      if (latLng != null) {
        mapController.moveCamera(CameraUpdate.newLatLngZoom(latLng, 16));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              compassEnabled: false,
              tiltGesturesEnabled: false,
              myLocationEnabled: false,
            ),
          ),
          _SearchMapHeader()
        ],
      ),
      bottomNavigationBar: SearchMapBottomList(
        controller: pageController,
        mapPlaces: places,
        more: mapManager.more,
        focused: focused,
      ),
    );
  }

  /// Map must be ready before search manager
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapManager.start();
      mapController.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(1.28, 103.8),
          zoom: 12.0,
        ),
      ));

      mapController.onMarkerTapped.add(_onMarkerTapped);
    });
  }

  void _onMarkerTapped(Marker marker) {
    var page = places.indexWhere((p) => marker.id == p.marker.id);
    pageController.jumpToPage(page);
  }
}

class _SearchMapHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
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
