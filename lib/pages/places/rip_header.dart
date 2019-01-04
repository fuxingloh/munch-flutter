import 'package:flutter/material.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/api/places_api.dart';
import 'package:munch_app/components/bottom_sheet.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:share/share.dart';

class RIPHeader extends StatefulWidget {
  RIPHeader({this.clear, this.placeData});

  final bool clear;
  final PlaceData placeData;

  @override
  RIPHeaderState createState() => RIPHeaderState();
}

class RIPHeaderState extends State<RIPHeader> {
  PersistentBottomSheetController _controller;

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
        widget.placeData?.place?.name ?? "",
        textAlign: TextAlign.center,
        style: MTextStyle.navHeader.copyWith(
            color: widget.clear ? MunchColors.white : MunchColors.black),
      ),
      backgroundColor: MunchColors.clear,
      elevation: 0,
      iconTheme: IconThemeData(
          color: widget.clear ? MunchColors.white : MunchColors.black),
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
    _controller = showBottomSheet(
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
    _controller.close();
  }

  void onShare() {
    String placeId = widget.placeData?.place?.placeId ?? '';
    Share.share("https://www.munch.app/places/$placeId");
    _controller.close();
  }

  void onSuggestEdit() {
    Authentication.instance.requireAuthentication(context).then((state) {
      if (state == AuthenticationState.loggedIn) {
        setState(() {
          // TODO
          _controller.close();
        });
      }
    }).catchError((error) {
      return showDialog(
        context: context,
        builder: (context) => MunchDialog.error(context,
            title: 'Authentication Error', content: error),
      );
    });
  }
}