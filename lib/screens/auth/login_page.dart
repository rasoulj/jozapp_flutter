import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/screens/auth/forgot_page.dart';
import 'package:jozapp_flutter/screens/auth/main_page.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:jozapp_flutter/widgets/input_ex.dart';
import 'package:jozapp_flutter/widgets/phone_input.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

import 'auth_btns.dart';
import 'log_reg_page.dart';

class LoginPage extends StatefulWidget {
  final AppSettings? settings;

  const LoginPage({Key? key, required this.settings}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AppController? _c;

  @override
  void initState() {
    _c = AppController(this);
    super.initState();
  }


  String get phoneNumber =>
      _c?.getValue("phoneNumber") ?? AppConfig.defPhoneCode;

  String get password => _c?.getValue("password") ?? "";

  set password(String value) => _c?.setValue("password", value);


  Future<List<String>> get checkErrors async {
    bool pe = await validPhone("+$phoneNumber");
    log(phoneNumber);
    List<String> errs = [];
    if (!pe) errs.add("err.invalid_phone");
    if (!validLength(password)) errs.add("err.invalid_password");
    return errs;
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(tag: authLoginText, child: Material(
              color: Colors.transparent,
              child: Text(authLoginText.T(), style: AppStyles.whiteText32,))),
          PadV(
            child: PhoneInput(controller: _c, field: "phoneNumber",),
          ),
          PadV(
            child: InputEx(controller: _c,
                field: "password",
                hintText: "auth.password",
                isPassword: true),
          ),
          PadV(
            padding: 8,
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: AuthBackButton(),
                ),
                Expanded(
                  flex: 3,
                  child: GenButton(
                    // dark: false,
                    color: const Color(0xffd6d6d6),
                    loading: model.loading,
                    title: authLoginText,
                    icon: Icons.login,
                    onPressed: () async {
                      var err = await checkErrors;
                      if (err.isNotEmpty) {
                        showErrors(err);
                        return;
                      }
                      // var res = await RestApi.login("+989356846482", "123456");
                      // var res = await RestApi.login("+989133834093", "123456");
                      // var res = await RestApi.login("+989133834091", "123456");
                      var res = await RestApi.login("+$phoneNumber", password);

                      if (res) {
                        Get.back();
                      }
                    },),
                ),
              ],
            ),
          ),

          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Center(child: Icon(Icons.fingerprint, size: 50, color: AppColors.white,)),
          // ),

          Center(child: TextButton(onPressed: () async {
            log("message");
            Get.back();
            await Get.to(() =>
                MainPage(
                  settings: widget.settings,
                  child: ForgotPasswordPage(settings: widget.settings,),
                ),
                opaque: true,
                transition: Transition.fadeIn
            );
          }, child: Hero(
              tag: authForgotText,
              child: Text(authForgotText.T(), style: AppStyles.whiteText,)))),
          // const _BackButton(),
        ],
      ),
    );
  }
}
