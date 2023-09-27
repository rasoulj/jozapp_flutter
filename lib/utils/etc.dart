
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phone_number/phone_number.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

void showToast(String msg) => EasyLoading.showToast(msg.T());
void showInfo(String? msg) {
  if(msg != null) EasyLoading.showInfo(msg.T(), dismissOnTap: true, duration: 1.seconds);
}

void showErrors(List<String> errors) {
  if(errors.isEmpty) return;
  if(errors.length == 1) {
    EasyLoading.showError(errors.first.T(), duration: 10.seconds, dismissOnTap: true, maskType: EasyLoadingMaskType.custom);
  } else {
    String msg = "";
    for (int i = 0; i < errors.length; i++) {
      msg += "[${i + 1}] ${errors[i].T()}\n";
    }
    EasyLoading.showError(msg, duration: 10.seconds, dismissOnTap: true, maskType: EasyLoadingMaskType.custom);
  }
}


void hideKeyboard() {
  Get.focusScope?.unfocus();
}


// String normalWid(String? wid, {String sep = "-"}) {
//   String s = wid ?? "";
//
//   return s.length != 16 ? "INVALID WID" : [
//       s.substring(0, 4),
//       s.substring(4, 8),
//       s.substring(8, 13),
//       s.substring(12),
//     ].join(sep);
// }

final _dateTimeFormatter = DateFormat('yyyy-MM-dd hh:mm');
final _formalDateFormatter = DateFormat('yyyy-MM-dd');
final _dateFormatter = DateFormat('d MMM y');
final _monthFormatter = DateFormat('MMM');
final _timeFormatter = DateFormat("h:mm a");

extension DataTimeExt on DateTime {
  DateTime get getDay => DateTime(year, month, day);
  String get formatDateTime => _dateTimeFormatter.format(this);
  String get formatMonth => _monthFormatter.format(this);
  String get formatDate => _dateFormatter.format(this);
  String get formatFormalDate => _formalDateFormatter.format(this);
  String get formatTime => _timeFormatter.format(this);
  bool get isToday {
    var n = DateTime.now();
    return n.day == day && n.month == month && n.year == year;
  }
  String get toUtcT => toUtc().toString().split(" ").join("T");
}

final _oCcy = NumberFormat("#,##0.0", "en_US");
final _oCcy1 = NumberFormat("#,##0", "en_US");

// String toTwoDigit(double num) => "\$"+_oCcy.format(num);

extension DoubleEx on double {
  String toTwoDigit([bool hasFract = true]) => (hasFract ? _oCcy : _oCcy1).format(this);
}

Future<bool> validPhone(String phone) async {
  try {
    await PhoneNumberUtil().parse(phone);
    return true;
  } catch(e) {
    return false;
  }
}

Future<String> formatPhone(String phone) async {
  try {
    PhoneNumber phoneNumber = await PhoneNumberUtil().parse(phone);
    return phoneNumber.international;
  } catch(e) {
    return "NA";
  }
}

Future<String> formatPhoneE164(String phone) async {
  try {
    PhoneNumber phoneNumber = await PhoneNumberUtil().parse(phone);
    return phoneNumber.e164;
  } catch(e) {
    return "NA";
  }
}


void openLink(String? url, [String? schema]) async {
  String web = (schema != null) ? "$schema${url ?? ""}" : (url ?? "");
  if(await canLaunchUrlString(web)) {
    await launchUrlString(web);
  } else {
    showErrors(["Cannot open: $web"]);
  }
}

bool validLength(String pass, [int len = 5]) {
  return pass.length >= len;
}

Color stringToHslColor(String str, {double s = 0.4875, double l = 0.629167}) {
  var hash =
  (str.isNotEmpty ? str : "AA").trim().runes.reduce((s, i) => i + ((s << 5) - s));
  var h = hash % 360;
  return HSLColor.fromAHSL(1, 1.0 * h, s, l).toColor(); // Color();// 'hsl('+h+', '+s+'%, '+l+'%)';
}

void showLoading([String status = "Loading ..."]) => EasyLoading.show(status: status, maskType: EasyLoadingMaskType.custom, );
void hideLoading() => EasyLoading.dismiss();

// const encodeWID = (wid) => `iw-${wid}-wi`;

extension ScreenshotControllerEx on ScreenshotController {
  Future<void> shareIt([String? text]) async {
    try {
      Uint8List? image = await capture(delay: 10.milliseconds);
      if (image == null) return;
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/image.png').create();
      await imagePath.writeAsBytes(image);

      /// Share Plugin
      await Share.shareFiles([imagePath.path], text: text);
    } catch (e) {
      showToast(e.toString());
    }
  }
}