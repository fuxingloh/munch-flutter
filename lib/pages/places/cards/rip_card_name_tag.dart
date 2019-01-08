import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/munch_tag_view.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/separators.dart';

class RIPCardClosed extends RIPCardWidget {
  RIPCardClosed(PlaceData data) : super(data);

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Text(
      "Permanently Closed",
      style: MTextStyle.h2.copyWith(color: MunchColors.close),
    );
  }

  static bool isAvailable(PlaceData data) {
    return data.place.status.type != PlaceStatusType.open;
  }
}

class RIPCardNameTag extends RIPCardWidget {
  RIPCardNameTag(PlaceData data)
      : super(
          data,
          margin: const RIPCardInsets.only(left: 0, right: 0),
        );

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text(data.place.name, style: MTextStyle.h1),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
          child: buildNeighbourhood(data),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: buildTags(data),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 24),
          child: SeparatorLine(),
        )
      ],
    );
  }

  Widget buildNeighbourhood(PlaceData data) {
    String text = data.place.location.neighbourhood ??
        data.place.location.street ??
        data.place.location.address;

    return Text(text, style: MTextStyle.h6, maxLines: 1);
  }

  MunchTagView buildTags(PlaceData data) {
    const MunchTagStyle style = MunchTagStyle(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: MunchColors.black75,
      ),
    );

    List<MunchTagData> tags = [];

    data.place.tags.forEach((tag) {
      if (tag.type == TagType.Timing) return;

      tags.add(MunchTagData(tag.name, style: style));
    });

    if (tags.isEmpty) {
      tags.add(MunchTagData("Restaurant", style: style));
    }

    return MunchTagView(tags: tags.take(8), spacing: 12);
  }

// override func didLoad(data: PlaceData!) {
//        self.nameLabel.text = data.place.name
//        self.locationLabel.text = data.place.location.neighbourhood ?? data.place.location.street ?? data.place.location.address
//
//        var tags = data.place.tags.filter({ (tag: Tag) in tag.type != .Timing })
//        if tags.isEmpty {
//            tags.append(Tag.restaurant)
//        }
//        self.tagView = RIPTagCollection(tags: tags.map({ $0.name }))
//
//        self.addSubview(nameLabel)
//        self.addSubview(locationLabel)
//        self.addSubview(tagView)
//        self.addSubview(separatorLine)
//
//        nameLabel.snp.makeConstraints { maker in
//            maker.left.right.equalTo(self).inset(24)
//            maker.top.equalTo(self).inset(12)
//            maker.height.equalTo(42 * nameLabel.countLines(width: UIScreen.main.bounds.width - 48)).priority(.high)
//        }
//
//        locationLabel.snp.makeConstraints { maker in
//            maker.left.right.equalTo(self).inset(24)
//            maker.top.equalTo(nameLabel.snp.bottom).inset(-4)
//        }
//
//        tagView.snp.makeConstraints { maker in
//            maker.left.right.equalTo(self).inset(24)
//            maker.top.equalTo(locationLabel.snp.bottom).inset(-16)
//        }
//
//        separatorLine.snp.makeConstraints { maker in
//            maker.left.right.equalTo(self)
//
//            maker.top.equalTo(tagView.snp.bottom).inset(-24)
//            maker.bottom.equalTo(self).inset(12)
//        }
//    }
}
