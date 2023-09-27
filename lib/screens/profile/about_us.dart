import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/models/login_response.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class _PhoneView extends StatelessWidget {
  final String phone;
  const _PhoneView({Key? key, this.phone = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<String>(
      future: formatPhoneE164(phone),
      builder: (context, snapshot) {
        var ph = snapshot.data ?? "-";
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextButton(
              onPressed: () => openLink(ph, "tel:"),
              child: Text(phone, style: AppStyles.whiteCourierB,),
          ),
          IconButton(
              onPressed: () => openLink(ph, "tel:"),
              icon: const Icon(Icons.phone, color: CupertinoColors.activeBlue,),
          ),
          IconButton(
              onPressed: () => openLink(ph, "whatsapp://send?text=&phone="),
              icon: const Icon(FontAwesomeIcons.whatsapp, color: CupertinoColors.activeGreen,),
          ),
        ],);
      }
    );
  }
}


class AboutUs extends StatelessWidget {
  final AppSettings? settings;

  const AboutUs({Key? key, required this.settings})
      : super(key: key);

  Agency get agency => RestApi.appModel.agency ?? Agency();



  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      negative: true,
      fromTop: true,
      onBack: Get.back,
      title: "profile.about_us",
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(children: [
            SizedBox(width: Get.width / 2,
                child: Image.asset("assets/images/qr-code.png")),
            PadV(
              child: TextButton(
                  onPressed: () => openLink(agency.webUrl),
                  child: Text(agency.webUrl ?? "-", style: AppStyles.whiteCourierB,)),
            ),
            TextButton(
                onPressed: () => openLink(agency.supportEmail, "mailto:"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.email, color: AppColors.white,),
                    ),
                    Text(agency.supportEmail ?? "-", style: AppStyles.whiteCourierB,),
                ],),
            ),
            _PhoneView(phone: agency.supportTel ?? "-",),
            _PhoneView(phone: agency.supportTel2 ?? "-",),
            const Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Text("Version: ${AppConfig.version}", style: AppStyles.whiteTextB,),
            ),
          ],),
        ),
      ),
    );
  }
}
