

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/models/login_response.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:jozapp_flutter/widgets/input_ex.dart';
import 'package:jozapp_flutter/widgets/ok_view.dart';
import 'package:jozapp_flutter/widgets/phone_input.dart';
import 'package:jozapp_flutter/widgets/simple_picker.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

import 'auth_btns.dart';
import 'log_reg_page.dart';

class StagesInfo {
  final String title;
  final String btnText;
  final IconData btnIcon;
  final int index;

  StagesInfo(this.index, this.title, this.btnText, this.btnIcon);

  static List<StagesInfo> allReg = [
    StagesInfo(0, authRegisterText, "auth.send_sms", Icons.sms),
    StagesInfo(1, "auth.code", "auth.verify_code", Icons.verified_user),
    StagesInfo(2, "auth.user_information", "auth.register_user", Icons.check),
  ];

  static List<StagesInfo> allForgot = [
    StagesInfo(0, authForgotText, "auth.send_sms", Icons.sms),
    StagesInfo(1, "auth.code", "auth.verify_code", Icons.verified_user),
    StagesInfo(2, "auth.set_new_password", "auth.set_password", Icons.check),
  ];
}

class RegPage extends StatefulWidget {
  final AppSettings? settings;

  const RegPage({Key? key, required this.settings}) : super(key: key);

  @override
  State<RegPage> createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  AppController? _c;

  @override
  void initState() {
    _c = AppController(this);
    super.initState();
  }


  String get phoneNumber => _c?.getValue("phoneNumber") ?? AppConfig.defPhoneCode;
  String get displayName => _c?.getValue("displayName") ?? "";
  String get password => _c?.getValue("password") ?? "";
  String get confirm => _c?.getValue("confirm") ?? "";
  String get code => _c?.getValue("code") ?? "";

  List<User> get branches => _c?.getValue("branches") ?? [];
  set branches(List<User> value) => _c?.setValue("branches", value);


  User? get selectedBranch => _c?.getValue("selectedBranch");
  set selectedBranch(User? value) => _c?.setValue("selectedBranch", value);


  int get stage => _c?.getValue("stage") ?? 0;
  set stage(int value) => _c?.setValue("stage", value);

  void checkPhone() async {
    bool pv = await validPhone("+$phoneNumber");
    if(!pv) {
      showErrors(["err.invalid_phone"]);
      return;
    }

    List<User> users = await RestApi.fetchUsers(phone: "+$phoneNumber");
    if(users.isNotEmpty) {
      showErrors(["err.userAlreadyExist"]);
      return;
    }
    var resp = await RestApi.sendSms("+$phoneNumber");
    if(!resp.ok) {
      showErrors([resp.message ?? "err.sendingVerificationCode"]);
      return;
    } else {
      // showInfo(resp.message);
      stage = 1;
    }
  }

  Future<List<String>> get checkErrors async {
    List<String> errs = [];
    if(!validLength(displayName, 3)) errs.add("err.displayName");
    if(!validLength(password)) errs.add("err.invalid_password");
    if(password != confirm) errs.add("err.passwords_match");
    if(branch.id == null) errs.add("auth.select_branch");
    return errs;
  }

  void verifyCode() async {
    if(code.length < 6) {
      showErrors(["err.tooShortVerifyCode"]);
      return;
    }
    var resp = await RestApi.verifySms("+$phoneNumber", code);
    if(resp.ok) {
      branches = await RestApi.fetchUsers(role: "BRANCH");
      log("branches.len: ${branches.length}");
      stage = 2;
    } else {
      showErrors(["err.verifyVerificationCode"]);
    }
  }



  void saveUser() async {
    var errors = await checkErrors;
    if(errors.isNotEmpty) {
      showErrors(errors);
      return;
    }

    var resp = await RestApi.saveUserNoAuth(User(
      bid: branch.id,
      displayName: displayName,
      aid: AppConfig.aid,
      phone: "+$phoneNumber",
    ), password);

    if(!resp.ok) {
      showErrors([resp.message ?? "err.saveUserNoAuth"]);
    } else {
      showInfo(resp.message);
      Get.to(() =>
      const OkView(
        title: "msg.user_creation",
        closeTimes: 2,
      ));
    }

  }


  User get branch {
    if(branches.isEmpty) return User(displayName: "auth.no_branch".T());
    if(branches.length == 1) return branches.first;
    return selectedBranch ?? User(displayName: "(${"auth.select_branch".T()})");
  }

  Widget get selectBranch {
    return SimplePicker<User>(
      title: "auth.select_branch",
      items: branches,
      value: selectedBranch,
      onChanged: (branch) => selectedBranch = branch,
      child: GenButton(
        rightIcon: true,
        title: branch.displayName,
        icon: branches.length > 1 ? Icons.arrow_drop_down : Icons.home_max,
      ),
    );
  }

  StagesInfo get stagesInfo => StagesInfo.allReg[stage];

  VoidCallback get action {
    switch(stage) {
      case 0: return checkPhone;
      case 1: return verifyCode;
      case 2: return saveUser;
      default: return () {};
    }
  }

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
            child: InputEx(controller: _c, field: "displayName", hintText: "auth.displayName"),
          ),
          PadV(
            child: InputEx(controller: _c, field: "password", hintText: "auth.password", isPassword: true),
          ),
          PadV(
            child: InputEx(controller: _c, field: "confirm", hintText: "auth.confirm", isPassword: true),
          ),
          PadV(
            padding: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("auth.select_branch".T(), style: AppStyles.greyText,),
                selectBranch,
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    StagesInfo st = stagesInfo;
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(tag: authRegisterText, child: Material(
              color: Colors.transparent,
              child: Text(st.title.T(), style: AppStyles.whiteText32,))),
          AnimatedSwitcher(duration: 500.milliseconds, child: body, ),
          navButtons,
        ],
      ),
    );
  }

  void onBack() {
    if(stage == 0) {
      Get.back();
    } else {
      stage = 0;
    }
  }

  Widget get phoneWidget => PadV(
    child: PhoneInput(controller: _c, field: "phoneNumber",),
  );

  Widget get navButtons => PadV(
      padding: 8,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AuthBackButton(onPressed: onBack),),
          Expanded(
            flex: 3,
            child: nextButton,
          ),
        ],
      ),
    );

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
}
