import 'package:flutter/cupertino.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/search/search_manager.dart';

class SearchCardList extends StatefulWidget {
  final SearchCardListState state = SearchCardListState();

  @override
  State<StatefulWidget> createState() => state;
}

class SearchCardListState extends State<SearchCardList> {
  final ScrollController _controller = ScrollController();

  SearchCardDelegator _delegator = SearchCardDelegator();

  SearchManager _manager;
  List<SearchCard> _cards = [];

  void search(SearchQuery query) {
    _manager = SearchManager(query);
    if (_cards.isNotEmpty) {
      _controller.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }

    _manager.start().listen((list) {
      setState(() {
        this._cards = list;
      });
    }, onError: (error) {
      MunchDialog.showError(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemBuilder: (context, i) => _delegator.delegate(_cards[i]),
      itemCount: _cards.length,
    );
  }
}

//class SearchTableView: UITableView {
//    var cardManager: SearchCardManager
//    var cardDelegate: SearchTableViewDelegate?
//    var controller: SearchController!
//
//    var cardIds = [String: SearchCardView.Type]()
//    var cards = [SearchCard]()
//
//    private let refreshView: UIRefreshControl = {
//        let control = UIRefreshControl()
//        control.tintColor = UIColor.secondary500
//        return control
//    }()
//
//    required init(query: SearchQuery = SearchQuery(), inset: UIEdgeInsets = .zero) {
//        self.cardManager = SearchCardManager(query: query)

//        self.addSubview(refreshView)
//        self.refreshView.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
//
//        self.separatorStyle = .none
//        self.showsVerticalScrollIndicator = false
//        self.showsHorizontalScrollIndicator = false
//
//        self.rowHeight = UITableViewAutomaticDimension
//        self.estimatedRowHeight = 400
//
//        self.contentInsetAdjustmentBehavior = .always
//
//        self.registerAll()
//    }
//

//}

//extension SearchTableView {
//    func search(query: SearchQuery, animated: Bool = true) {
//        self.cardManager = SearchCardManager(query: query)
//        self.cardManager.start {
//            self.reloadData(manager: self.cardManager)
//        }
//    }
//
//    func reloadData(manager: SearchCardManager) {
//        self.cards = self.cardManager.cards.filter { (card: SearchCard) -> Bool in
//            if self.cardIds[card.cardId] != nil {
//                return true
//            }
//
//            os_log("Required Card: %@ Not Found, SearchStaticEmptyCard is used instead", type: .info, card.cardId)
//            return false
//        }
//        self.reloadData()
//    }
//
//    func scrollToTop(animated: Bool = true) {
//        self.scrollToRow(at: .init(row: 0, section: 0), at: .top, animated: animated)
//    }
//
//    func scrollTo(uniqueId: String, animated: Bool = true) {
//        guard let row = cards.firstIndex(where: { $0.uniqueId == uniqueId }) else {
//            return
//        }
//
//        self.scrollToRow(at: .init(row: row, section: 1), at: .top, animated: animated)
//    }
//
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        self.search(query: self.cardManager.searchQuery)
//        refreshControl.endRefreshing()
//    }
//}

//
//// MARK: Lazy Append Loading
//extension SearchTableView {
//    private static let loadingCard: SearchStaticLoadingCard = SearchStaticLoadingCard()
//    private var loadingCard: SearchStaticLoadingCard {
//        return SearchTableView.loadingCard
//    }
//
//    private func appendLoad() {
//        guard cardManager.more else {
//            self.loadingCard.stopAnimating()
//            return
//        }
//
//        self.loadingCard.startAnimating()
//
//        cardManager.append {
//            self.reloadData(manager: self.cardManager)
//
//            if !self.cardManager.more {
//                self.loadingCard.stopAnimating()
//            }
//        }
//    }
//}
