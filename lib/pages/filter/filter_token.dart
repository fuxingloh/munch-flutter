import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/api/search_api.dart';

abstract class FilterToken {
  String get text;

  static List<FilterToken> getTokens(SearchQuery query) {
    List<FilterToken> tokens = [];

    tokens.add(FilterTokenLocation(query.filter.location));

    if (query.filter.price != null) {
      tokens.add(FilterTokenPrice(query.filter.price));
    }

    if (query.filter.hour != null) {
      tokens.add(FilterTokenHour(query.filter.hour));
    }

    query.filter.tags.forEach((tag) {
      tokens.add(FilterTokenTag(tag));
    });

    return tokens;
  }

  static String getText(List<FilterToken> tokens) {
    String text = '';

    if (tokens.length > 0) {
      text = tokens[0].text;
    }

    if (tokens.length > 1) {
      text += '  •  ';
      text = tokens[1].text;
    }

    var count = tokens.length - 2;
    if (count > 0) {
      text += '  •  ';
      text = "+$count";
    }

    return text;
  }
}

class FilterTokenTag extends FilterToken {
  FilterTokenTag(this.tag);

  final Tag tag;

  @override
  String get text => tag.name;
}

class FilterTokenPrice extends FilterToken {
  FilterTokenPrice(this.price);

  final SearchFilterPrice price;

  @override
  String get text {
    var min = price.min.toStringAsFixed(2);
    var max = price.max.toStringAsFixed(2);
    return "$min - $max";
  }
}

class FilterTokenHour extends FilterToken {
  FilterTokenHour(this.hour);

  final SearchFilterHour hour;

  @override
  String get text {
    switch (hour.type) {
      case SearchFilterHourType.OpenNow:
        return "Open Now";

      case SearchFilterHourType.OpenDay:
        return "${hour.day}: ${hour.open}-${hour.close}";
    }

    return "Hour";
  }
}

class FilterTokenLocation extends FilterToken {
  FilterTokenLocation(this.location);

  final SearchFilterLocation location;

  @override
  String get text {
    switch (location.type) {
      case SearchFilterLocationType.Anywhere:
        return "Anywhere";
      case SearchFilterLocationType.Nearby:
        return "Nearby";
      case SearchFilterLocationType.Between:
        return "EatBetween";
      case SearchFilterLocationType.Where:
        if (location.areas.isNotEmpty) return location.areas[0].name;
        return "Where";
    }
    return "Location";
  }
}
