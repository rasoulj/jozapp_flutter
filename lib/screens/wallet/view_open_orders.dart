
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/order.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/screens/transactions/order_row.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

class ViewOpenOrders extends StatefulWidget {
  final CurTypes cur;
  const ViewOpenOrders({Key? key, this.cur = CurTypes.usd}) : super(key: key);

  @override
  State<ViewOpenOrders> createState() => _ViewOpenOrdersState();
}

class _ViewOpenOrdersState extends State<ViewOpenOrders> {

  String _delId = "";
  String get delId => _delId;
  set delId(String value) => setState(() => _delId = value);

  void _removeOrder(Order order) async {
    bool? h = await askQuestion("q.cancel_order");
    if(!(h ?? true)) return;
    delId = order.id ?? "";
    await RestApi.removeOrder(order);
    delId = "";
    EasyLoading.showSuccess('msg.order_canceled'.T());
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);

    List<Order> orders = model.openOrders(widget.cur);
    if(orders.isEmpty) return const ZeroWidget();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 18.0, bottom: 8),
        child: Text("orders.open".T(), style: AppStyles.greyText,),
      ),
      const ListTileDiv(),
      ...orders.map((order) => OrderRow(
        order: order,
        action: delId == order.id ? const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
              width: 25, height: 25,
              child: CircularProgressIndicator(strokeWidth: 2,)),
        ) : IconButton(
          icon: const Icon(Icons.remove_circle_outlined, color: AppColors.accent,),
          onPressed: () => _removeOrder(order),
        ),
      ),),
      Container(height: 20,),
    ],);
  }
}
