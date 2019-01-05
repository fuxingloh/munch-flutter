import 'package:munch_app/api/collection_api.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';

class RIPCardAward extends RIPCardWidget {
  RIPCardAward(PlaceData data)
      : super(data, margin: const RIPCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 24, right: 24),
        itemBuilder: (c, i) => _RIPCardTile(item: data.awards[i],
          ),
        itemCount: data.awards.length,
        separatorBuilder: (c, i) => SizedBox(width: 12),
      ),
    );
  }

  static bool isAvailable(PlaceData data) {
    return data.awards.isNotEmpty;
  }
}

class _RIPCardTile extends StatelessWidget {
  const _RIPCardTile({Key key, this.item}) : super(key: key);

  final UserPlaceCollectionItem item;

  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 168,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 8, right: 8),
      decoration: const BoxDecoration(
          color: MunchColors.whisper100,
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: Text(
        item.award?.name ?? "",
        maxLines: 2,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: MunchColors.black75,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}