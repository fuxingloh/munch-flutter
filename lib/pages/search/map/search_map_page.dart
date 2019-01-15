import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/map/search_map_bottom.dart';
import 'package:munch_app/pages/search/search_manager.dart';

class SearchMapPage extends StatefulWidget {
  final SearchQuery searchQuery;

  const SearchMapPage({Key key, @required this.searchQuery}) : super(key: key);

  @override
  SearchMapPageState createState() => SearchMapPageState(searchQuery);
}

class SearchMapPageState extends State<SearchMapPage> {
  final ScrollController scrollController = ScrollController();

  SearchMapPageState(this.searchQuery);

  SearchQuery searchQuery;
  GoogleMapController mapController;
  SearchManager searchManager;

  List<SearchCard> cards = [];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() => onScroll(scrollController.position));

    // Search Manager
    searchManager = SearchManager(searchQuery);
    searchManager.stream().listen((cards) {
      setState(() => this.cards = cards);
    }, onError: (error) {
      MunchDialog.showError(context, error);
    });
    searchManager.start();
  }

  @override
  void dispose() {
    searchManager.dispose();
    mapController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void onScroll(ScrollPosition position) {
    if (position.pixels > position.maxScrollExtent - 100) {
      searchManager.append().then((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(),
          ),
        ],
      ),
      bottomNavigationBar: SearchMapBottomList(
        controller: scrollController,
        cards: cards,
        more: searchManager.more,
      ),
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
