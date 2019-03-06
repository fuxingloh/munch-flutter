import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/separators.dart';

class RIPCardPreference extends RIPCardWidget {
  RIPCardPreference(PlaceData data) : super(data, margin: const RIPCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text(
            "Tastebud Preference Note",
            style: MTextStyle.h2.copyWith(color: MunchColors.error),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 24, left: 24, right: 24),
          child: Text(
            'We thought you should know, this place does not fit the requirements of your permanent filter.',
            style: MTextStyle.regular,
          ),
        ),
        const SeparatorLine(),
      ],
    );
  }

  static bool isAvailable(PlaceData data) {
    var preference = UserSearchPreference.instance;
    if (preference == null) return false;
    if (preference.requirements.isEmpty) return false;

    bool any = data.place.tags.any((placeTag) {
      return preference.requirements.any((tag) {
        return placeTag.tagId == tag.tagId;
      });
    });
    return !any;
  }
}