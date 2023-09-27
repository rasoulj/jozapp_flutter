// To parse this JSON data, do
//
//     final jozSettings = jozSettingsFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/models/types.dart';

const String singleDocsCollection = "singleDocsCollection";


class AppSettings {
  static const String docId = "JozSettings";

  static const String kID = "_id";
  static const String kPhoneNumber = "phoneNumber";
  static const String kPassword = "password";
  static const String kLang = "lang";
  static const String kIntVal = "intVal";
  static const String kBoolVal = "boolVal";

  static Stream<AppSettings> getStream(SembastDb db) {
    Stream<Json?> res = db.docStream(singleDocsCollection, docId);
    return res.map((json) => AppSettings.fromJson(json));
  }

  static Future<void> saveSetting(SembastDb? db, {
    String? phoneNumber,
    String? password,
    String? lang,
    int? intVal,
    bool? boolVal,
  }) async {

    Json doc = {
      if(phoneNumber != null) kPhoneNumber: phoneNumber,
      if(password != null) kPassword: password,
      if(lang != null) kLang: lang,
      if(intVal != null) kIntVal: intVal,
      if(boolVal != null) kBoolVal: boolVal,
    };

    log(doc.toString());

    await db?.setData(singleDocsCollection, doc, id: docId, merge: true);
  }

  const AppSettings({
    this.phoneNumber,
    this.password,
    this.lang = AppConfig.defLang,
    this.intVal,
    this.boolVal,
  });

  final String? phoneNumber;
  final String? password;
  final String lang;
  final int? intVal;
  final bool? boolVal;

  // static const AppSettings empty = const AppSettings();

  AppSettings copyWith({
    String? phoneNumber,
    String? password,
    String? lang,
    int? intVal,
    bool? boolVal,
  }) =>
      AppSettings(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
        lang: lang ?? this.lang,
        intVal: intVal ?? this.intVal,
        boolVal: boolVal ?? this.boolVal,
      );

  factory AppSettings.fromRawJson(String str) => AppSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppSettings.fromJson(Json? json) {
    var ret = json == null ? const AppSettings() : AppSettings(
    phoneNumber: json[kPhoneNumber],
    password: json[kPassword],
    lang: getStringField(json, kLang, defValue: AppConfig.defLang),
    intVal: 0, //json[kIntVal],
    boolVal: false,// json[kBoolVal],
  );
    return ret;
  }

  Json toJson() => {
    kPhoneNumber: phoneNumber,
    kPassword: password,
    kLang: lang,
    kIntVal: intVal,
    kBoolVal: boolVal,
  };

  @override
  String toString() {
    // TODO: implement toString
    return "lang: $lang, phoneNumber: $phoneNumber, password: $password";
  }
}
