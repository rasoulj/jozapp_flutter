
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/models/login_response.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class BranchInfo extends StatelessWidget {
  final AppSettings? settings;

  const BranchInfo({Key? key, required this.settings})
      : super(key: key);

  Branch get branch => RestApi.appModel.branch ?? Branch();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      // negative: true,
      bodyColor: AppColors.accent,
      fromTop: true,
      headerColor: AppColors.white,
      headerSection: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(branch.displayName ?? "NA", style: AppStyles.darkText24Bold,),
        ],
      ),
      onBack: Get.back,
      title: "profile.branch_info",
      body: PadV(child: body, padding: 16,),
    );
  }

  Widget get body =>
      ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
                radius: 40,
                child: branch.defCurrency.icon()),
            title: Text(
              branch.defCurrency.longName, style: AppStyles.whiteText24,),
            subtitle: Text(
              "profile_def_currency".T(), style: AppStyles.whiteTextB,),
          ),
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.accent,
                radius: 40,
                child: Icon(Icons.home_work_outlined, size: 32,)),
            title: Text(branch.address ?? "-", style: AppStyles.whiteText24,),
            subtitle: Text("profile.address".T(), style: AppStyles.whiteTextB,),
          ),
          ListTile(
            onTap: () => openLink(branch.phone, "tel:"),
            trailing: const Icon(Icons.chevron_right, color: AppColors.white,),
            leading: const CircleAvatar(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.accent,
                radius: 40,
                child: Icon(Icons.phone, size: 32,)),
            title: FutureBuilder<String>(
              future: formatPhone(branch.phone ?? "-"),
              builder: (context, snapshot) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(snapshot.data ?? "-", style: AppStyles.whiteText24,));
              }
            ),
            subtitle: Text("profile.phone".T(), style: AppStyles.whiteTextB,),
          ),
        ],
      );
}
