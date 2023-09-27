import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:jozapp_flutter/models/order.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:jozapp_flutter/models/types.dart';

class OrderRow extends StatelessWidget {
  final Order? order;
  final bool last;

  const OrderRow({
    Key? key,
    this.order,
    this.last = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Order ord = order ?? const Order();
    return Column(
      children: [
        ListTile(
          trailing: Text(ord.updatedAt?.formatDate ?? "-", style: AppStyles.greyText10,),
          leading: Badge(
            badgeColor: Colors.transparent,
            badgeContent: ord.cur.icon(20),
            child: ord.type?.icon(40),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${ord.cur.shortName} ${ord.amount.toTwoDigit()}", style: AppStyles.whiteText,),
              // Text(ord.desc ?? "", style: AppStyles.greyText10, overflow: TextOverflow.ellipsis,),
            ],
          ),
        ),
        if(!last) const ListTileDiv(),
      ],
    );
  }
}
