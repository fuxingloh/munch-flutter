import 'package:flutter/material.dart';
import 'package:munch_app/styles/colors.dart';

class MButtonStyle {
  final Color textColor;
  final Color background;
  final Color borderColor;
  final double borderWidth;
  final double height;
  final double padding;
  final TextStyle textStyle;

  const MButtonStyle({
    this.textColor,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.height,
    this.padding,
    this.textStyle,
  });

  static const TextStyle _textStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  static const double _height = 40.0;
  static const double _padding = 24.0;

  static const double _smallHeight = 36.0;
  static const double _smallPadding = 18.0;
  static const TextStyle _smallTextStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w500);

  static const MButtonStyle border = MButtonStyle(
    textColor: MColors.black75,
    background: Color(0xFFFCFCFC),
    borderColor: MColors.black15,
    borderWidth: 1,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );

  static const MButtonStyle borderSmall = MButtonStyle(
    textColor: MColors.black75,
    background: Color(0xFFFCFCFC),
    borderColor: MColors.black15,
    borderWidth: 1,
    height: _smallHeight,
    padding: _smallPadding,
    textStyle: _smallTextStyle,
  );

  static const MButtonStyle primary = MButtonStyle(
    textColor: MColors.white,
    background: MColors.primary,
    borderColor: MColors.clear,
    borderWidth: 0,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );

  static const MButtonStyle primarySmall = MButtonStyle(
    textColor: MColors.white,
    background: MColors.primary,
    borderColor: MColors.clear,
    borderWidth: 0,
    height: _smallHeight,
    padding: _smallPadding,
    textStyle: _smallTextStyle,
  );

  static const MButtonStyle primaryOutline = MButtonStyle(
    textColor: MColors.primary,
    background: MColors.white,
    borderColor: MColors.primary,
    borderWidth: 1,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );

  static const MButtonStyle secondary = MButtonStyle(
    textColor: MColors.white,
    background: MColors.secondary,
    borderColor: MColors.clear,
    borderWidth: 0,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );

  static const MButtonStyle secondarySmall = MButtonStyle(
    textColor: MColors.white,
    background: MColors.secondary,
    borderColor: MColors.clear,
    borderWidth: 0,
    height: _smallHeight,
    padding: _smallPadding,
    textStyle: _smallTextStyle,
  );

  static const MButtonStyle secondaryOutline = MButtonStyle(
    textColor: MColors.secondary,
    background: MColors.white,
    borderColor: MColors.secondary,
    borderWidth: 1,
    height: _height,
    padding: _padding,
    textStyle: _textStyle,
  );
}

class MButton extends StatelessWidget {
  MButton.text(
    String text, {
    Key key,
    @required VoidCallback onPressed,
    MButtonStyle style = MButtonStyle.primary,
  }) : this(
          key: key,
          onPressed: onPressed,
          style: style,
          child: Text(text, style: style.textStyle),
        );

  MButton({
    Key key,
    this.onPressed,
    this.style = MButtonStyle.primary,
    this.child,
  }) : super(key: key);

  final VoidCallback onPressed;
  final MButtonStyle style;
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
