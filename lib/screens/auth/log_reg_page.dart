

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/screens/auth/main_page.dart';
import 'package:jozapp_flutter/screens/auth/reg_page.dart';

import 'auth_btns.dart';
import 'bio_login.dart';
import 'login_page.dart';

const String authLoginText = "login";
const authRegisterText = "register";
const authForgotText = "auth.forget_pass";
const authSendVerificationCodeText = "auth.send_sms";



class LogReg extends StatelessWidget {
  final AppSettings? settings;
  final SembastDb? db;

  const LogReg({Key? key, required this.settings, this.db}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: AuthHeroButton(onPressed: () async {
            await Get.to(() => MainPage(
              settings: settings,
              child: LoginPage(settings: settings,),),
                opaque: true,
                transition: Transition.fadeIn
            );
          }, title: authLoginText,),
        ),
        AuthHeroButton(
          color: const Color(0x4dffffff),
          onPressed: () async {
          await Get.to(() => MainPage(
            settings: settings,
            child: RegPage(settings: settings,),),
            opaque: true,
            transition: Transition.fadeIn
          );
        }, title: authRegisterText,),
        BioLogin(settings: settings, db: db,),
      ],
    );
  }
}


