import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/utils/facebook_app_events.dart';

final FirebaseAnalytics _firebase = FirebaseAnalytics();
final FacebookAppEvents _facebook = FacebookAppEvents();

class MunchAnalytic {
  static void clearUserData() {
    _firebase.setUserId(null);
    _facebook.clearUserData();
    debugPrint('MunchAnalytic clearUserData');
  }

  static void setUserId(String userId) {
    _firebase.setUserId(userId);
    _facebook.setUserId(userId);
    debugPrint('MunchAnalytic setUserId: $userId');
  }

  static void setScreen(String name) {
    _firebase.setCurrentScreen(screenName: name);
    _facebook.logEvent(name: "setScreen", parameters: {"name": name});
    debugPrint('MunchAnalytic setScreen: $name');
  }

  static void logEvent(String name, {Map<String, dynamic> parameters}) {
    _firebase.logEvent(name: name, parameters: parameters);
    _facebook.logEvent(name: name, parameters: parameters);
    debugPrint('MunchAnalytic logEvent: $name, p: ${parameters?.length ?? 0}');
  }

  static Map<String, dynamic> _searchQueryParameters(SearchQuery searchQuery) {
    Map<String, dynamic> parameters = {"feature": searchQuery.feature.toString()};

    if (searchQuery.feature == SearchFeature.Search) {
      parameters['tag_count'] = searchQuery.filter.tags.length;
      parameters['price_selected'] = searchQuery.filter.price != null;

      String type = SearchQuery.getHourTypeName(searchQuery);
      if (type != null) {
        parameters['hour_type'] = type;
      }

      parameters['location_type'] = SearchQuery.getLocationTypeName(searchQuery);
      if (searchQuery.filter.location.type == SearchFilterLocationType.Between) {
        parameters["location_count"] = searchQuery.filter.location.points.length;
      } else {
        parameters["location_count"] = searchQuery.filter.location.areas.length;
      }
    }

    return parameters;
  }

  static void logSearchQuery({@required SearchQuery searchQuery}) {
    final parameters = _searchQueryParameters(searchQuery);
    MunchAnalytic.logEvent("search_query", parameters: parameters);

    if (searchQuery.feature == SearchFeature.Search) {
      if (searchQuery.filter.location.type == SearchFilterLocationType.Between) {
        MunchAnalytic.logEvent("search_query_eat_between", parameters: {
          "count": searchQuery.filter.location.points.length,
        });
      }
    }
  }

  static void logSearchQueryAppend({
    @required SearchQuery searchQuery,
    @required List<SearchCard> cards,
    @required int page,
  }) {
    if (cards.isEmpty) return;

    MunchAnalytic.logEvent("search_query_append", parameters: {
      "feature": SearchQuery.getFeatureName(searchQuery),
      "count": cards.length,
      "page": page,
    });
  }

  static void logSearchQueryShare({
    @required SearchQuery searchQuery,
    @required String trigger,
  }) {
    var parameters = _searchQueryParameters(searchQuery);
    parameters['trigger'] = trigger;
    MunchAnalytic.logEvent("search_query_share", parameters: parameters);
  }
}

class MunchAnalyticNavigatorObserver extends NavigatorObserver {
  void _send(PageRoute route) {
    if (route.settings.name != null) {
      MunchAnalytic.setScreen(route.settings.name);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _send(route);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _send(previousRoute);
    }
  }
}
