import 'package:flutter/material.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/separators.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:url_launcher/url_launcher.dart';

class RIPCardSuggestEdit extends RIPCardWidget {
  RIPCardSuggestEdit(PlaceData data)
      : super(data, margin: const RIPCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(MunchIcons.rip_edit, size: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text("Suggest Edits"),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: const SeparatorLine(),
        )
      ],
    );
  }

  @override
  void onTap(BuildContext context, PlaceData data) {
    onSuggestEdit(context, data.place);
  }
}

void onSuggestEdit(BuildContext context, Place place) {
  Authentication.instance.requireAuthentication(context).then((state) {
    if (state == AuthenticationState.loggedIn) {
      return Authentication.instance.getCustomToken();
    } else {
      return Future.value(null);
    }
  }).catchError((error) {
    return showDialog(
      context: context,
      builder: (context) => MunchDialog.error(context,
          title: 'Authentication Error', content: error),
    );
  }).then((token) {
    if (token == null) return null;
    _openSuggestEdit(token, place);
  });
}

void _openSuggestEdit(String token, Place place) async {
  final uri = Uri(scheme: 'https', host: 'www.munch.app', path: '/authenticate', queryParameters: {
    'token': token,
    'redirect': '/places/suggest?placeId=${place.placeId}',
  });

  String url = uri.toString();
  if (await canLaunch(url)) {
    MunchAnalytic.logEvent("rip_click_suggest_edit");
    await launch(url);
  }
}