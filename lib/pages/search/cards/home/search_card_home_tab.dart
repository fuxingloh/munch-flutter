import 'package:flutter/material.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/filter/filter_area_page.dart';
import 'package:munch_app/pages/filter/filter_between_page.dart';
import 'package:munch_app/pages/filter/filter_page.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/pages/suggest/suggest_page.dart';
import 'package:munch_app/styles/elevations.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/munch_horizontal_snap.dart';
import 'package:munch_app/utils/munch_location.dart';

class SearchCardHomeTab extends SearchCardWidget {
  SearchCardHomeTab(SearchCard card) : super(card, margin: const SearchCardInsets.only(left: 0, right: 0));

  @override
  Widget buildCard(BuildContext context) => _SearchCardHomeTabChild();
}

class _SearchCardHomeTabChild extends StatefulWidget {
  @override
  _SearchCardHomeTabChildState createState() => _SearchCardHomeTabChildState();
}

class _SearchCardHomeTabChildState extends State<_SearchCardHomeTabChild> {
  final profile = SearchHomeProfile();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 48;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: profile,
        ),
        MunchHorizontalSnap(
          itemWidth: width,
          sampleBuilder: (context) {
            return SearchHomeFeatureSlide(slide: _FeatureSlide.between);
          },
          itemBuilder: (context, i) {
            final slide = _FeatureSlide.slides[i];
            return GestureDetector(
              onTap: () => onTap(context, slide),
              child: SearchHomeFeatureSlide(slide: slide),
            );
          },
          itemCount: _FeatureSlide.slides.length,
          spacing: 16,
          padding: const EdgeInsets.only(left: 24, right: 24),
        ),
      ],
    );
  }

  void onTap(BuildContext context, _FeatureSlide slide) {
    final searchQuery = SearchPage.state.searchQuery;

    if (slide == _FeatureSlide.between) {
      FilterBetweenPage.push(context, searchQuery).then((searchQuery) {
        if (searchQuery == null) return;

        SearchPage.state.push(searchQuery);
      });
    } else if (slide == _FeatureSlide.nearby) {
      Future future = MunchLocation.instance.request(force: true, permission: true).then((latLng) {
        if (latLng == null) return;

        SearchQuery query = SearchQuery.search();
        query.filter.location.type = SearchFilterLocationType.Nearby;
        SearchPage.state.push(query);
      });

      MunchDialog.showProgress(context, future: future).catchError((error) {
        MunchDialog.showError(context, error);
      });
    }
  }
}

class SearchHomeProfile extends StatelessWidget {
  String _salutation() {
    var date = DateTime.now();
    var total = (date.hour * 60) + date.minute;

    if (total >= 300 && total < 720) {
      return "Good Morning";
    } else if (total >= 720 && total < 1020) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  Future<String> _title() async {
    final profile = await UserProfile.get();
    final name = profile?.name ?? "Samantha";

    return "${_salutation()}, $name. Meeting someone for a meal?";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: FutureBuilder(
            future: _title(),
            builder: (context, snapshot) {
              final style = MTextStyle.h2;

              if (snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data, style: style);
              } else {
                return Text(_salutation(), style: style);
              }
            },
          ),
        ),
        FutureBuilder(
          future: UserProfile.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.data == null) {
              return GestureDetector(
                onTap: () => _onLogin(context),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, left: 24, right: 24),
                  child: Text(
                    "(Not Samantha? Create an account here.)",
                    style: MTextStyle.h6,
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }

  void _onLogin(BuildContext context) {
    Authentication.instance.requireAuthentication(context).then((state) {
      if (state != AuthenticationState.loggedIn) {
        return;
      }

      SearchPage.state.reset();
    });
  }
}

class _FeatureSlide {
  final String title;
  final String backgroundImage;
  final MunchButtonStyle buttonStyle;
  final String buttonText;

  const _FeatureSlide({this.title, this.backgroundImage, this.buttonStyle, this.buttonText});

  static const List<_FeatureSlide> slides = [between, nearby];

  static const _FeatureSlide between = _FeatureSlide(
    title: "Find the ideal spot for everyone with EatBetween.",
    backgroundImage: "Home_Feature_EatBetween.png",
    buttonStyle: MunchButtonStyle.secondary,
    buttonText: "Try EatBetween",
  );

  static const _FeatureSlide nearby = _FeatureSlide(
    title: "Explore places around you.",
    backgroundImage: "Home_Feature_Nearby.png",
    buttonStyle: MunchButtonStyle.primary,
    buttonText: "Discover Nearby",
  );
}

class SearchHomeFeatureSlide extends StatelessWidget {
  final _FeatureSlide slide;

  const SearchHomeFeatureSlide({Key key, @required this.slide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 330 / 198,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/img/${slide.backgroundImage}'),
              ),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: Text(slide.title, style: MTextStyle.h4White)),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
                MunchButton.text(slide.buttonText, onPressed: null, style: slide.buttonStyle),
              ],
            ),
          ),
        )
      ],
    );
  }
}
