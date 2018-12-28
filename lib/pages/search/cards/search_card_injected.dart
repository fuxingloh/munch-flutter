import 'package:flutter/material.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/search/search_page.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:munch_app/utils/munch_location.dart';

class SearchCardNoLocation extends SearchCardWidget {
  SearchCardNoLocation(SearchCard card) : super(card);

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("No Location", style: MTextStyle.h2),
        Container(
          margin: EdgeInsets.only(top: 24, bottom: 24),
          child: Text(
              "You have turned off your location service. Turn it on for better suggestion?",
              style: MTextStyle.regular),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: MunchButton.text("Enable Location",
              onPressed: () => onPressed(context)),
        )
      ],
    );
  }

  void onPressed(BuildContext context) {
    // Analytics.logEvent("enable_location", parameters: [:])
    MunchLocation.instance.request(force: true, permission: true).then((_) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Enabled location services, Do you want to refresh your search?'),
          action: SnackBarAction(
            label: "REFRESH",
            onPressed: () {
              SearchPage.state.reset();
            },
            textColor: Colors.white,
          ),
        ),
      );
    }, onError: (error) {
      MunchDialog.showError(context, error);
    });
  }
}
