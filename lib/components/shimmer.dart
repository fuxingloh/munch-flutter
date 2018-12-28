import 'package:flutter/widgets.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:shimmer/shimmer.dart' as shim;

class Shimmer extends StatelessWidget {
  const Shimmer();

  @override
  Widget build(BuildContext context) {
    return shim.Shimmer.fromColors(
      child: Container(
        color: MunchColors.whisper200,
      ),
      period: const Duration(milliseconds: 1300),
      baseColor: MunchColors.whisper200,
      highlightColor: MunchColors.whisper100,
    );
  }
}
