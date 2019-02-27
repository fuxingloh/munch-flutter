import 'package:flutter/widgets.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/texts.dart';

class FeedHeaderBar extends StatelessWidget {
  final String name;
  final VoidCallback onDiscover;
  final VoidCallback onCancel;

  const FeedHeaderBar({Key key, this.name, this.onDiscover, this.onCancel}) : super(key: key);

  String get text {
    if (name != null) {
      return name;
    }

    return "Discover by location";
  }

  Color get color {
    if (name != null) {
      return MunchColors.black85;
    }

    return MunchColors.black60;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: MunchColors.white.withOpacity(0.97),
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
          child: Container(
            decoration: const BoxDecoration(
              color: MunchColors.whisper100,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: onDiscover,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                      child: Text(text, style: MTextStyle.h6.copyWith(color: color), maxLines: 1),
                    ),
                  ),
                ),
                name == null ? Container() : _FeedHeaderCancel(onCancel: onCancel)
                // Close
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FeedHeaderCancel extends StatelessWidget {
  final VoidCallback onCancel;

  const _FeedHeaderCancel({Key key, this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCancel,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Icon(
          MunchIcons.navigation_cancel,
          size: 14,
        ),
      ),
    );
  }
}
