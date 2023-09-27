import 'package:flutter/material.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/widgets/ok_view.dart';
import 'package:provider/provider.dart';

class ConfirmView extends StatelessWidget {
  final OrderTypes type;
  final int closeTimes;
  const ConfirmView({Key? key, this.type = OrderTypes.all, this.closeTimes = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);

    return OkView(
      closeTimes: closeTimes,
      title: "msg.your_operation".T(type.longName), // "Your ${type.longName} Was",
      onClose: () async {
        model.loading = true;
        await RestApi.loadOrders();
        await RestApi.loadWallet();
        model.loading = false;
      },
    );

    // return Scaffold(
    //   body: Container(
    //     width: Get.width,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         const Icon(Icons.check_box, size: 250, color: AppColors.white,),
    //         Text("Your ${type.longName} Was", style: AppStyles.whiteText32,),
    //         const Text("Successful !", style: AppStyles.whiteText40,),
    //         Padding(
    //           padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
    //           child: GenButton(
    //             loading: model.loading,
    //             icon: Icons.keyboard_arrow_left,
    //             color: AppColors.white,
    //             onPressed: () async {
    //               model.loading = true;
    //               await RestApi.loadOrders();
    //               await RestApi.loadWallet();
    //               model.loading = false;
    //               Get.close(closeTimes);
    //             // Get.back();
    //           }, title: "Back To Home",),
    //         ),
    //       ],
    //     ),
    //     decoration: BoxDecoration(
    //
    //       gradient: LinearGradient(
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter,
    //           colors: [
    //         Colors.green.shade300,
    //         Colors.green.shade900,
    //       ])
    //     ),
    //   ),
    // );
  }
}
