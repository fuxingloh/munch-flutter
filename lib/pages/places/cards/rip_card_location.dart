import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/separators.dart';

class RIPCardLocation extends RIPCardWidget {
  RIPCardLocation(PlaceData data)
      : super(data, margin: const RIPCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Text("Location", style: MTextStyle.h2),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 16),
          child: Text(data.place.location.address, style: MTextStyle.regular),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 24),
          child: SeparatorLine(),
        )
      ],
    );
  }

  @override
  void onTap(BuildContext context) {
//        let mapController = RIPMapController(controller: controller)
//        self.controller.navigationController?.pushViewController(mapController, animated: true)
  }
}

// class RIPLocationCard: RIPCard {
//    static let height: CGFloat = 200
//
//    private let mapView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 4
//        return imageView
//    }()
//    private let pinImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "RIP-Card-PlacePin")
//        return imageView
//    }()
//

//        addressLabel.snp.makeConstraints { maker in
//            maker.left.right.equalTo(self).inset(24)
//            maker.top.equalTo(label.snp.bottom).inset(-12)
//            maker.height.equalTo(AddressLabel.height(location: data.place.location)).priority(.high)
//        }
//
//        mapView.snp.makeConstraints { maker in
//            maker.left.right.equalTo(self).inset(24)
//            maker.height.equalTo(RIPLocationCard.height).priority(999)
//            maker.top.equalTo(addressLabel.snp.bottom).inset(-24)
//        }
//
//        pinImageView.snp.makeConstraints { maker in
//            maker.center.equalTo(mapView)
//        }
//
//        separatorLine.snp.makeConstraints { maker in
//            maker.left.right.equalTo(self)
//
//            maker.top.equalTo(mapView.snp.bottom).inset(-24)
//            maker.bottom.equalTo(self).inset(12)
//        }
//    }
//
//    override func willDisplay(data: PlaceData!) {
//        self.addressLabel.location = data.place.location
//
//        if let latLng = data.place.location.latLng, let coordinate = CLLocation(latLng: latLng)?.coordinate {
//            var region = MKCoordinateRegion()
//            region.center.latitude = coordinate.latitude
//            region.center.longitude = coordinate.longitude
//            region.span.latitudeDelta = 0.004
//            region.span.longitudeDelta = 0.004
//
//            let options = MKMapSnapshotOptions()
//            options.showsPointsOfInterest = false
//            options.region = region
//            options.size = CGSize(width: UIScreen.main.bounds.width, height: RIPLocationCard.height)
//
//            MKMapSnapshotter(options: options).start { snapshot, error in
//                self.mapView.image = snapshot?.image
//            }
//        }
//    }

//class AddressLabel: SRCopyableView {
//    private let lineOneLabel = UILabel(style: .regular)
//            .with(numberOfLines: 2)
//    private let lineTwoLabel = UILabel(style: .regular)
//            .with(numberOfLines: 1)
//
//    override init(frame: CGRect = .zero) {
//        super.init(frame: frame)
//        self.addSubview(lineOneLabel)
//        self.addSubview(lineTwoLabel)
//
//        lineOneLabel.snp.makeConstraints { make in
//            make.top.left.right.equalTo(self)
//        }
//
//        lineTwoLabel.snp.makeConstraints { make in
//            make.top.equalTo(lineOneLabel.snp.bottom).priority(999)
//            make.bottom.left.right.equalTo(self)
//        }
//    }
//
//    override var copyableText: String? {
//        return self.lineOneLabel.text
//    }
//
//    var location: Location? {
//        didSet {
//            lineOneLabel.text = location?.address
//            lineTwoLabel.attributedText = get(lineTwo: location)
//        }
//    }
//
//    private func get(lineTwo location: Location?) -> NSAttributedString? {
//        guard let latLng = location?.latLng, MunchLocation.isEnabled else {
//            return nil
//        }
//
//        let attributedText = NSMutableAttributedString()
//
//        if let distance = MunchLocation.distance(asMetric: latLng) {
//            // Lat Lng might not be given yet
//            attributedText.append(NSAttributedString(string: distance))
//        }
//
//        if let landmarks = location?.landmarks {
//            for landmark in landmarks {
//                if let min = MunchLocation.distance(asDuration: landmark.location.latLng, toLatLng: latLng) {
//                    attributedText.append(NSAttributedString(string: " • \(min) from "))
//                    attributedText.append(NSAttributedString(string: landmark.name,
//                            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
//                    ))
//                    break
//                }
//            }
//        }
//
//        return attributedText
//    }

//    class func height(location: Location) -> CGFloat {
//        var count = 0
//
//        if let latLng = MunchLocation.lastLatLng {
//            count += 1
//        }
//
//        if let address = location.address {
//            let width = UIScreen.main.bounds.width - 48
//            let lines = UILabel.countLines(font: FontStyle.regular.font, text: address, width: width)
//            count += lines <= 2 ? lines : 2
//        }
//        return CGFloat(count) * 20
//    }
