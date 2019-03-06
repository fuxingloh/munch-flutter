import 'package:munch_app/components/shimmer.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';

class RIPCardLoadingBanner extends RIPCardWidget {
  const RIPCardLoadingBanner()
      : super(null,
            margin: const RIPCardInsets.only(left: 0.0, right: 0.0, top: 0.0));

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
