import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch_app/components/shimmer.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';

class RIPCardLoadingBanner extends RIPCardWidget {
  const RIPCardLoadingBanner()
      : super(null,
            margin: const RIPCardInsets.only(left: 0, right: 0, top: 0));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    final height = (MediaQuery.of(context).size.height) * 0.33;
    return SizedBox(
      height: height,
      child: Shimmer(),
    );
  }
}

class RIPCardLoadingName extends RIPCardWidget {
  const RIPCardLoadingName() : super(null);

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return SizedBox(
      height: 40,
      child: Shimmer(),
    );
  }
}

class RIPCardLoadingGallery extends RIPCardWidget {
  const RIPCardLoadingGallery({this.loading = false}) : super(null);

  final bool loading;

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    if (loading) {
      return Center(
        child: SpinKitThreeBounce(
          color: MunchColors.secondary500,
          size: 24.0,
        ),
      );
    } else {
      return SizedBox(height: 24);
    }
  }
}
