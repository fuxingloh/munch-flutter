import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class RIPCardMenuWebsite extends RIPCardWidget {
  RIPCardMenuWebsite(PlaceData data) : super(data);

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return MunchButton.text("Website Menu", onPressed: () async {
      String url = data.place.menu.url;
      if (await canLaunch(url)) {
        await launch(url);
      }
    });
  }

  static bool isAvailable(PlaceData data) {
    return data.place.menu?.url != null;
  }
}