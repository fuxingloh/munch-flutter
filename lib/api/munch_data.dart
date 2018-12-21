import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:munch_app/api/file_api.dart';

part 'munch_data.g.dart';

@JsonSerializable()
class Place {
  Place(
    this.placeId,
    this.status,
    this.name,
    this.tags,
    this.phone,
    this.website,
    this.description,
    this.menu,
    this.price,
    this.location,
    this.hours,
    this.images,
    this.areas,
    this.createdMillis,
  );

  String placeId;
  PlaceStatus status;

  String name;
  List<Tag> tags;

  String phone;
  String website;
  String description;

  PlaceMenu menu;
  PlacePrice price;

  Location location;

  List<Hour> hours;
  List<Image> images;
  List<Area> areas;

  int createdMillis;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}

enum PlaceStatusType { open, renovation, closed, moved }

@JsonSerializable()
class PlaceStatus {
  PlaceStatus(this.type);

  PlaceStatusType type;

  factory PlaceStatus.fromJson(Map<String, dynamic> json) =>
      _$PlaceStatusFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceStatusToJson(this);
}

@JsonSerializable()
class PlaceMenu {
  PlaceMenu(this.url);

  String url;

  factory PlaceMenu.fromJson(Map<String, dynamic> json) =>
      _$PlaceMenuFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceMenuToJson(this);
}

@JsonSerializable()
class PlacePrice {
  PlacePrice(this.perPax);

  double perPax;

  factory PlacePrice.fromJson(Map<String, dynamic> json) =>
      _$PlacePriceFromJson(json);

  Map<String, dynamic> toJson() => _$PlacePriceToJson(this);
}

enum TagType { Food, Cuisine, Establishment, Amenities, Timing, Requirement }

@JsonSerializable()
class Tag {
  Tag(this.tagId, this.name, this.type);

  String tagId;
  String name;
  TagType type;

  static Tag restaurant = Tag(
    "216e7264-f4c9-40a4-86a2-d49793fb49c9",
    "Restaurant",
    TagType.Establishment,
  );

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}

enum LandmarkType { train, other }

@JsonSerializable()
class Landmark {
  Landmark(this.landmarkId, this.type, this.name, this.location);

  String landmarkId;
  LandmarkType type;
  String name;
  Location location;

  factory Landmark.fromJson(Map<String, dynamic> json) =>
      _$LandmarkFromJson(json);

  Map<String, dynamic> toJson() => _$LandmarkToJson(this);
}

enum AreaType {
  // TODO Test what happened with one removed
  City,
  Superset,
  Region,
  Cluster,
  Generated
}

@JsonSerializable()
class AreaCount {
  AreaCount(this.total);

  int total;

  factory AreaCount.fromJson(Map<String, dynamic> json) =>
      _$AreaCountFromJson(json);

  Map<String, dynamic> toJson() => _$AreaCountToJson(this);
}

@JsonSerializable()
class Area {
  Area(
    this.areaId,
    this.type,
    this.name,
    this.website,
    this.description,
    this.hours,
    this.images,
    this.counts,
    this.location,
  );

  String areaId;
  AreaType type;
  String name;

  String website;
  String description;

  List<Hour> hours;
  List<Image> images;
  AreaCount counts;

  Location location;

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

  Map<String, dynamic> toJson() => _$AreaToJson(this);
}

@JsonSerializable()
class Location {
  Location(
    this.address,
    this.street,
    this.unitNumber,
    this.neighbourhood,
    this.city,
    this.country,
    this.postcode,
    this.latLng,
    this.polygon,
    this.landmarks,
  );

  String address;
  String street;
  String unitNumber;
  String neighbourhood;

  String city;
  String country;
  String postcode;

  String latLng;
  LocationPolygon polygon;

  List<Landmark> landmarks;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class LocationPolygon {
  LocationPolygon(this.points);

  List<String> points;

  factory LocationPolygon.fromJson(Map<String, dynamic> json) =>
      _$LocationPolygonFromJson(json);

  Map<String, dynamic> toJson() => _$LocationPolygonToJson(this);
}

@JsonSerializable()
class Hour {
  Hour(this.day, this.open, this.close);

  HourDay day;
  String open;
  String close;

  factory Hour.fromJson(Map<String, dynamic> json) => _$HourFromJson(json);

  Map<String, dynamic> toJson() => _$HourToJson(this);
}

enum HourDay { mon, tue, wed, thu, fri, sat, sun }

HourDay _getToday() {
  var weekday = DateTime.now().weekday;
  switch (weekday) {
    case DateTime.monday:
      return HourDay.mon;
    case DateTime.tuesday:
      return HourDay.tue;
    case DateTime.wednesday:
      return HourDay.wed;
    case DateTime.thursday:
      return HourDay.thu;
    case DateTime.friday:
      return HourDay.fri;
    case DateTime.saturday:
      return HourDay.sat;
    case DateTime.sunday:
    default:
      return HourDay.sun;
  }
}

String _getTime(String time) {
  if (time.startsWith("23:59")) {
    return "Midnight";
  }

  if (time.startsWith("0") || time.startsWith("10") || time.startsWith("11")) {
    return time + "am";
  } else if (time.startsWith("12")) {
    return time + "pm";
  } else {
    var split = time.split(":");
    int hour = int.parse(split[0]) - 12;
    return "$hour:${split[1]}pm";
  }
}

class HourGrouped {
  List<Hour> hours;
  final HourDay _today = _getToday();
  Map<HourDay, String> _days;

  HourDay get today => _today;

  bool isToday(HourDay day) => _today == day;

  HourGrouped({@required this.hours}) {
    hours.sort((Hour a, Hour b) => a.open.compareTo(b.open));
    hours.forEach((Hour hour) {
      String time = _days[hour.day];
      if (time != null) {
        _days[hour.day] =
            "$time, ${_getTime(hour.open)} - ${_getTime(hour.close)}";
      } else {
        _days[hour.day] = "${_getTime(hour.open)} - ${_getTime(hour.close)}";
      }
    });
  }

  dynamic operator [](HourDay day) => _days[day] ?? "Closed";

  String get todayTime => "${getDayText(_today)}: ${this[_today]}";

  HourOpen isOpen({int opening = 30, int closing = 30}) {
    if (hours.isEmpty) {
      return HourOpen.none;
    }

    for (var hour in hours.where((h) => h.day == _today)) {
      if (isBetween(hour)) {
        if (!isBetween(hour, closing: closing)) {
          return HourOpen.closing;
        }
        return HourOpen.open;
      } else if (isBetween(hour, opening: opening)) {
        return HourOpen.opening;
      }
    }
    return HourOpen.closed;
  }

  String getDayText(HourDay day) {
    switch (day) {
      case HourDay.mon:
        return "MON";
      case HourDay.tue:
        return "TUE";
      case HourDay.wed:
        return "WED";
      case HourDay.thu:
        return "THU";
      case HourDay.fri:
        return "FRI";
      case HourDay.sat:
        return "SAT";
      case HourDay.sun:
        return "SUN";
    }
  }

  int timeAsInt(String time) {
    var split = time.split(":");
    return (int.parse(split[0]) * 60) + int.parse(split[1]);
  }

  bool isBetween(Hour hour, {int opening = 0, int closing = 0}) {
    var date = DateTime.now();
    var now = (date.hour * 60) + date.minute;

    var open = timeAsInt(hour.open);
    var close = timeAsInt(hour.close);

    if (close < open) {
      return open - opening <= now && now + closing <= 1440;
    }
    return open - opening <= now && now + closing <= close;
  }
}

enum HourOpen { open, opening, closed, closing, none }
