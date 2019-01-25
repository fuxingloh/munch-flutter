import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/pages/places/cards/rip_card_award.dart';
import 'package:munch_app/pages/places/cards/rip_card_hour.dart';
import 'package:munch_app/pages/places/cards/rip_card_menu.dart';
import 'package:munch_app/styles/separators.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class RIPCardAboutDivider1 extends RIPCardWidget {
  RIPCardAboutDivider1(PlaceData data)
      : super(data, margin: EdgeInsets.only(top: 24, bottom: 24));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return const SeparatorLine();
  }

  static bool isAvailable(PlaceData data) {
    return RIPCardHour.isAvailable(data) ||
        RIPCardPrice.isAvailable(data) ||
        RIPCardPhone.isAvailable(data) ||
        RIPCardMenuWebsite.isAvailable(data);
  }
}

class RIPCardAboutDivider2 extends RIPCardWidget {
  RIPCardAboutDivider2(PlaceData data)
      : super(data, margin: EdgeInsets.only(top: 24, bottom: 12));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return const SeparatorLine();
  }

  static bool isAvailable(PlaceData data) {
    return RIPCardDescription.isAvailable(data) ||
        RIPCardAward.isAvailable(data) ||
        RIPCardMenuWebsite.isAvailable(data);
  }
}

class RIPCardDescription extends RIPCardWidget {
  RIPCardDescription(PlaceData data) : super(data);

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Text(data.place.description, maxLines: 4, style: MTextStyle.regular);
  }

  @override
  void onTap(BuildContext context, PlaceData data) {
    MunchAnalytic.logEvent("rip_click_about");

    showModalBottomSheet(
      context: context,
      builder: (context) => _RIPDescriptionModal(data: data),
    );
  }

  static bool isAvailable(PlaceData data) {
    return data.place.description != null;
  }
}

class _RIPDescriptionModal extends StatelessWidget {
  const _RIPDescriptionModal({Key key, this.data}) : super(key: key);

  final PlaceData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
          child: Text("About ${data.place.name}", style: MTextStyle.h2),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                    child: Text(data.place.description),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class RIPCardPhone extends RIPCardWidget {
  RIPCardPhone(PlaceData data) : super(data);

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return RIPLabelValue(label: "PHONE", text: data.place.phone);
  }

  @override
  void onTap(BuildContext context, PlaceData data) {
    MunchDialog.showConfirm(context, onPressed: () async {
      String url = 'tel:${data.place.phone}';
      if (await canLaunch(url)) {
        MunchAnalytic.logEvent("rip_click_phone");
        await launch(url);
      }
    }, content: "Call ${data.place.phone}?");
  }

  static bool isAvailable(PlaceData data) {
    return data.place.phone != null;
  }
}

class RIPCardPrice extends RIPCardWidget {
  RIPCardPrice(PlaceData data) : super(data);

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    String text = data.place.price.perPax.toStringAsFixed(1);
    return RIPLabelValue(label: "PRICE PER PERSON", text: '\$$text');
  }

  static bool isAvailable(PlaceData data) {
    return data.place.price?.perPax != null;
  }
}

class RIPCardWebsite extends RIPCardWidget {
  RIPCardWebsite(PlaceData data) : super(data);

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return RIPLabelValue(label: "WEBSITE", text: data.place.website);
  }

  static bool isAvailable(PlaceData data) {
    return data.place.website != null;
  }

  @override
  void onTap(BuildContext context, PlaceData data) {
    MunchDialog.showConfirm(context, onPressed: () async {
      String url = data.place.website;
      if (await canLaunch(url)) {
        MunchAnalytic.logEvent("rip_click_website");
        await launch(url);
      }
    }, content: "Open Website?");
  }
}

class RIPLabelValue extends StatelessWidget {
  final String label;
  final String text;

  const RIPLabelValue({Key key, this.label, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MunchColors.secondary700,
            ),
            maxLines: 1),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              text,
              style: MTextStyle.regular,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
