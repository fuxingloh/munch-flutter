import 'package:flutter/widgets.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        color: MunchColors.whisper100,
      ),
      period: const Duration(milliseconds: 1300),
      baseColor: MunchColors.whisper100,
      highlightColor: MunchColors.whisper050,
    );
  }
}
