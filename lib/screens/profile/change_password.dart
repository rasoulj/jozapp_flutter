import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:jozapp_flutter/widgets/input_ex.dart';
import 'package:jozapp_flutter/widgets/input_ex2.dart';
import 'package:jozapp_flutter/widgets/no_content.dart';
import 'package:jozapp_flutter/widgets/ok_view.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  final AppSettings? settings;
  const ChangePassword({Key? key, required this.settings}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  AppController? _c;

  @override
  void initState() {
    _c = AppController(this);
    super.initState();
  }

  String get curPassword => _c?.getValue("curPassword") ?? "";
  String get newPassword => _c?.getValue("newPassword") ?? "";
  String get confirm => _c?.getValue("confirm") ?? "";


  Future<List<String>> get checkErrors async {
    List<String> errs = [];
    if(!validLength(curPassword)) errs.add("err.invalid_password");
    if(newPassword != confirm) errs.add("err.passwords_match");
    return errs;
  }

  void changePassword() async {
    var errors = await checkErrors;
    if(errors.isNotEmpty) {
      showErrors(errors);
      return;
    }

    var resp = await RestApi.changePassword(curPassword, newPassword);
    if(!resp.ok) {
      showErrors([resp.message ?? "err.set_password"]);
      return;
    } else {
      showInfo(resp.message);

      Get.to(() =>
      const OkView(
        title: "msg.change_password",
        closeTimes: 2,
      ));
    }
  }

  Widget get navButton {
    var model = Provider.of<AppDataModel>(context, listen: true);
    return GenButton(
      loading: model.loading,
      icon: Icons.lock,
      rightIcon: true,
      color: AppColors.accent,
      onPressed: changePassword,
      title: "profile.change_password",
    );
  }

  @override
  Widget build(BuildContext context) {



    return BaseScreen(
      fromTop: true,
      bodyColor: AppColors.white,
      onBack: Get.back,
      title: "profile.change_password",
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            PadV(
              child: InputEx2(
                  title: "auth.curPassword",
                  controller: _c, field: "curPassword", hintText: "auth.curPassword", isPassword: true),
            ),
            PadV(
              child: InputEx2(
                  title: "auth.newPassword",
                  controller: _c, field: "newPassword", hintText: "auth.newPassword", isPassword: true),
            ),
            PadV(
              child: InputEx2(
                  title: "auth.confirm",
                  controller: _c, field: "confirm", hintText: "auth.confirm", isPassword: true),
            ),
            PadV(
              padding: 16,
              child: navButton,
            ),

          ],
        ),
      ),
    );
  }
}
