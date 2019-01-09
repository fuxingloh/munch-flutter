import 'package:flutter/material.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/main.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SearchCardHomeDTJE extends SearchCardWidget {
  SearchCardHomeDTJE(SearchCard card)
      : super(card, margin: const EdgeInsets.only());

  @override
  Widget buildCard(BuildContext context) {
    return Container(
      color: MunchColors.saltpan100,
      padding: const SearchCardInsets.only(),
      child: _SearchCardChild(card: card),
    );
  }
}

class _SearchCardChild extends StatefulWidget {
  final SearchCard card;

  const _SearchCardChild({Key key, @required this.card}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchCardChildState();
}

class _SearchCardChildState extends State<_SearchCardChild> {
  bool subscribed = true;

  @override
  void initState() {
    super.initState();

    DTJESubscribeButton.validate();
    DTJESubscribeButton.update();
    DTJESubscribeButton.isSubscribed().then((subscribed) {
      setState(() {
        this.subscribed = subscribed;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Don't think, just eat", style: MTextStyle.h2),
              Text("5 suggestions, twice daily.", style: MTextStyle.h6)
            ],
          ),
          GestureDetector(
            onTap: () => onInfo(context),
            child: Icon(MunchIcons.search_card_home_dtje_info, size: 32),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 0),
        child: SearchDTJEList(card: widget.card),
      ),
    ];

    if (!subscribed) {
      children.add(Container(
        padding: const EdgeInsets.only(top: 12, bottom: 0),
        alignment: Alignment.centerRight,
        child: DTJESubscribeButton(),
      ));
    }

    return Column(children: children);
  }

  onInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => DTJEInfoPage(),
    );
  }
}

int get _minute {
  var now = DateTime.now();
  return (now.hour * 60) + now.minute;
}

class SearchDTJEList extends StatelessWidget {
  const SearchDTJEList({Key key, this.card}) : super(key: key);

  final SearchCard card;

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = [null, null, null, null, null];
    String text;

    final min = _minute;
    if (min < 690) {
      text =
          "Suggestions will be out at 11:30am.\n\nSubscribe to receive a notification when the suggestions are out!";
    } else if (min >= 690 && min < 960) {
      items = card['lunch'];
    } else if (min < 1080) {
      text =
          "Suggestions will be out at 6pm.\n\nSubscribe to receive a notification when the suggestions are out!";
    } else {
      items = card['dinner'];
    }

    List<Widget> children = [];
    for (var i = 0; i < items.length; i++) {
      children.add(DTJEItem(number: '${i + 1}.', label: items[i]));
    }

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: text != null ? Center(child: Text(text)) : Container(),
        ),
      ],
    );
  }
}

class DTJEItem extends StatelessWidget {
  const DTJEItem({Key key, this.number, this.label}) : super(key: key);

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 24,
            margin: const EdgeInsets.only(right: 8),
            child: Text(number, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          label != null ? Text(label) : Container(),
        ],
      ),
    );
  }
}

enum DTJENotification { Lunch, Dinner }

class DTJESubscribeButton extends StatefulWidget {
  @override
  DTJESubscribeButtonState createState() => DTJESubscribeButtonState();

  static validate() async {
//    if (!await isSubscribed()) return;
//
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//
//    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
//
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.getNotificationSettings { settings in
//            switch settings.authorizationStatus {
//            case .denied: fallthrough
//            case .notDetermined:
//                unsubscribe(notification: .dinner)
//                unsubscribe(notification: .lunch)
//
//            default:
//                return
//            }
//        }
//    }
  }

  static update() {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    class func update() {
//        if UserDefaults.standard.string(forKey: "SearchCardHomeDTJE.Notification.Version") == Notification.version {
//            return
//        }
//
//        // Changes in Notification setting
//        if Notification.lunch.isSubscribed {
//
//        }
//        if Notification.dinner.isSubscribed {
//
//        }
//
//        UserDefaults.standard.set(Notification.version, forKey: "SearchCardHomeDTJE.Notification.Version")
//    }
  }

  static subscribe(DTJENotification type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

    var specifics = NotificationDetails(
        AndroidNotificationDetails(
          'Notification.DTJE',
          "Don't think, just eat",
          '5 suggestions, twice daily.',
        ),
        IOSNotificationDetails());
    const String title = "Don't think just eat";

    switch (type) {
      case DTJENotification.Lunch:
        prefs.setBool('Notification.DTJE.Lunch', true);
        await plugin.showDailyAtTime(
            21033,
            title,
            'Your suggestions for lunch are ready.',
            Time(11, 30, 0),
            specifics);
        break;

      case DTJENotification.Dinner:
        prefs.setBool('Notification.DTJE.Dinner', true);
        await plugin.showDailyAtTime(
            21034,
            title,
            'Your suggestions for dinner are ready.',
            Time(18, 0, 0),
            specifics);
        break;
    }
  }

  static unsubscribe(DTJENotification type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    plugin.cancel(21033);
    plugin.cancel(21034);

    switch (type) {
      case DTJENotification.Lunch:
        prefs.setBool('Notification.DTJE.Lunch', false);
        break;

      case DTJENotification.Dinner:
        prefs.setBool('Notification.DTJE.Dinner', false);
        break;
    }
  }

  static Future<bool> isSubscribed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var l = prefs.get('Notification.DTJE.Lunch');
    var d = prefs.get('Notification.DTJE.Dinner');
    if (l != null && l is bool && l) return true;
    if (d != null && d is bool && d) return true;
    return false;
  }
}

class DTJESubscribeButtonState extends State<DTJESubscribeButton> {
  bool subscribed = true;

  @override
  void initState() {
    super.initState();

    DTJESubscribeButton.isSubscribed().then((subscribed) {
      setState(() {
        this.subscribed = subscribed;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MunchButton.text(
      subscribed ? "Subscribed" : "Subscribe",
      onPressed: onPressed,
      style: subscribed
          ? MunchButtonStyle.secondaryOutline
          : MunchButtonStyle.secondary,
    );
  }

  void onPressed() async {
    if (subscribed) {
      MunchDialog.showConfirm(context,
          content: "Unsubscribe from 'don't think, just eat'?", onPressed: () {
        firebaseAnalytics.logEvent(name: "dtje_unsubscribe");
        DTJESubscribeButton.unsubscribe(DTJENotification.Lunch);
        DTJESubscribeButton.unsubscribe(DTJENotification.Dinner);
        setState(() => subscribed = false);
      });
    } else {
      firebaseAnalytics.logEvent(name: "dtje_subscribe");
      DTJESubscribeButton.subscribe(DTJENotification.Lunch);
      DTJESubscribeButton.subscribe(DTJENotification.Dinner);
      setState(() => subscribed = true);
      MunchDialog.showOkay(
        context,
        title: 'Subscribed!',
        content:
            'You will receive a notification when the suggestions are out.',
      );
    }
  }
}

class DTJEInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          child: Text("DTJE Information", style: MTextStyle.h2),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Text(
                      """This feature provides you with 5 suggestions twice daily for lunch and dinner.
                  
Subscribe and receive notifications at 11:30 am and 6 pm on what to eat so you don’t have to think.
"""),
                ))
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin:
              const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
          child: DTJESubscribeButton(),
        ),
      ],
    );
  }
}
