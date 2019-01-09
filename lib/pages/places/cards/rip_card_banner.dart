import 'package:munch_app/api/file_api.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';

class RIPCardBanner extends RIPCardWidget {
  RIPCardBanner(PlaceData data)
      : super(
          data,
          margin: const RIPCardInsets.only(left: 0, right: 0, top: 0),
        );

  List<ImageSize> buildImages(PlaceData data) {
    if (data.place.images.isNotEmpty) {
      return data.place.images[0]?.sizes;
    }

    if (data.images.isNotEmpty) {
      return data.images[0]?.sizes;
    }

    return [];
  }

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    final height = (MediaQuery.of(context).size.height) * 0.38;

    return Container(
      height: height,
      child: ShimmerSizeImage(
        minHeight: height,
        sizes: buildImages(data),
      ),
    );
  }
}

// TODO Scroll TO

// private let moreButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .white
//        button.layer.borderColor = UIColor.ba10.cgColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 3
//
//        button.setTitle("SHOW IMAGES", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.titleLabel?.font = FontStyle.smallBold.font
//
//        button.setImage(UIImage(named: "RIP-Card-Image-More"), for: .normal)
//        button.tintColor = UIColor.black
//        button.imageEdgeInsets.left = -12
//        button.contentEdgeInsets.left = 18
//        button.contentEdgeInsets.right = 12
//
//        return button
//    }()
