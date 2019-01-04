import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munch_app/styles/colors.dart';

class MunchBottomSheet extends StatelessWidget {
  final List<MunchBottomSheetTile> children;

  const MunchBottomSheet({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: MunchColors.black15, width: 1),
          bottom: BorderSide(color: MunchColors.black15, width: 1),
        ),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class MunchBottomSheetTile extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Icon icon;

  const MunchBottomSheetTile({
    Key key,
    this.onPressed,
    this.child,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (icon != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(right: 16),
        child: icon,
      ));
    }

    children.add(child);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
        child: Row(children: children),
      ),
    );
  }
}
