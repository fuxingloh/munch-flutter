import 'package:munch_app/api/search_api.dart';
import 'package:munch_app/api/structured_exception.dart';
import 'package:munch_app/components/shimmer.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchCardShimmer extends SearchCardWidget {
  SearchCardShimmer(SearchCard card) : super(card);

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1 / 0.6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: const Shimmer(),
          ),
        ),
        Container(
          height: 18,
          width: 200,
          margin: const EdgeInsets.only(top: 8),
          child: const Shimmer(),
        ),
        Container(
          height: 16,
          width: 160,
          margin: const EdgeInsets.only(top: 8),
          child: const Shimmer(),
        ),
        Container(
          height: 16,
          width: 260,
          margin: const EdgeInsets.only(top: 8),
          child: const Shimmer(),
        ),
      ],
    );
  }
}

class SearchCardNoResult extends SearchCardWidget {
  SearchCardNoResult(SearchCard card) : super(card);

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("No Results", style: MTextStyle.h2),
        Container(
          margin: EdgeInsets.only(top: 16),
          child:
              Text("We could not find anything. Try broadening your search?"),
        ),
      ],
    );
  }
}

class SearchCardError extends SearchCardWidget {
  final String _title;
  final String _message;

  SearchCardError(SearchCard card)
      : _title = card['title'],
        _message = card['message'],
        super(card);

  @override
  Widget buildCard(BuildContext context) {
    List<Widget> children = [Text(_title ?? "Error", style: MTextStyle.h2)];

    if (_message != null) {
      children.add(Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(_message),
      ));
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: MunchColors.peach100, borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  static double height(BuildContext context, SearchCard card) {
    const insets = SearchCardInsets.only();
    var total = insets.vertical + MTextStyle.h2.fontSize + 48;
    if (card['message'] != null) {
      return total + 16 + MTextStyle.regular.fontSize;
    }
    return total;
  }

  static SearchCard message(String title, String message) {
    return SearchCard.cardId("SearchCardError", body: {
      'title': title,
      'message': message,
    });
  }

  static SearchCard error(Object object) {
    String message = object.toString();

    if (object is StructuredException) {
      message = object.message;
    }

    return SearchCard.cardId("SearchCardError", body: {
      'title': 'Unknown Error',
      'message': message,
    });
  }

  static SearchCard unknown() {
    return SearchCard.cardId("SearchCardError", body: {
      'title': "Unknown Error",
      'message': "Unknown Error has occurred.",
    });
  }

  static SearchCard location() {
    return SearchCard.cardId("SearchCardError", body: {
      'title': "No Location Detected",
      'message': "Try refreshing or moving to another spot.",
    });
  }
}

class SearchCardUnsupported extends SearchCardWidget {
  SearchCardUnsupported(SearchCard card) : super(card);

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Welcome back to Munch!", style: MTextStyle.h2),
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 24),
          child: Text(
              "While you were away, we have been working very hard to add more sugar and spice to the app to enhance your food discovery journey! Update Munch now to discover what's delicious!",
              style: MTextStyle.regular),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: MunchButton.text("Update Munch", onPressed: onPressed),
        )
      ],
    );
  }

  void onPressed() async {
    String url =
        'https://play.google.com/store/apps/details?id=app.munch.munchapp';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
