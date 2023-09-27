
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/simple_picker.dart';


class LangOption {
  final String label;
  final String code;
  final String flag;

  @override
  String toString() {
    return label;
  }

  Widget icon([double size = 32]) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      boxShadow: AppStyles.boxShadow,
    ),
    child: Image.asset("assets/flags/$flag.png"),
  );

  LangOption({this.flag = "", this.label = "", this.code = ""});

  static final List<LangOption> all = [
    LangOption(label: "عربى", code: "ar", flag: "iqd"),
    LangOption(label: "فارسی", code: "fa", flag: "irr"),
    LangOption(label: "English", code: "en", flag: "usd"),
    // LangOption(label: "中文", code: "zh", flag: "zh"),
    // LangOption(label: "Türk", code: "tr", flag: "tr"),
    // LangOption(label: "Kurdî", code: "ckb", flag: "ckb"),
  ];

  static LangOption findCode(String? code) {
    return all.firstWhere((e) => e.code == code, orElse: () => all.first);
  }

}

class SelectLangWidget extends StatelessWidget {
  // final AppSettings? settings;
  const SelectLangWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SembastDb?>(
      future: SembastDb.init(),
      builder: (context, snapshot) {
        SembastDb? db = snapshot.hasData ? snapshot.data : null;
        if(db == null) return LangOption.all.first.icon();

        return StreamBuilder<AppSettings>(
          stream: AppSettings.getStream(db),
          builder: (context, snapshot) {
            var lang = snapshot.hasData ? snapshot.data?.lang ?? AppConfig.defLang : AppConfig.defLang;
            var value = LangOption.findCode(lang);
            return SimplePicker<LangOption>(
              iconBuilder: (option) => option.icon(),
              child: value.icon(),
              value: value,
              items: LangOption.all,
              onChanged: (option) async {
                await AppSettings.saveSetting(db, lang: option.code);
              },
            );
          }
        );
      }
    );
  }
}
