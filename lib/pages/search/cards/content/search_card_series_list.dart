import 'package:munch_app/api/content_api.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/munch_horizontal_snap.dart';

class SearchCardSeriesList extends SearchCardWidget {
  final CreatorSeries series;
  final List<CreatorContent> contents;

  SearchCardSeriesList(SearchCard card)
      : series = CreatorSeries.fromJson(card['series']),
        contents = CreatorContent.fromJsonList(card['contents']),
        super(card, margin: SearchCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text(series.title, style: MTextStyle.h2),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 24, right: 24, bottom: 24),
          child: Text(series.subtitle, style: MTextStyle.h6),
        ),
        MunchHorizontalSnap(
          sampleBuilder: (context) {
            return Container(
              width: width,
              child: SearchSeriesContentCard(content: CreatorContent(title: "", subtitle: " ", body: " \n \n ")),
            );
          },
          itemBuilder: (context, i) {
            return Container(
              width: width,
              height: width,
              child: GestureDetector(
                onTap: () => onContent(contents[i]),
                child: SearchSeriesContentCard(content: contents[i]),
              ),
            );
          },
          itemCount: contents.length,
          spacing: 16,
          padding: const EdgeInsets.only(left: 24, right: 24),
        )
      ],
    );
  }

  void onContent(CreatorContent content) {
    // TODO
  }
}

class SearchSeriesContentCard extends StatelessWidget {
  final CreatorContent content;

  const SearchSeriesContentCard({Key key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1 / 0.6,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ShimmerSizeImage(
                  minWidth: width,
                  sizes: content?.image?.sizes,
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  color: MunchColors.black.withOpacity(0.45),
                  child: Text(
                    content.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: MTextStyle.h2.copyWith(color: MunchColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            content.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MTextStyle.h5.copyWith(color: MunchColors.secondary700),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            content.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: MTextStyle.regular.copyWith(fontSize: 15),
          ),
        )
      ],
    );
  }
}
