import 'package:flutter/material.dart';
import 'package:munch_app/api/places_api.dart';
import 'package:munch_app/components/bottom_sheet.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:share/share.dart';
import 'package:munch_app/pages/places/cards/rip_card_suggest.dart' as SuggestCard;

class RIPHeader extends StatelessWidget {
  RIPHeader({this.clear, this.placeData, this.color = MunchColors.white});

  final Color color;
  final bool clear;
  final PlaceData placeData;

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
        placeData?.place?.name ?? "",
        textAlign: TextAlign.center,
        style: MTextStyle.navHeader.copyWith(color: clear ? color : MunchColors.black),
      ),
      backgroundColor: MunchColors.clear,
      elevation: 0,
      iconTheme: IconThemeData(color: clear ? color : MunchColors.black),
      actions: <Widget>[
        IconButton(
          icon: Icon(MunchIcons.navigation_more),
          onPressed: () => onMore(context),
        )
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: clear ? MunchColors.clear : MunchColors.white,
        boxShadow: clear ? null : elevation1,
      ),
      child: SafeArea(
        child: SizedBox.fromSize(
          child: appBar,
          size: appBar.preferredSize,
        ),
      ),
    );
  }

  void onMore(BuildContext context) {
    MunchAnalytic.logEvent("rip_click_more");

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MunchBottomSheet(
          children: [
            MunchBottomSheetTile(
              onPressed: () => onSuggestEdit(context),
              icon: Icon(Icons.edit),
              child: Text("Suggest Edits"),
            ),
            MunchBottomSheetTile(
              onPressed: () => onShare(context),
              icon: Icon(Icons.share),
              child: Text("Share"),
            ),
            MunchBottomSheetTile(
              onPressed: () => onCancel(context),
              icon: Icon(Icons.close),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onShare(BuildContext context) {
    String placeId = placeData?.place?.placeId ?? '';
    Share.share("https://www.munch.app/places/$placeId");
    MunchAnalytic.logEvent("rip_share");
    Navigator.of(context).pop();
  }

  void onSuggestEdit(BuildContext context) {
    SuggestCard.onSuggestEdit(context, placeData.place);
  }
}
