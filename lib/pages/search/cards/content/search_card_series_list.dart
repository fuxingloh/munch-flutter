import 'package:munch_app/api/content_api.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/contents/content_page.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/munch_horizontal_snap.dart';

class SearchCardSeriesList extends SearchCardWidget {
  final CreatorSeries series;
  final List<CreatorContent> contents;
  final dynamic options;

  SearchCardSeriesList(SearchCard card)
      : series = CreatorSeries.fromJson(card['series']),
        contents = CreatorContent.fromJsonList(card['contents']),
        options = card['options'],
        super(card, margin: const SearchCardInsets.only(left: 0, right: 0));

  double getWidth(BuildContext context) {
    if (options != null && options['expand'] == 'height') {
      return (MediaQuery.of(context).size.width * 0.5);
    }
    return (MediaQuery.of(context).size.width - 48);
  }

  @override
  Widget buildCard(BuildContext context) {
    final width = getWidth(context);

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
          itemWidth: width,
          sampleBuilder: (context) {
            return SearchSeriesContentCard(
              content: CreatorContent(title: "", subtitle: " ", body: " \n \n "),
              options: options,
            );
          },
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () => onContent(context, contents[i]),
              child: SearchSeriesContentCard(content: contents[i], options: options),
            );
          },
          itemCount: contents.length,
          spacing: 16,
          padding: const EdgeInsets.only(left: 24, right: 24),
        )
      ],
    );
  }

  void onContent(BuildContext context, CreatorContent content) {
     ContentPage.push(context, content: content);
  }
}

class SearchSeriesContentCard extends StatelessWidget {
  final CreatorContent content;
  final dynamic options;

  const SearchSeriesContentCard({
    Key key,
    this.content,
    this.options,
  }) : super(key: key);

  double get aspectRatio {
    if (options != null && options['expand'] == 'height') {
      return 10 / 12;
    }
    return 1 / 0.6;
  }

  Alignment get imageTextAlignment {
    if (options != null && options['expand'] == 'height') {
      return Alignment.bottomCenter;
    }
    return Alignment.center;
  }

  TextStyle get imageTextStyle {
    if (options != null && options['expand'] == 'height') {
      return MTextStyle.h3.copyWith(color: MunchColors.white);
    }
    return MTextStyle.h2.copyWith(color: MunchColors.white);
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 48);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ShimmerSizeImage(
                  minWidth: width,
                  minHeight: width,
                  sizes: content?.image?.sizes,
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  alignment: imageTextAlignment,
                  color: MunchColors.black.withOpacity(0.45),
                  child: Text(
                    content.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: imageTextStyle,
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
            textAlign: TextAlign.left,
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
