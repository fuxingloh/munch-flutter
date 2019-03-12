import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/pages/contents/content_page.dart';
import 'package:munch_app/pages/contents/items/content_item.dart';
import 'package:munch_app/pages/places/place_card.dart';

class ContentPlace extends ContentItemWidget {
  ContentPlace(CreatorContentItem item, ContentPageState state) : super(item, state);

  Place get place => state.places[placeId];

  String get placeId => this.item.body['placeId'];

  String get placeName => this.item.body['placeName'];

  String get imageCreditName {
    if (place == null) return null;
    if (place.images.isEmpty) return null;
    return place.images[0]?.profile?.name;
  }

  @override
  Widget buildCard(BuildContext context, ContentPageState state, CreatorContentItem item) {
    if (place == null) {
      return Container();
    }

    return Column(
      children: <Widget>[
        PlaceCard(
          place: place,
        )
      ],
    );
  }
}
