import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:url_launcher/url_launcher.dart';

class RIPCardMenuWebsite extends RIPCardWidget {
  RIPCardMenuWebsite(PlaceData data) : super(data);

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Container(
      alignment: Alignment.centerLeft,
      child: MunchButton.text("Website Menu", onPressed: () async {
        String url = data.place.menu.url;
        if (await canLaunch(url)) {
          MunchAnalytic.logEvent("rip_click_menu_website");
          await launch(url);
        }
      }, style: MunchButtonStyle.border),
    );
  }

  static bool isAvailable(PlaceData data) {
    return data.place.menu?.url != null;
  }
}
