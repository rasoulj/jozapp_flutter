import 'dart:developer';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/models/types.dart';

const String _settingsColValue = "value";
const String _settingsCol = "settings";


Future<void> setSetting(SembastDb db, String key, dynamic value) async {
  try {
    Json doc = {};
    doc[_settingsColValue] = value;
    doc["_id"] = key;
    await db.setData(_settingsCol, doc, id: key);
  } catch(e) {
    log(e.toString());
  }
}

Future<dynamic> getSetting(SembastDb db, String key, {dynamic defValue}) async {
  try {
    Json? res = await db.doc(_settingsCol, key);
    if(res != null && res.containsKey(_settingsColValue)) {
      return res[_settingsColValue];
    } else {
      return defValue;
    }
  } catch(e) {
    log(e.toString());
    return defValue;
  }
}