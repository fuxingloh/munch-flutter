import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/content_api.dart';
import 'package:munch_app/api/munch_data.dart';
import 'package:munch_app/components/bottom_sheet.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/contents/items/content_item.dart';
import 'package:munch_app/pages/contents/items/content_loading.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:munch_app/utils/user_defaults_key.dart';
import 'package:share/share.dart';

class ContentPage extends StatefulWidget {
  final String contentId;
  final CreatorContent content;

  const ContentPage({
    Key key,
    this.contentId,
    this.content,
  }) : super(key: key);

  static Future<T> push<T extends Object>(BuildContext context, {String contentId, CreatorContent content}) {
    if (contentId == null) {
      contentId = content.contentId;
    }

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => ContentPage(content: content, contentId: contentId),
        settings: const RouteSettings(name: '/contents'),
      ),
    );
  }

  @override
  ContentPageState createState() => new ContentPageState();
}

class ContentPageState extends State<ContentPage> {
  CreatorContent content;
  List<CreatorContentItem> items = [];
  Map<String, Place> places = {};

  ScrollController controller = ScrollController();
  bool _clear = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    controller.addListener(_scrollListener);
    MunchAnalytic.logEvent("content_view");
    UserDefaults.instance.count(UserDefaultsKey.countViewContent);

    _loadAll();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _appendItems({String nextItemId}) {
    MunchApi.instance.get('/contents/${widget.contentId}/items?next.itemId${nextItemId ?? ''}').then((res) {
      setState(() {
        this.items.addAll(CreatorContentItem.fromJsonList(res.data));
        this.places.addAll(Place.fromJsonMap(res['places']));
      });

      if (res.hasNext) {
        _appendItems(nextItemId: res.next['itemId']);
      } else {
        setState(() => _loading = false);
      }
    }).catchError((error) {
      MunchDialog.showError(context, error);
    });
  }

  _loadAll() {
    if (content == null) {
      MunchApi.instance.get('/contents/${widget.contentId}').then((res) {
        setState(() {
          this.content = CreatorContent.fromJson(res.data);
        });
        _appendItems();
      }).catchError((error) {
        MunchDialog.showError(context, error);
      });
    } else {
      setState(() {
        this.content = widget.content;
      });
      _appendItems();
    }
  }

  _scrollListener() {
    if (controller.offset > 120) {
      if (!_clear) return;
      setState(() {
        _clear = false;
      });
    } else {
      if (_clear) return;
      setState(() {
        _clear = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: 64),
        itemBuilder: (c, i) {
          if (i == items.length) return loading;

          return ContentItemDelegator.delegate(items[i], this);
        },
        controller: controller,
        itemCount: items.length + 1,
      ),
      appBar: appBar,
    );
  }

  Widget get loading {
    if (_loading) {
      return ContentLoading();
    }
    return Container();
  }

  Widget get appBar {
    return AppBar(
      title: Text(content?.title ?? "", textAlign: TextAlign.center, style: MTextStyle.navHeader),
      iconTheme: IconThemeData(color: MunchColors.black),
      actions: <Widget>[
        IconButton(
          icon: Icon(MunchIcons.navigation_more),
          onPressed: () => onMore(context),
        )
      ],
    );
  }

  void onMore(BuildContext context) {
    MunchAnalytic.logEvent("content_click_more");

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MunchBottomSheet(
          children: [
            MunchBottomSheetTile(
              onPressed: () => onShare(context),
              icon: Icon(Icons.share),
              child: Text("Share"),
            ),
            MunchBottomSheetTile(
              onPressed: () => onCancel(context),
              icon: Icon(Icons.close),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onShare(BuildContext context) {
    Share.share("https://www.munch.app/contents/${content.cid}/${content.slug}");
    MunchAnalytic.logEvent("content_click_share");
    Navigator.of(context).pop();
  }
}
