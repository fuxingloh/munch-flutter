import 'package:flutter/widgets.dart';

class MunchHorizontalSnap extends StatelessWidget {
  final WidgetBuilder sampleBuilder;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  final int initialPage;
  final double spacing;

  final EdgeInsets padding;

  const MunchHorizontalSnap({
    Key key,
    @required this.sampleBuilder,
    @required this.itemBuilder,
    @required this.itemCount,
    this.padding = const EdgeInsets.only(),
    this.initialPage = 0,
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final separator = SizedBox(width: spacing);

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final width = constraints.maxWidth;
      final itemWidth = width - (padding.horizontal - spacing);

      return Stack(
        children: <Widget>[
          Opacity(
            opacity: 0,
            child: Padding(
              padding: padding,
              child: sampleBuilder(context),
            ),
          ),
          Positioned.fill(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const PageScrollPhysics(),
              controller: new PageController(
                initialPage: initialPage,
                viewportFraction: itemWidth / width,
              ),
              padding: padding,
              itemBuilder: itemBuilder,
              separatorBuilder: (c, i) => separator,
              itemCount: itemCount,
            ),
          )
        ],
      );
    });
  }
}
