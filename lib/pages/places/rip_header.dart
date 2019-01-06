import 'package:flutter/material.dart';
import 'package:munch_app/api/places_api.dart';
import 'package:munch_app/components/bottom_sheet.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:share/share.dart';
import 'package:munch_app/pages/places/cards/rip_card_suggest.dart' as SuggestCard;

class RIPHeader extends StatefulWidget {
  RIPHeader({this.clear, this.placeData, this.color = MunchColors.white});

  final Color color;
  final bool clear;
  final PlaceData placeData;

  @override
  RIPHeaderState createState() => RIPHeaderState();
}

class RIPHeaderState extends State<RIPHeader> {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
        widget.placeData?.place?.name ?? "",
        textAlign: TextAlign.center,
        style: MTextStyle.navHeader.copyWith(
            color: widget.clear ? widget.color : MunchColors.black),
      ),
      backgroundColor: MunchColors.clear,
      elevation: 0,
      iconTheme: IconThemeData(
          color: widget.clear ? widget.color : MunchColors.black),
      actions: <Widget>[
        IconButton(
          icon: Icon(MunchIcons.navigation_more),
          onPressed: () => onMore(context),
        )
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: widget.clear ? MunchColors.clear : MunchColors.white,
        boxShadow: widget.clear ? null : elevation1,
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
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MunchBottomSheet(
          children: [
            MunchBottomSheetTile(
              onPressed: onSuggestEdit,
              icon: Icon(Icons.edit),
              child: Text("Suggest Edits"),
            ),
            MunchBottomSheetTile(
              onPressed: onShare,
              icon: Icon(Icons.share),
              child: Text("Share"),
            ),
            MunchBottomSheetTile(
              onPressed: onCancel,
              icon: Icon(Icons.close),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  void onShare() {
    String placeId = widget.placeData?.place?.placeId ?? '';
    Share.share("https://www.munch.app/places/$placeId");
    Navigator.of(context).pop();
  }

  void onSuggestEdit() {
    SuggestCard.onSuggestEdit(context, widget.placeData.place);
  }
}