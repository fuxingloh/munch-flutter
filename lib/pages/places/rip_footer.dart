import 'package:flutter/widgets.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';

class RIPFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 56,
      decoration:
          const BoxDecoration(color: MunchColors.white, boxShadow: elevation2),
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            child: Icon(MunchIcons.rip_heart, size: 26),
          )
        ],
      ),
    );
  }
}

//
//    @objc private func onAddPlace() {
//        guard let place = self.place else {
//            return
//        }
//        guard let view = self.controller.view else {
//            return
//        }
//
//        Authentication.requireAuthentication(controller: controller) { state in
//            PlaceSavedDatabase.shared.toggle(placeId: place.placeId).subscribe { (event: SingleEvent<Bool>) in
//                let generator = UIImpactFeedbackGenerator()
//
//                switch event {
//                case .success(let added):
//                    self.heartBtn.isSelected = added
//                    generator.impactOccurred()
//                    if added {
//                        view.makeToast("Added '\(place.name)' to your places.")
//                    } else {
//                        view.makeToast("Removed '\(place.name)' from your places.")
//                    }
//
//                case .error(let error):
//                    generator.impactOccurred()
//                    self.controller.alert(error: error)
//                }
//            }.disposed(by: self.disposeBag)
//        }
//    }