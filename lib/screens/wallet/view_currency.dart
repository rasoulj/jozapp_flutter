import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';


class ViewCurrency extends StatelessWidget {
  final CurTypes cur;
  final VoidCallback? onPress;
  final Color? color;

  const ViewCurrency({Key? key, this.cur = CurTypes.usd, this.onPress, this.color}) : super(key: key);

  bool get canPress => onPress != null;

  @override
  Widget build(BuildContext context) {

    var model = Provider.of<AppDataModel>(context, listen: true);

    bool isDef = model.defCurrency == cur;

    var defSym = model.defCurrency.symbol;

    var rate = model.getRate(cur);

    double value = model.wallet.value(cur);

    int count = model.openOrders(cur).length;

    Color clr = color ?? AppColors.black3;

    bool dark = AppColors.isDark(clr);


    var hero = Hero(
      tag: cur.longName,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Stack(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Badge(
                          elevation: 5,
                          showBadge: count > 0,
                          badgeContent: Text(count.toString(), style: AppStyles.whiteText,),
                          child: cur.icon(),
                        ),
                      )),
                  Expanded(
                    flex: 12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${cur.shortName} (${cur.longName})",
                          style: dark ? AppStyles.whiteText18 : AppStyles.darkText18,
                        ),
                        Text(
                          "${cur.symbol} ${value.toTwoDigit()}",
                          style: dark ? AppStyles.whiteText : AppStyles.darkText,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: canPress ? Icon(
                        Icons.arrow_right_rounded,
                        color: dark ? AppColors.grey1 : AppColors.black2,
                        size: 40,
                      ) : const ZeroWidget())
                ],
              ),
              height: 100,
              decoration: BoxDecoration(
                boxShadow: AppStyles.boxShadow,
                color: clr,
                borderRadius: AppStyles.border1,
              ),
            ),
            if (!isDef)
              Positioned.directional(
                  bottom: 8,
                  end: 15,
                  textDirection: TextDirection.ltr,
                  child: Text(
                    "${cur.symbol}1 = $defSym${rate.toTwoDigit()}",
                    style: dark ? AppStyles.greyText10 : AppStyles.darkText10,
                  )),
          ],
        ),
      ),
    );

    return canPress ? GestureDetector(onTap: onPress, child: hero,) : hero;
  }
}
