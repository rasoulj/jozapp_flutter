// #docregion Demo

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/models/types.dart';

import 'langs/ar.dart';
// import 'langs/ckb.dart';
import 'langs/en.dart';
import 'langs/es.dart';
import 'langs/fa.dart';
import 'langs/tr.dart';
import 'langs/zh.dart';

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }


  static const _localizedValues = <String, Json>{
    'en': en,
    'es': es,
    'fa': fa,
    'tr': tr,
    'zh': zh,
    'ar': ar,
    // 'ckb': ckb,
  };

  static List<String> languages ()=> _localizedValues.keys.toList();
  static List<Locale> locales () => languages().map((e) => Locale(e)).toList();

  String getKey(String key, {String defValue = "NA"}) {
    if(!_localizedValues[locale.languageCode]!.containsKey(key)) return defValue;
    return _localizedValues[locale.languageCode]![key]!;
  }

  Future<void> setLang(SembastDb? db, String lang) async {
    Get.locale = Locale(lang);
    await AppSettings.saveSetting(db, lang: lang);
  }

  String get title {
    return getKey('title');
  }
}
// #enddocregion Demo

// #docregion Delegate
class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalization.languages().contains(locale.languageCode);


  @override
  Future<AppLocalization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
// #enddocregion Delegate


extension StringEx on String? {
  String T([String? arg0]) {
    var context = Get.context;
    if(context == null) return this ?? "NA";
    String ret = AppLocalization.of(Get.context!).getKey(this ?? "NA", defValue: this ?? "NA");

    ret = ret.replaceAll("{0}", arg0 ?? "");
    return ret;
  }
}

bool isRTL() => Directionality.of(Get.context!).toString().contains("rtl");
