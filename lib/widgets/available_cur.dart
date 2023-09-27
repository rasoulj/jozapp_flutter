import 'package:flutter/material.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';

class AvailableCur extends StatelessWidget {
  final CurTypes cur;
  const AvailableCur({Key? key, this.cur = CurTypes.usd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double value = RestApi.appModel.wallet.value(cur);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("available".T(cur.longName)),
              Text(
                "${cur.symbol} ${value.toTwoDigit()}",
                style: AppStyles.darkText24Bold,
              )
            ],
          ),
        ),
        height: 65,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppStyles.borderAll(),
        ),
      ),
    );
  }
}
