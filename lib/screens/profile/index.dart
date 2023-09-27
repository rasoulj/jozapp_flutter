
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/models/lang_option.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/screens/profile/about_us.dart';
import 'package:jozapp_flutter/screens/profile/branch_info.dart';
import 'package:jozapp_flutter/screens/profile/change_password.dart';
import 'package:jozapp_flutter/screens/profile/user_settings.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class _Option {
  final IconData icon;
  final String title;
  final int index;

  _Option(this.icon, this.title, this.index);

  static final List<_Option> all = [
    _Option(Icons.home, "profile.branch_info", 0),
    _Option(Icons.language, "profile.change_lang", 1),
    _Option(Icons.lock, "profile.change_password", 2),
    _Option(Icons.info, "profile.about_us", 3),
    _Option(Icons.logout, "auth.logout", 4),
  ];

  Widget getWidget(ValueChanged<int>? onTap) => ListTile(
    onTap: onTap != null ? () => onTap(index) : null,
    title: Text(title.T(), style: AppStyles.whiteText,),
    leading: Icon(icon, color: AppColors.white,),
    trailing: index == 1 ? const SelectLangWidget() : const Icon(Icons.chevron_right, color: AppColors.white,),
  );
}

class ProfileScreen extends StatefulWidget {
  final SembastDb? db;
  final AppSettings? settings;
  final VoidCallback? gotoHome;

  const ProfileScreen({Key? key, this.db, this.gotoHome, required this.settings}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void onTap(int index) async {
    switch(index) {
      case 0:
        Get.to(() => BranchInfo(settings: widget.settings,),
            opaque: true,
            transition: Transition.fadeIn
        );
        break;
      case 1:
        return;
        Get.to(() => UserSettings(settings: widget.settings,),
            opaque: true,
            transition: Transition.fadeIn
        );
        break;
      case 2:
        Get.to(() => ChangePassword(settings: widget.settings,),
            opaque: true,
            transition: Transition.fadeIn
        );
        break;
      case 3:
        Get.to(() => AboutUs(settings: widget.settings,),
            opaque: true,
            transition: Transition.fadeIn
        );
        break;
      case 4:
        RestApi.logout();
        break;

      default:


    }
    return;

    // var model = Provider.of<AppDataModel>(context, listen: false);
  }

  final ScreenshotController _controller = ScreenshotController();


  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: false);

    return BaseScreen(
      onBack: widget.gotoHome,
      title: "main.profile",

      headerSection: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("profile.your_wallet".T(), style: AppStyles.whiteText24,),
                    PadV(
                      padding: 8,
                      child: Row(
                        children: [
                          IconButton(onPressed: () {
                            Clipboard.setData(ClipboardData(text: model.user?.wid?.formal ?? "NA"));
                            showInfo("msg.wallet.copied");
                          }, icon: const Icon(Icons.copy, color: AppColors.white,)),
                          Text(model.user?.wid?.formal ?? "NA", style: AppStyles.whiteCourierB,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Screenshot(
                    controller: _controller,
                    child: GestureDetector(
                      onTap: () => _controller.shareIt("profile.your_wallet".T()+"\n"+(model.user?.wid?.formal ?? "NA")),
                      child: QrImage(
                        semanticsLabel: "Wallet Number",
                        foregroundColor: AppColors.white,
                        // backgroundColor: AppColors.white,
                        padding: EdgeInsets.zero,
                        data: model.user?.wid?.toQrCode ?? "NA",
                        version: QrVersions.auto,
                        size: 100.0,
                      ),
                    ),
                  ),
                  // const Icon(Icons.qr_code_outlined, color: AppColors.white,),
                ],
              ))
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: _Option.all.map((e) => e.getWidget(onTap)).toList(),
        ),
      ),
    );
  }
}
