
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/models/login_response.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/screens/auth/reg_page.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:jozapp_flutter/widgets/input_ex.dart';
import 'package:jozapp_flutter/widgets/ok_view.dart';
import 'package:jozapp_flutter/widgets/phone_input.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

import 'auth_btns.dart';
import 'log_reg_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final AppSettings? settings;

  const ForgotPasswordPage({Key? key, required this.settings}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  AppController? _c;

  @override
  void initState() {
    _c = AppController(this);
    super.initState();
  }

  String get phoneNumber => _c?.getValue("phoneNumber") ?? AppConfig.defPhoneCode;
  String get code => _c?.getValue("code") ?? "";
  String get password => _c?.getValue("password") ?? "";
  String get confirm => _c?.getValue("confirm") ?? "";

  int get stage => _c?.getValue("stage") ?? 0;
  set stage(int value) => _c?.setValue("stage", value);

  StagesInfo get stagesInfo => StagesInfo.allForgot[stage];

  @override
  Widget build(BuildContext context) {
    StagesInfo st = stagesInfo;

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(tag: authForgotText, child: Material(
              color: Colors.transparent,
              child: Text(st.title.T(), style: AppStyles.whiteText32,))),
          AnimatedSwitcher(duration: 500.milliseconds, child: body, ),
          navButtons,
        ],
      ),
    );
  }

  Widget get navButtons => PadV(
    padding: 8,
    child: Row(
      children: [
        const Expanded(
          flex: 2,
          child: AuthBackButton(),),
        Expanded(
          flex: 3,
          child: nextButton,
        ),
      ],
    ),
  );

  VoidCallback get action {
    switch(stage) {
      case 0: return checkPhone;
      case 1: return verifyCode;
      case 2: return setPassword;
      default: return () {};
    }
  }

  Future<List<String>> get checkErrors async {
    List<String> errs = [];
    if(!validLength(password)) errs.add("err.invalid_password");
    if(password != confirm) errs.add("err.passwords_match");
    return errs;
  }

  void setPassword() async {
    var errors = await checkErrors;
    if (errors.isNotEmpty) {
      showErrors(errors);
      return;
    }

    var resp = await RestApi.setPassword("+$phoneNumber", password);
    if (!resp.ok) {
      showErrors([resp.message ?? "err.set_password"]);
      return;
    } else {
      showInfo(resp.message);
      Get.to(() =>
      const OkView(
        title: "msg.set_password_was",
        closeTimes: 2,
      ),);
    }
  }

  void verifyCode() async {
    if(!validLength(code, 4)) {
      showErrors(["err.tooShortVerifyCode"]);
      return;
    }
    var resp = await RestApi.verifySms("+$phoneNumber", code);
    if(resp.ok) {
      // showInfo(resp.message);
      stage = 2;
    } else {
      showErrors([resp.message ?? "err.verifyVerificationCode"]);
    }
  }

  void checkPhone() async {
    bool pv = await validPhone("+$phoneNumber");
    if(!pv) {
      showErrors(["err.invalid_phone"]);
      return;
    }

    List<User> users = await RestApi.fetchUsers(phone: "+$phoneNumber");
    if(users.isEmpty) {
      showErrors(["err.userNotExist"]);
      return;
    }
    var resp = await RestApi.sendSms("+$phoneNumber");
    if(!resp.ok) {
      showErrors([resp.message ?? "err.sendingVerificationCode"]);
    } else {
      // showInfo(resp.message);
      stage = 1;
    }
  }

  Widget get nextButton {
    StagesInfo st = stagesInfo;

    var model = Provider.of<AppDataModel>(context, listen: true);
    return GenButton(
      // dark: false,
      color: const Color(0xffd6d6d6),
      loading: model.loading,
      title: st.btnText,
      icon: st.btnIcon,
      onPressed: action,
    );
  }

  Widget get phoneWidget => PadV(
    child: PhoneInput(controller: _c, field: "phoneNumber",),
  );


  Widget get body {
    switch(stage) {
      case 0: return phoneWidget;
      case 1: return PadV(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("auth.enter_ver_code".T(), style: AppStyles.greyText
                ,),
            ),
            InputEx(controller: _c, field: "code", hintText: "auth.code", keyboardType: TextInputType.number,),
          ],
        ),
      );
      case 2: return Column(
        children: [
          PadV(
            child: InputEx(controller: _c, field: "password", hintText: "auth.password", isPassword: true),
          ),
          PadV(
            child: InputEx(controller: _c, field: "confirm", hintText: "auth.confirm", isPassword: true),
          ),

        ],
        key: const ValueKey(2),);
      default: return Container(
        key: const ValueKey(20),
        height: 200,
        color: Colors.redAccent,
      );
    }
  }


}
