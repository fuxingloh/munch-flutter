import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

enum UserDefaultsKey {
  globalResignActiveDate,
  notifyFeedWelcome,
  notifyShareFeedbackV1,
  countOpenApp,
  countViewRip,
}

class UserDefaults {
  static UserDefaults instance = UserDefaults();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static String _name(UserDefaultsKey key) {
    switch (key) {
      case UserDefaultsKey.globalResignActiveDate:
        return "global.ResignActiveDate";
      case UserDefaultsKey.notifyFeedWelcome:
        return "notify.FeedWelcome";
      case UserDefaultsKey.notifyShareFeedbackV1:
        return "notify.ShareFeedbackV1";
      case UserDefaultsKey.countOpenApp:
        return "count.OpenApp";
      case UserDefaultsKey.countViewRip:
        return "count.ViewRip";
    }

    return "NotFound";
  }

  void clear() async {
    final SharedPreferences prefs = await _prefs;

    for (var key in UserDefaultsKey.values) {
      prefs.remove(_name(key));
    }
  }

  void notify(UserDefaultsKey key, VoidCallback closure) async {
    String name = _name(key);

    final SharedPreferences prefs = await _prefs;
    final bool notified = prefs.getBool(name) ?? false;
    if (notified) return;

    prefs.setBool(name, true);
    closure();
  }

  Future count(UserDefaultsKey key) async {
    final SharedPreferences prefs = await _prefs;

    String name = _name(key);
    final int count = (prefs.getInt(name) ?? 0) + 1;
    prefs.setInt(name, count);
  }

  Future<int> getCount(UserDefaultsKey key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(_name(key)) ?? 0;
  }
}
