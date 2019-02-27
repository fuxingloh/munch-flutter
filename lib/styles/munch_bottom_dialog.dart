import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';

Future<T> showBottomDialog<T>({
  @required BuildContext context,
  @required String title,
  @required String message,
  String buttonTitle,
  VoidCallback buttonCallback,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return MunchBottomDialog(
        title: title,
        message: message,
        buttonTitle: buttonTitle,
        buttonCallback: buttonCallback,
      );
    },
  );
}

class MunchBottomDialog extends StatelessWidget {
  const MunchBottomDialog({
    Key key,
    this.title,
    this.message,
    this.buttonTitle,
    this.buttonCallback,
  }) : super(key: key);

  final String title;
  final String message;
  final String buttonTitle;
  final VoidCallback buttonCallback;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 24),
            child: Text(title, style: MTextStyle.h4),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
              child: Icon(
                MunchIcons.navigation_caret_down,
                size: 28,
              ),
            ),
          )
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Text(message),
      ),
    ];

    if (buttonTitle != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
        child: Container(
          alignment: Alignment.centerRight,
          child: MunchButton.text(
            buttonTitle,
            onPressed: () {
              Navigator.of(context).pop();
              buttonCallback();
            },
            style: MunchButtonStyle.secondary,
          ),
        ),
      ));
    }

    return Container(
      color: MunchColors.white,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
