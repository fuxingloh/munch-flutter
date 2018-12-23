import 'package:flutter/widgets.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        color: MColors.whisper100,
      ),
      period: const Duration(milliseconds: 1300),
      baseColor: MColors.whisper100,
      highlightColor: MColors.whisper050,
    );
  }
}
