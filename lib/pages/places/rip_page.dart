import 'package:flutter/material.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/pages/places/rip_footer.dart';
import 'package:munch_app/pages/places/rip_header.dart';

class RIPPage extends StatefulWidget {
  const RIPPage({Key key, this.place}) : super(key: key);

  final Place place;

  @override
  State<StatefulWidget> createState() => RIPPageState(place);
}

class RIPPageState extends State<RIPPage> {
  RIPPageState(this.place);

  final Place place;
  PlaceData placeData;

  ScrollController _controller;
  bool clear = true;

  @override
  void initState() {
    super.initState();

    //        Crashlytics.sharedInstance().setObjectValue(placeId, forKey: "RIPController.placeId")
    MunchApi.instance
        .get('/places/${place.placeId}')
        .then((res) => PlaceData.fromJson(res.data))
        .then((placeData) {
      setState(() {
        this.placeData = placeData;
      });
    }, onError: (error) {
      MunchDialog.showError(context, error);
    });

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_controller.offset > 120) {
      if (!clear) return;
      setState(() {
        clear = false;
      });
    } else {
      if (clear) return;
      setState(() {
        clear = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = RIPCardDelegator.delegate(placeData);

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            controller: _controller,
            padding: EdgeInsets.zero,
            children: list,
          ),
          RIPHeader(
            placeData: placeData,
            clear: clear,
          ),
        ],
      ),
      bottomNavigationBar: RIPFooter(),
    );
  }

  // 16 spacing apart
}


//    fileprivate var cardTypes: [RIPCard.Type] = [RIPLoadingImageCard.self, RIPLoadingNameCard.self]
//    fileprivate var galleryItems = [RIPImageItem]()
//
//    private var imageLoader = RIPImageLoader()
//
//    private let provider = MunchProvider<PlaceService>()
//    private let recentService = MunchProvider<UserRecentPlaceService>()

//
//    func start(data: PlaceData) {
//        RecentPlaceDatabase().add(id: self.placeId, data: data.place)
//        if Authentication.isAuthenticated() {
//            self.recentService.rx.request(.put(self.placeId)).subscribe { event in
//                switch event {
//                case .success: return
//
//                case .error(let error):
//                    self.alert(error: error)
//                }
//            }
//        }
//
//        imageLoader.start(placeId: data.place.placeId, images: data.images)
//
//        // Collection View
//        self.cardTypes = self.collectionView(cellsForData: data)
//        self.galleryItems = imageLoader.items
//
//        self.collectionView.isScrollEnabled = true
//        self.scrollViewDidScroll(self.collectionView)
//
//        imageLoader.observe().subscribe { event in
//            switch event {
//            case .next(let items):
//                self.galleryItems = items
//                self.collectionView.reloadData()
//
//            case .error(let error):
//                self.alert(error: error)
//
//            case .completed:
//                return
//            }
//        }.disposed(by: disposeBag)



//    fileprivate enum RIPSection: Int, CaseIterable {
//        case card = 0
//        case gallery = 1
//        case loader = 2
//    }

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch RIPSection(rawValue: section)! {
//        case .card:
//            return cardTypes.count
//
//        case .gallery:
//            return galleryItems.count
//
//        case .loader:
//            return 1
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch (RIPSection(rawValue: indexPath.section)!, indexPath.row) {
//        case (.card, let row):
//            let cell = collectionView.dequeue(type: cardTypes[row], for: indexPath)
//            cell.register(data: self.data, controller: self)
//            return cell
//
//        case (.gallery, let row):
//            switch galleryItems[row] {
//            case .image:
//                return collectionView.dequeue(type: RIPGalleryImageCard.self, for: indexPath)
//            }
//
//        case (.loader, _):
//            return collectionView.dequeue(type: RIPLoadingGalleryCard.self, for: indexPath)
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch (RIPSection(rawValue: indexPath.section)!, indexPath.row) {
//        case (.card, _):
//            let cell = collectionView.cellForItem(at: indexPath) as! RIPCard
//            cell.didSelect(data: self.data, controller: self)
//
//        case (.gallery, let row):
//            let controller = RIPImageController(index: row, loader: self.imageLoader, place: self.data.place)
//            controller.modalPresentationStyle = .overCurrentContext
//            self.present(controller, animated: true)
//
//        default:
//            break
//        }
//    }
//}


//// MARK: Add Targets
//extension RIPController: UIGestureRecognizerDelegate, SFSafariViewControllerDelegate {
//
//    fileprivate func addTargets() {
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//
//        self.headerView.backControl.addTarget(self, action: #selector(onBackButton(_:)), for: .touchUpInside)
//    }
//
//    func scrollTo(indexPath: IndexPath) {
//        self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//    }
//
//    @objc func onBackButton(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}