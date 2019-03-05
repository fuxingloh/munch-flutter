import 'package:flutter/widgets.dart';

class MunchHorizontalSnap extends StatelessWidget {
  final WidgetBuilder sampleBuilder;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemWidth;

  final int initialPage;
  final double spacing;

  final EdgeInsets padding;

  const MunchHorizontalSnap({
    Key key,
    @required this.sampleBuilder,
    @required this.itemBuilder,
    @required this.itemCount,
    @required this.itemWidth,
    this.padding = const EdgeInsets.only(),
    this.initialPage = 0,
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final separator = SizedBox(width: spacing);

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final width = constraints.maxWidth;

      return Stack(
        children: <Widget>[
          Opacity(
            opacity: 0,
            child: Padding(
              padding: padding,
              child: Container(
                width: itemWidth,
                child: sampleBuilder(context),
              ),
            ),
          ),
          Positioned.fill(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const PageScrollPhysics(),
              controller: new PageController(
                initialPage: initialPage,
                viewportFraction: (itemWidth + spacing) / width,
              ),
              padding: padding,
              itemBuilder: (context, i) {
                return Container(
                  width: itemWidth,
                  child: itemBuilder(context, i),
                );
              },
              separatorBuilder: (c, i) => separator,
              itemCount: itemCount,
            ),
          )
        ],
      );
    });
  }
}
