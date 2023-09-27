import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:provider/provider.dart';

typedef AsyncVoidCallback = Future<void> Function();


class OkView extends StatelessWidget {
  final String title;
  final int closeTimes;
  final AsyncVoidCallback? onClose;
  const OkView({Key? key, this.title = "", this.closeTimes = 1, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);

    return Scaffold(
      body: Container(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_box, size: 250, color: AppColors.white,),
            Text(title.T(), style: AppStyles.whiteText32,),
            Text("successfully".T(), style: AppStyles.whiteText40,),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
              child: GenButton(
                loading: model.loading,
                icon: Icons.keyboard_arrow_left,
                color: AppColors.white,
                onPressed: () async {
                  if(onClose != null) await onClose!();
                  Get.close(closeTimes-1);
                  Get.back(result: true);
                }, title: "Back",),
            ),
          ],
        ),
        decoration: BoxDecoration(

            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.shade300,
                  Colors.green.shade900,
                ])
        ),
      ),
    );
  }
}
