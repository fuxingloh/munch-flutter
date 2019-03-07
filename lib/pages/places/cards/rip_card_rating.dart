import 'package:flutter/material.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/api/user_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/pages/places/cards/rip_card.dart';
import 'package:munch_app/styles/icons.dart';
import 'package:munch_app/styles/separators.dart';

class RIPCardRating extends RIPCardWidget {
  RIPCardRating(PlaceData data)
      : super(
          data,
          margin: const RIPCardInsets.only(left: 0, right: 0),
        );

  @override
  Widget buildCard(BuildContext context, PlaceData data) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Ratings", style: MTextStyle.h3),
                  UserRatingStars(data: data),
                ],
              ),
              RatingSummary(data: data)
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 24),
          child: SeparatorLine(),
        )
      ],
    );
  }
}

class RatingSummary extends StatelessWidget {
  final PlaceData data;

  const RatingSummary({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rating = data.rating;
    if (rating == null) return Container();

    return Column(
      children: <Widget>[
        Text(
          '${rating.summary.average.toStringAsFixed(1)}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: MunchColors.black75,
          ),
        ),
        Text(
          "out of 5",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MunchColors.black75,
          ),
        ),
//        Text("${rating.summary.total} Ratings", style: MTextStyle.subtext,)
      ],
    );
  }
}

class UserRatingStars extends StatefulWidget {
  final PlaceData data;

  const UserRatingStars({Key key, this.data}) : super(key: key);

  @override
  _UserRatingStarsState createState() => _UserRatingStarsState();
}

class _UserRatingStarsState extends State<UserRatingStars> {
  int current;

  int get ratingCount {
    if (current != null) return current;

    final ratedPlace = widget.data.user?.ratedPlace;
    if (ratedPlace == null) return 0;
    if (ratedPlace.rating == null) return 0;
    if (ratedPlace.status != UserRatedPlaceStatus.published) return 0;

    switch (ratedPlace.rating) {
      case UserRatedPlaceRating.star1:
        return 1;
      case UserRatedPlaceRating.star2:
        return 2;
      case UserRatedPlaceRating.star3:
        return 3;
      case UserRatedPlaceRating.star4:
        return 4;
      case UserRatedPlaceRating.star5:
        return 5;
      default:
        return 0;
    }
  }

  String get title {
    if (ratingCount == 0) {
      return "Tap to Rate:";
    }
    return "You Rated:";
  }

  UserRatedPlaceRating countToEnum(int count) {
    switch (count) {
      case 1:
        return UserRatedPlaceRating.star1;
      case 2:
        return UserRatedPlaceRating.star2;
      case 3:
        return UserRatedPlaceRating.star3;
      case 4:
        return UserRatedPlaceRating.star4;
      case 5:
      default:
        return UserRatedPlaceRating.star5;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(title, style: MTextStyle.smallBold),
        ),
        RatingStarArray(count: ratingCount, onRate: onRate)
      ],
    );
  }

  void onRate(int count) {
    Authentication.instance.requireAuthentication(context).then((state) async {
      if (state != AuthenticationState.loggedIn) return;

      setState(() {
        this.current = count;
      });

      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("You rated '${widget.data.place.name}'. $count Stars.")),
      );

      UserRatedPlace ratedPlace = UserRatedPlace(
        rating: countToEnum(count),
        status: UserRatedPlaceStatus.published,
      );

      final placeId = widget.data.place.placeId;
      await MunchApi.instance.put('/users/rated/places/$placeId', body: ratedPlace);
    }).catchError(
      (error) => MunchDialog.showError(context, error),
    );
  }
}

class RatingStarArray extends StatelessWidget {
  static const padding = 6.0;

  final int count;
  final ValueChanged<int> onRate;

  const RatingStarArray({
    Key key,
    @required this.onRate,
    @required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => onRate(1),
          child: Padding(
            padding: const EdgeInsets.only(right: padding, top: padding, bottom: padding),
            child: RatingStar(filled: count >= 1),
          ),
        ),
        GestureDetector(
          onTap: () => onRate(2),
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: RatingStar(filled: count >= 2),
          ),
        ),
        GestureDetector(
          onTap: () => onRate(3),
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: RatingStar(filled: count >= 3),
          ),
        ),
        GestureDetector(
          onTap: () => onRate(4),
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: RatingStar(filled: count >= 4),
          ),
        ),
        GestureDetector(
          onTap: () => onRate(5),
          child: Padding(
            padding: const EdgeInsets.only(left: padding, top: padding, bottom: padding),
            child: RatingStar(filled: count >= 5),
          ),
        ),
      ],
    );
  }
}

class RatingStar extends StatelessWidget {
  final bool filled;

  const RatingStar({Key key, this.filled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      filled ? MunchIcons.rip_rating_filled : MunchIcons.rip_rating,
      size: 24,
      color: MunchColors.secondary500,
    );
  }
}
