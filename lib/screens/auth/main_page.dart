
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/models/lang_option.dart';
import 'package:jozapp_flutter/screens/auth/contact_us.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class MainPage extends StatelessWidget {
  final AppSettings? settings;
  final bool changeLang;
  final Widget? child;

  const MainPage(
      {Key? key, this.child, required this.settings, this.changeLang = false})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool keyboardOpen = MediaQuery
        .of(context)
        .viewInsets
        .bottom > 0;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),

        child: GestureDetector(
          onTap: () => Get.focusScope?.unfocus(),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/sign_in_bg.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            height: Get.height,
            child: SafeArea(
              child: Column(
                children: [
                  FlexWalletLogo(
                    keyboardOpen: keyboardOpen,
                  ),
                  Expanded(flex: 9,
                    child: SizedBox(
                      width: visWidth, child: child ?? const ZeroWidget(),),),
                  Expanded(flex: 1, child: Container(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(onPressed: () =>
                            Get.to(() => ContactUs(settings: settings,),
                                opaque: true,
                                transition: Transition.fadeIn),
                            child: Text("auth.contact_us".T(),
                              style: AppStyles.whiteText,)),
                        changeLang ? const SelectLangWidget() : const SizedBox(
                          width: 50,),
                      ],
                    ),
                  )),
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }
}

