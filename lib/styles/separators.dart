import 'package:flutter/material.dart';
import 'package:munch_app/styles/colors.dart';

class SeparatorLine extends StatelessWidget {
  const SeparatorLine();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 0.5,
      width: double.infinity,
      child: const DecoratedBox(
        decoration: const BoxDecoration(color: MunchColors.black10),
      ),
    );
  }
}
