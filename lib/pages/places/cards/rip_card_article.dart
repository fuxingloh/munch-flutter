import 'package:intl/intl.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/separators.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:url_launcher/url_launcher.dart';

class RIPCardArticle extends RIPCardWidget {
  RIPCardArticle(PlaceData data) : super(data, margin: const RIPCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    final articles = data.articles;
    final width = MediaQuery.of(context).size.width - 48 - 36;

    var listView = Container(
      height: 320,
      margin: EdgeInsets.only(top: 24, bottom: 24),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 24, right: 24),
        itemBuilder: (context, i) {
          return SizedBox(
            width: width,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => _onArticle(articles[i]),
                  child: _RIPArticleCell(article: articles[i]),
                )
              ],
            ),
          );
        },
        itemCount: articles.length,
        separatorBuilder: (c, i) => SizedBox(width: 24),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text("${data.place.name} Articles", style: MTextStyle.h2),
        ),
        listView,
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: SeparatorLine(),
        ),
      ],
    );
  }

  void _onArticle(Article article) async {
    String url = article.url;
    if (await canLaunch(url)) {
      MunchAnalytic.logEvent("rip_click_article");
      await launch(url);
    }
  }

  static bool isAvailable(PlaceData data) {
    return data.articles.isNotEmpty;
  }
}

DateFormat _format = DateFormat("MMM dd, yyyy");

String _formatDate(int millis) {
  return _format.format(DateTime.fromMillisecondsSinceEpoch(millis));
}

class _RIPArticleCell extends StatelessWidget {
  const _RIPArticleCell({Key key, this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(color: MunchColors.black15, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
            ),
            child: ShimmerSizeImage(
              sizes: article.thumbnail?.sizes,
              fit: BoxFit.cover,
              minHeight: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Text(article.title, maxLines: 2, style: MTextStyle.h5),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
            child: Text(
              article.description,
              maxLines: 4,
              style: MTextStyle.subtext,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        article.domain.name,
                        maxLines: 1,
                        style: MTextStyle.h6.copyWith(
                          color: MunchColors.secondary700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(_formatDate(article.createdMillis), maxLines: 1, style: MTextStyle.subtext),
                    ],
                  ),
                ),
                IgnorePointer(
                  child: MunchButton.text(
                    "Read More",
                    onPressed: () {},
                    style: MunchButtonStyle.borderSmall,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
