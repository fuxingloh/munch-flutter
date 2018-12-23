import 'package:flutter/widgets.dart';
import 'package:munch_app/styles/colors.dart';

class MunchTagView extends StatelessWidget {
  const MunchTagView({
    Key key,
    this.tags,
    this.count = 6,
    this.spacing = 8,
  }) : super(key: key);

  final List<MunchTagData> tags;
  final int count;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: tags.map((data) {
          return _MunchTagViewCell(data: data);
        }).toList(growable: false),
      ),
    );
  }
}

class MunchTagData {
  const MunchTagData(this.text, {this.style = const MunchTagStyle()});

  final String text;
  final MunchTagStyle style;
}

class MunchTagStyle {
  const MunchTagStyle({
    this.textStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: MColors.black85,
    ),
    this.padding = const EdgeInsets.only(
      top: 4.5,
      bottom: 4.5,
      left: 8,
      right: 8,
    ),
    this.backgroundColor = MColors.whisper100,
  });

  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
}

class _MunchTagViewCell extends StatelessWidget {
  const _MunchTagViewCell({Key key, @required this.data}) : super(key: key);

  final MunchTagData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        color: data.style.backgroundColor,
        padding: data.style.padding,
        child: Text(data.text, style: data.style.textStyle),
      ),
    );
  }
}
