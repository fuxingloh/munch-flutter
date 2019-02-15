import 'package:flutter/material.dart';
import 'package:munch_app/styles/colors.dart';

class MunchButtonStyle {
  final Color textColor;
  final Color background;
  final Color borderColor;
  final double borderWidth;
  final double height;
  final double padding;
  final TextStyle textStyle;

  const MunchButtonStyle({
    this.textColor,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.height,
    this.padding,
    this.textStyle,
  });

  MunchButtonStyle copyWith({
    Color textColor,
    Color background,
    Color borderColor,
    double borderWidth,
    double height,
    double padding,
    TextStyle textStyle,
  }) {
    return MunchButtonStyle(
      textColor: textColor ?? this.textColor,
      background: background ?? this.background,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  static const TextStyle _textStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
  static const double _height = 40.0;
  static const double _padding = 24.0;

  static const double _smallHeight = 36.0;
  static const double _smallPadding = 18.0;
  static const TextStyle _smallTextStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

  static const MunchButtonStyle border = MunchButtonStyle(
    textColor: MunchColors.black75,
    background: Color(0xFFFCFCFC),
    borderColor: MunchColors.black15,
    borderWidth: 1,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );

  static const MunchButtonStyle disabled = MunchButtonStyle(
    textColor: MunchColors.black20,
    background: Color(0xFFFCFCFC),
    borderColor: MunchColors.black15,
    borderWidth: 1,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );

  static const MunchButtonStyle borderSmall = MunchButtonStyle(
    textColor: MunchColors.black75,
    background: Color(0xFFFCFCFC),
    borderColor: MunchColors.black15,
    borderWidth: 1,
    height: _smallHeight,
    padding: _smallPadding,
    textStyle: _smallTextStyle,
  );

  static const MunchButtonStyle primary = MunchButtonStyle(
    textColor: MunchColors.white,
    background: MunchColors.primary500,
    borderColor: MunchColors.primary500,
    borderWidth: 1,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );

  static const MunchButtonStyle primarySmall = MunchButtonStyle(
    textColor: MunchColors.white,
    background: MunchColors.primary500,
    borderColor: MunchColors.primary500,
    borderWidth: 1,
    height: _smallHeight,
    padding: _smallPadding,
    textStyle: _smallTextStyle,
  );

  static const MunchButtonStyle primaryOutline = MunchButtonStyle(
    textColor: MunchColors.primary500,
    background: MunchColors.white,
    borderColor: MunchColors.primary500,
    borderWidth: 1,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );

  static const MunchButtonStyle secondary = MunchButtonStyle(
    textColor: MunchColors.white,
    background: MunchColors.secondary500,
    borderColor: MunchColors.secondary500,
    borderWidth: 1,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );

  static const MunchButtonStyle secondarySmall = MunchButtonStyle(
    textColor: MunchColors.white,
    background: MunchColors.secondary500,
    borderColor: MunchColors.secondary500,
    borderWidth: 1,
    height: _smallHeight,
    padding: _smallPadding,
    textStyle: _smallTextStyle,
  );

  static const MunchButtonStyle secondaryOutline = MunchButtonStyle(
    textColor: MunchColors.secondary700,
    background: MunchColors.white,
    borderColor: MunchColors.secondary700,
    borderWidth: 1,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );
}

class MunchButton extends StatelessWidget {
  MunchButton.text(
    String text, {
    Key key,
    @required VoidCallback onPressed,
    MunchButtonStyle style = MunchButtonStyle.secondary,
  }) : this(
          key: key,
          onPressed: onPressed,
          style: style,
          child: Text(
            text,
            style: style.textStyle.copyWith(color: style.textColor),
            overflow: TextOverflow.ellipsis,
          ),
        );

  MunchButton({
    Key key,
    this.onPressed,
    this.style = MunchButtonStyle.secondary,
    this.child,
  }) : super(key: key);

  final VoidCallback onPressed;
  final MunchButtonStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: style.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: style.borderColor, width: style.borderWidth),
      ),
      child: MaterialButton(
        elevation: 0,
        onPressed: onPressed,
        color: style.background,
        child: child,
        textColor: style.textColor,
        padding: EdgeInsets.fromLTRB(style.padding, 0, style.padding, 0),
      ),
    );
  }
}
