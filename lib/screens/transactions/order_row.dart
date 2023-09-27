import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/models/order.dart';
import 'package:jozapp_flutter/screens/transactions/order_view.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:jozapp_flutter/models/types.dart';


class OrderRow extends StatelessWidget {
  final Order order;
  final bool last;
  final Widget? action;

  const OrderRow({
    Key? key,
    this.order = const Order(),
    this.last = false,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => Get.to(() => OrderView(
            order: order,
          ),
              opaque: true,
              transition: Transition.fadeIn,
          ),
          trailing: action ?? Text(order.updatedAt?.formatDate ?? "-", style: AppStyles.greyText10,),
          leading: order.getBadge(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${order.cur.shortName} ${order.amount.toTwoDigit()}", style: AppStyles.whiteText,),
              Text(order.desc ?? order.updatedAt?.formatDate ?? "-", style: AppStyles.greyText10, overflow: TextOverflow.ellipsis,),
            ],
          ),
        ),
        if(!last) const ListTileDiv(),
      ],
    );
  }
}
