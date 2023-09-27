
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/screens/services/services_view.dart';
import 'package:jozapp_flutter/screens/transactions/index.dart';
import 'package:jozapp_flutter/screens/wallet/view_currency.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

import 'view_open_orders.dart';

class CurDetailScreen extends StatelessWidget {

  final CurTypes cur;
  const CurDetailScreen({Key? key, this.cur = CurTypes.usd, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: getTitle(cur.longName, subTitle: "main.services"),
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: AppColors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ViewCurrency(cur: cur,),
            ViewOpenOrders(cur: cur),
            ServicesView(shortList: true, cur: cur,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GenButton(
                rightIcon: true,
                icon: Icons.keyboard_arrow_right,
                onPressed: () => Get.to(() => TransactionsScreen(
                  gotoHome: Get.back,
                )),
                title: "main.trans",
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
