import 'package:flutter/material.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/pages/places/rip_map_page.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/separators.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:munch_app/utils/munch_location.dart';

class RIPCardLocation extends RIPCardWidget {
  RIPCardLocation(PlaceData data) : super(data, margin: const RIPCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Text("Location", style: MTextStyle.h2),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 16),
          child: Text(data.place.location.address, style: MTextStyle.regular),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 2),
          child: _line2(),
        ),
        Container(
          margin: const EdgeInsets.all(24),
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: IgnorePointer(child: _RIPCardMap(placeData: data)),
          ),
        ),
        const SeparatorLine()
      ],
    );
  }

  Widget _line2() {
    List<TextSpan> children = [];

    String latLng = data.place.location.latLng;

    var distance = MunchLocation.instance.distanceAsMetric(latLng);
    if (distance != null) {
      children.add(TextSpan(text: '$distance'));
    }

    var landmarks = data.place.location.landmarks;
    if (landmarks != null && landmarks.isNotEmpty) {
      var landmark = landmarks[0];
      var min = MunchLocation.instance.distanceAsDuration(latLng, landmark.location.latLng);
      children.add(TextSpan(text: ' • $min from '));
      children.add(TextSpan(text: landmark.name, style: TextStyle(fontWeight: FontWeight.w600)));
    }

    return RichText(
      maxLines: 1,
      text: TextSpan(
        style: MTextStyle.regular,
        children: children,
      ),
    );
  }

  @override
  void onTap(BuildContext context, PlaceData data) {
    MunchAnalytic.logEvent("rip_click_map");
    RIPMapPage.push(context, data);
  }
}

class _RIPCardMap extends StatefulWidget {
  const _RIPCardMap({Key key, this.placeData}) : super(key: key);

  final PlaceData placeData;

  @override
  State<StatefulWidget> createState() => _RIPCardMapState();

  LatLng get latLng {
    var location = placeData.place.location;
    var split = location.latLng.split(",");
    return LatLng(double.parse(split[0]), double.parse(split[1]));
  }
}

class _RIPCardMapState extends State<_RIPCardMap> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.latLng,
            zoom: 16.0,
          ),
          onMapCreated: _onMapCreated,
          scrollGesturesEnabled: false,
          rotateGesturesEnabled: false,
          compassEnabled: false,
          myLocationEnabled: false,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: false,
        ),
        Center(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: MunchColors.white,
              borderRadius: BorderRadius.all(Radius.circular(22)),
            ),
            child: Icon(MunchIcons.map_place, color: MunchColors.primary500, size: 44),
          ),
        )
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
