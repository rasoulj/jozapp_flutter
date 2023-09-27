
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/screens/wallet/cur_detail.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

import 'view_currency.dart';

class _WalletHeader extends StatelessWidget {
  const _WalletHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.account_circle_rounded,
                      color: AppColors.white,
                      size: 40,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "profile.welcome".T(model.user?.displayName),
                        style: AppStyles.whiteText,
                      ),
                      Text(
                        "profile.your_wallet".T(),
                        style: AppStyles.greyText10,
                      ),
                    ],
                  )
                ],
              )),
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.topRight,
                  child: const WalletLogo(width: 30,),)),
        ],
      ),
    );
  }
}

class _WalletCurrentBalance extends StatelessWidget {
  const _WalletCurrentBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);
    var balance = model.totalBalance;

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "profile.current_balance".T(),
                style: AppStyles.whiteText18,
              ),
              const Icon(
                Icons.more_horiz,
                color: AppColors.white,
              ),
            ],
          ),
          PadV(
            padding: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  balance.toTwoDigit(),
                  style: AppStyles.whiteText32,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 5),
                  child: Text(
                    model.branch?.defCurrency.shortName ?? "",
                    style: AppStyles.greyText12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _WalletCurrencies extends StatelessWidget {
  const _WalletCurrencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var all = AppConfig.activeCurrencies;
    var model = Provider.of<AppDataModel>(context, listen: true);
    var defCur = model.branch?.defCurrency ?? CurTypes.usd;
    int defIndex = all.indexOf(defCur);

    return ListView.builder(
        itemCount: all.length,
        itemBuilder: (context, i) {
          var cur = i == 0 && defIndex >= 0
              ? defCur
              : i == defIndex
              ? all[0]
              : all[i];

          return ViewCurrency(cur: cur, onPress: () => Get.to(() => CurDetailScreen(cur: cur), transition: Transition.fadeIn),);
        });
  }
}

class _WalletIncomeInfo extends StatelessWidget {
  const _WalletIncomeInfo({Key? key}) : super(key: key);

  static const _height = 100.0;
  static const _iconSize = 48.0;

  Widget _buildRow(String h, String t) {

    return Expanded(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(t, style: AppStyles.whiteText,),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(h, style: AppStyles.whiteText18,),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    var pad = Get.width / 8;
    var model = Provider.of<AppDataModel>(context, listen: true);


    return PadV(
      padding: 20,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: pad),
            child: Container(
              child: Row(
                children: [
                  _buildRow((2537.0).toTwoDigit() + " " + (model.branch?.defCurrency.symbol ?? ""), "Your Income"),
                  _buildRow((189001.3).toTwoDigit() + " " + (model.branch?.defCurrency.symbol ?? ""), "Your Sending"),
                ],
              ),
              decoration: BoxDecoration(
                boxShadow: AppStyles.boxShadow,
                color: AppColors.accent,
                borderRadius: AppStyles.borderLeft,
              ),
              height: _height,
            ),
          ),
          Positioned.directional(
              top: (_height - _iconSize) / 2,
              start: pad - _iconSize / 2 - 4,
              textDirection: TextDirection.ltr,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(6),
                    primary: AppColors.white, // <-- Button color
                    onPrimary: AppColors.accent, // <-- Splash color
                  ),
                  onPressed: () {},
                  child: const Icon(Icons.arrow_forward))),
        ],
      ),
    );
  }
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: const [
            _WalletHeader(),
            _WalletCurrentBalance(),
            // _WalletIncomeInfo(),
            Expanded(child: _WalletCurrencies()),
          ],
        ),
      ),
    );
  }
}
