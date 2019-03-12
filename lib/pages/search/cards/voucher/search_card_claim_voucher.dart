import 'package:munch_app/api/authentication.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/pages/search/search_card.dart';
import 'package:munch_app/api/file_api.dart' as file_api;
import 'package:munch_app/pages/vouchers/voucher_page.dart';
import 'package:munch_app/utils/munch_analytic.dart';

class SearchCardClaimVoucher extends SearchCardWidget {
  final file_api.Image image;
  final String voucherId;

  SearchCardClaimVoucher(SearchCard card)
      : image = file_api.Image.fromJson(card['image']),
        voucherId = card['voucherId'],
        super(card);

  @override
  Widget buildCard(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 24 - 24);

    return AspectRatio(
      aspectRatio: 1 / 0.625,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: ShimmerSizeImage(
          minWidth: width,
          sizes: image.sizes,
        ),
      ),
    );
  }

  @override
  void onTap(BuildContext context) {
    Authentication.instance.requireAuthentication(context).then((state) {
      if (state == AuthenticationState.loggedIn) {
        MunchAnalytic.logEvent("voucher_claim_show", parameters: {
          "voucherId": voucherId,
          "from": "search_card",
        });
        VoucherPage.push(context, voucherId: voucherId);
      }
    }).catchError((error) {
      MunchDialog.showError(context, error);
    });
  }
}
