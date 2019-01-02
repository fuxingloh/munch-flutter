import 'package:flutter/material.dart';
import 'package:munch_app/pages/filter/filter_manager.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';

class FilterBottomView extends StatelessWidget {
  /// [count] is nullable, 0, and >0
  /// null represent loading
  /// 0 = no results
  /// >0 = contains results
  const FilterBottomView({
    Key key,
    @required this.onPressed,
    @required this.count,
  }) : super(key: key);

  final VoidCallback onPressed;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: elevation2,
      ),
      height: 72,
      width: double.infinity,
      child: _FilterBottomChild(count: count, onPressed: onPressed),
    );
  }
}

class _FilterBottomChild extends StatelessWidget {
  const _FilterBottomChild({
    Key key,
    this.count,
    this.onPressed,
  }) : super(key: key);

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MunchButton.text(_text, onPressed: onPressed, style: _style);
  }

  MunchButtonStyle get _style {
    return MunchButtonStyle(
      textColor: _has ? MunchColors.white : MunchColors.secondary700,
      background: _has ? MunchColors.secondary500 : MunchColors.secondary050,
      borderColor: _has ? MunchColors.secondary500 : MunchColors.secondary050,
      borderWidth: 1,
      height: 48,
      padding: 18,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  bool get _has {
    if (count == null) return false;
    return count > 0;
  }

  String get _text {
    if (count == null) {
      return "";
    } else if (count > 0) {
      return FilterManager.countTitle(count: count);
    } else {
      return "No Results";
    }
  }
}