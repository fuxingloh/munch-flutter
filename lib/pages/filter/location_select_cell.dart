import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch_app/styles/munch.dart';

class SearchLocationIconTextCell extends StatelessWidget {
  const SearchLocationIconTextCell({Key key, this.left, this.text, this.right, this.rightPressed}) : super(key: key);

  final IconData left;
  final String text;
  final IconData right;
  final VoidCallback rightPressed;

  @override
  Widget build(BuildContext context) {
    final children = [
      Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 16),
        child: Icon(left, size: 24),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: (right != null) ? 0 : 24),
          child: Text(text, style: MTextStyle.regular, maxLines: 1),
        ),
      )
    ];

    if (right != null) {
      children.add(GestureDetector(
        onTap: rightPressed,
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Icon(right, size: 24),
        ),
      ));
    }

    return Row(
      children: children,
    );
  }
}

class SearchLocationHeaderCell extends StatelessWidget {
  final String title;

  const SearchLocationHeaderCell({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 8),
      child: Text(title, style: MTextStyle.h4),
    );
  }
}

class SearchLocationTextCell extends StatelessWidget {
  const SearchLocationTextCell({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
      child: Text(
        text,
        style: MTextStyle.regular,
        maxLines: 1,
      ),
    );
  }
}

class SearchLocationLoadingCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SpinKitThreeBounce(
        color: MunchColors.secondary500,
        size: 24.0,
      ),
    );
  }
}
