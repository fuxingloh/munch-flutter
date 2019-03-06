import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch_app/styles/colors.dart';

class ContentLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 48, bottom: 48),
      child: SpinKitThreeBounce(
        color: MunchColors.secondary500,
        size: 24.0,
      ),
    );
  }
}
