import 'package:flutter/material.dart';
import 'package:munch_app/api/api.dart';
import 'package:munch_app/api/vouchers_api.dart';
import 'package:munch_app/components/dialog.dart';
import 'package:munch_app/components/shimmer_image.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';
import 'package:munch_app/utils/munch_analytic.dart';
import 'package:pin_code_view/pin_code_view.dart';

class VoucherPage extends StatefulWidget {
  final String voucherId;

  const VoucherPage({Key key, this.voucherId}) : super(key: key);

  @override
  _VoucherPageState createState() => _VoucherPageState();

  static Future<T> push<T extends Object>(BuildContext context, {@required String voucherId}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => VoucherPage(
              voucherId: voucherId,
            ),
        settings: const RouteSettings(name: '/vouchers'),
      ),
    );
  }
}

class _VoucherPageState extends State<VoucherPage> {
  Voucher voucher;

  @override
  void initState() {
    super.initState();

    MunchApi.instance.get("/vouchers/${widget.voucherId}").then((res) => Voucher.fromJson(res.data)).then((data) {
      setState(() {
        this.voucher = data;
      });
    }).catchError((error) {
      MunchDialog.showError(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (voucher == null) {
      return Scaffold(
        body: Center(
          child: const CircularProgressIndicator(
            backgroundColor: MunchColors.secondary500,
          ),
        ),
      );
    }
    return Scaffold(
      body: ListView(children: <Widget>[
        _VoucherBanner(voucher: voucher),
        _VoucherClaimed(voucher: voucher),
        _VoucherBar(voucher: voucher, onPasscode: onPasscode),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
          child: Text(voucher.description),
        ),
        const Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
          child: const Text("Terms and conditions of voucher:", style: MTextStyle.h4),
        ),
        _VoucherTerms(voucher: voucher),
      ]),
    );
  }

  void onPasscode(String passcode) {
    MunchAnalytic.logEvent("voucher_claim_attempt", parameters: {
      "voucherId": widget.voucherId,
    });

    Future future = MunchApi.instance
        .post("/vouchers/${widget.voucherId}/claim", body: {'passcode': passcode})
        .then((res) => Voucher.fromJson(res.data))
        .then((data) {
          setState(() {
            this.voucher = data;
          });
        });

    MunchDialog.showProgress(context, future: future).then((_) {
      MunchAnalytic.logEvent("voucher_claim_success", parameters: {
        "voucherId": widget.voucherId,
      });

      MunchDialog.showOkay(context, title: "You have claimed the voucher.");
    }).catchError((error) {
      MunchDialog.showError(context, error);
    });
  }
}

class _VoucherClaimed extends StatelessWidget {
  final Voucher voucher;

  const _VoucherClaimed({Key key, this.voucher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (voucher.remaining > 0) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
      child: Text(
        "Sorry! All vouchers have been claimed for today. Come down tomorrow starting 10am to get your 1-for-1 voucher!",
        style: MTextStyle.h4.copyWith(color: MunchColors.error),
      ),
    );
  }
}

class _VoucherTerms extends StatelessWidget {
  final Voucher voucher;

  const _VoucherTerms({Key key, this.voucher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 64),
      child: Column(
        children: List.generate(voucher.terms.length, (index) {
          final term = voucher.terms[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 32,
                  child: Text(
                    "${index + 1}.",
                    style: MTextStyle.h5,
                  ),
                ),
                Expanded(
                  child: Text(term),
                ),
              ],
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _VoucherBanner extends StatelessWidget {
  final Voucher voucher;

  const _VoucherBanner({Key key, this.voucher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = voucher.image;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AspectRatio(
        aspectRatio: image.aspectRatio,
        child: ShimmerSizeImage(
          sizes: image.sizes,
        ),
      ),
    );
  }
}

class _VoucherBar extends StatelessWidget {
  final Voucher voucher;
  final ValueChanged<String> onPasscode;

  const _VoucherBar({Key key, this.voucher, this.onPasscode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12, top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                "Vouchers left for today: ${voucher.remaining}",
                style: MTextStyle.h4,
              ),
            ),
          ),
          voucher.claimed
              ? MunchButton.text(
                  "Claimed",
                  onPressed: null,
                  style: MunchButtonStyle.disabled,
                )
              : MunchButton.text("For Staff", onPressed: () => onForStaff(context)),
        ],
      ),
    );
  }

  void onForStaff(BuildContext context) {
    MunchAnalytic.logEvent("voucher_show_passcode", parameters: {
      "voucherId": voucher?.voucherId,
    });

    _VoucherPasscode.push(context).then((passcode) {
      if (passcode == null) return;
      onPasscode(passcode);
    });
  }
}

class _VoucherPasscode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PinCode(
        obscurePin: true,
        title: Text("Enter authentication code:", style: MTextStyle.h2.copyWith(color: MunchColors.white)),
        subTitle: Text("(For staff only)", style: MTextStyle.h5.copyWith(color: MunchColors.white)),
        codeLength: 4,
        onCodeEntered: (code) {
          Navigator.pop(context, code);
        },
        backgroundColor: MunchColors.black85,
      ),
    );
  }

  static Future<String> push(BuildContext context) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (c, a, b) => _VoucherPasscode(),
        settings: const RouteSettings(name: '/vouchers/passcode'),
      ),
    );
  }
}
