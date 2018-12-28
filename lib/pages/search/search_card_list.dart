import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/search/search_manager.dart';
import 'package:munch_app/styles/colors.dart';

class SearchCardList extends StatefulWidget {
  final SearchCardListState state = SearchCardListState();

  @override
  State<StatefulWidget> createState() => state;
}

class SearchCardListState extends State<SearchCardList> {
  final ScrollController _controller = ScrollController();
  final SearchCardDelegator _delegator = SearchCardDelegator();

  SearchManager _manager;
  List<SearchCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => onScroll(_controller.position));
  }

  Future search(SearchQuery query) {
    scrollToTop();
    _manager = SearchManager(query);
    _manager.stream().listen((cards) {
      setState(() => this._cards = cards);
    }, onError: (error) {
      MunchDialog.showError(context, error);
    });

    return _manager.start();
  }

  void scrollToTop() {
    if (_cards.isNotEmpty) {
      _controller.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void scrollTo(String uniqueId) {
    // TODO
  }

  void onScroll(ScrollPosition position) {
    if (position.pixels > position.maxScrollExtent - 100) {
      _manager.append().then((_) {
        setState(() {});
      });
    }
  }

  Future _handleRefresh() async {
    return search(_manager.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MunchColors.white,
      backgroundColor: MunchColors.secondary500,
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(),
        controller: _controller,
        itemCount: _cards.length + 1,
        itemBuilder: (context, i) {
          if (_cards.length == i) {
            return _SearchLoaderIndicator(loading: _manager.more);
          }
          return _delegator.delegate(_cards[i]);
        },
      ),
    );
  }
}

class _SearchLoaderIndicator extends StatelessWidget {
  const _SearchLoaderIndicator({Key key, @required this.loading})
      : super(key: key);

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: EdgeInsets.only(bottom: 48),
      alignment: Alignment.center,
      child: loading
          ? SpinKitThreeBounce(
              color: MunchColors.secondary500,
              size: 24.0,
            )
          : null,
    );
  }
}
