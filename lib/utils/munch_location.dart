import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong/latlong.dart';

class MunchLocation {
  static MunchLocation instance = MunchLocation();
  static const Distance _distance = Distance();

  static final int _expirySecond = 200;

  Position _lastPosition;
  DateTime _expiryDate = DateTime.now().add(Duration(seconds: _expirySecond));

  Position get lastPosition => _lastPosition;

  Future<bool> isEnabled() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    switch (permission) {
      case PermissionStatus.granted:
      case PermissionStatus.restricted:
        return true;

      default:
        return false;
    }
  }

  Future<String> request({bool force = false, bool permission = false}) async {
    if (await isEnabled()) {
      return _request(force: force);
    }

    if (permission) {
      await PermissionHandler()
          .shouldShowRequestPermissionRationale(PermissionGroup.location);
      return _request(force: force);
    }

    return null;
  }

  Future<String> _request({bool force = false}) async {
    Position lastPosition = _lastPosition;

    if (!force &&
        lastPosition != null &&
        DateTime.now().isBefore(_expiryDate)) {
      return "${lastPosition.latitude},${lastPosition.longitude}";
    }

    lastPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    _lastPosition = lastPosition;
    _expiryDate = DateTime.now().add(Duration(seconds: _expirySecond));

    return "${lastPosition.latitude},${lastPosition.longitude}";
  }

  ///
  /// distance in meters
  double distance(String latLng, double lat, double lng) {
    var split = latLng.split(",");
    LatLng ll = LatLng(double.parse(split[0]), double.parse(split[1]));
    return _distance.distance(ll, LatLng(lat, lng));
  }

  /// For < 10m, returns 10m
  /// For < 1km format metres in multiple of 50s
  /// For < 100km format with 1 precision floating double
  /// For > 100km format in km
  String distanceAsMetric(String latLng) {
    Position position = _lastPosition;
    if (position == null) return null;

    var meter = distance(latLng, position.latitude, position.longitude);
    if (meter <= 10.0) {
      return "10m";
    } else if (meter <= 50.0) {
      return "50m";
    } else if (meter < 1000) {
      int m = (meter ~/ 50 * 50);
      if (m == 1000) {
        return "1.0km";
      } else {
        return "${m}m";
      }
    } else if (meter < 100000) {
      return "${(meter / 1000).toStringAsFixed(1)}km";
    } else {
      return "${meter ~/ 1000}km";
    }
  }

  String distanceAsDuration(String latLng, String toLatLng) {
    var split = toLatLng.split(",");
    var meter =
        distance(latLng, double.parse(split[0]), double.parse(split[1]));
    int min = meter ~/ 70;

    if (min <= 1) {
      return "1 min";
    }

    return "$min min";
  }
}
