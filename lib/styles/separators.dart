import 'package:flutter/material.dart';
import 'package:munch_app/styles/colors.dart';

class SeparatorWidget extends StatelessWidget {
  const SeparatorWidget();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 0.5,
      child: const DecoratedBox(
        decoration: const BoxDecoration(color: MColors.black10),
      ),
    );
  }
}