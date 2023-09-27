
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jozapp_flutter/aticket/providers/ticket_model.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/utils/etc.dart';

const ALL_FIELDS = [
  ["latinFirstName", "latinLastName", "firstName", "lastName", "nationalCode", "birthDay"],
  ["latinFirstName", "latinLastName", "birthDay", "nationality", "passportIssueCountry", "passportNumber", "passportExpireDate"],
  ["latinFirstName", "latinLastName", "birthDay", "nationalCode", "passportIssueCountry", "passportNumber", "passportExpireDate"],
];

bool _checkName(String? name) {
  String nn = name ?? "";
  return nn.length >= 2 && nn.length <= 50;
}

RegExp _regName = RegExp(r"/^[a-zA-Z]+/");
bool _checkNameEn(String name) => _checkName(name);// && _regName.hasMatch(name);
bool _checkNameFa(String name) => _checkName(name) && !_regName.hasMatch(name);

bool _checkCodeMelli(String? codeMelli) {
  String code = codeMelli ?? "";
  int L = code.length;

  if(L < 8 || int.tryParse(code) == null) return false;
  code = ('0000' + code).substring(L+4-10);
  if(int.tryParse(code.substring(3,9)) == null) return false;
  int? c = int.tryParse(code.substring(9, 10));
  int s = 0;
  for(int i=0; i<9; i++) {
    s += (int.tryParse(code.substring(i, i+1)) ?? 0)*(10 - i);
  }
  s = s % 11;
  return (s < 2 && c == s) || (s >= 2 && c == (11 - s));
}

bool _checkPassportNumber(String? pas) {
  return (pas ?? "").length >= 4;
}

const _passengerTypeCodes = ["ADT", "CHD", "INF"];
const _namePrefixes = ["MR", "MS", "MSTR", "MISS"];
const _typesString = ["Adult", "Child", "Infant"];


class Passenger {
  final int type;

  // final int passengerValidationType;
  final String? latinFirstName;
  final String? latinLastName;

  // final String? firstName;
  // final String? lastName;
  final int gender;
  final String? nationalCode;
  final DateTime? birthDay;

  // final String? nationality;
  // final String? passportIssueCountry;
  final String? passportNumber;
  final DateTime? passportExpireDate;
  final bool isForeigners;

  Passenger({
    this.isForeigners = false,
    this.type = 0, //0 for Adult, 1 for child, 2 for infant
    // this.passengerValidationType = 2, //1 International, 2 for Domestic
    this.gender = 0, ////0 for female, 1 for male
    this.latinFirstName,
    this.latinLastName,
    // this.firstName,
    // this.lastName,
    this.nationalCode,
    this.birthDay,
    // this.nationality = "IQ",
    // this.passportIssueCountry = "IQ",
    this.passportNumber,
    this.passportExpireDate,
  }) {
    assert(type >= 0 && type <= 2, "Invalid type");
    // assert(passengerValidationType >= 1 && passengerValidationType <= 2, "Invalid passengerValidationType");
    assert(gender == 0 || gender == 1, "Invalid gender");
  }

  Passenger copyWith({
    int? type,
    String? latinFirstName,
    String? latinLastName,
    int? gender,
    String? nationalCode,
    DateTime? birthDay,
    String? passportNumber,
    DateTime? passportExpireDate,
    bool? isForeigners,
  }) =>
      Passenger(
        type: type ?? this.type,
        latinFirstName: latinFirstName ?? this.latinFirstName,
        latinLastName: latinLastName ?? this.latinLastName,
        gender: gender ?? this.gender,
        nationalCode: nationalCode ?? this.nationalCode,
        birthDay: birthDay ?? this.birthDay,
        passportNumber: passportNumber ?? this.passportNumber,
        passportExpireDate: passportExpireDate ?? this.passportExpireDate,
        isForeigners: isForeigners ?? this.isForeigners,
      );


  int get _preIndex => 2 * (type == 0 ? 0 : 1) + 1 - gender;

  bool get isEmpty => name == " ";

  String get name => "${latinFirstName ?? ""} ${latinLastName ?? ""}";

  Json toDoc() =>
      {
        "PersonName": {
          "GivenName": (latinFirstName ?? "").toUpperCase(),
          "NamePrefix": _namePrefixes[_preIndex], // gender === 0 ? "MR" : "MS",
          "Surname": (latinLastName ?? "").toUpperCase(),
        },
        "Document": {
          "DocID": isForeigners ? passportNumber : nationalCode,
          "DocIssueCountry": "IQ", // isForeigners ? nation : "IR",
          "ExpireDate": isForeigners
              ? passportExpireDate?.formatFormalDate
              : "2025-01-01",
          "InnerDocType": "Passport"
        },
        "NationalId": isForeigners ? passportNumber : nationalCode,
        "BirthDate": birthDay?.formatFormalDate,
        "PassengerTypeCode": _passengerTypeCodes[type],
        "CurrencyCode": "",
        "Email": ""
      };


  factory Passenger.empty(int type) => Passenger(type: type,);

  factory Passenger.fromJson(Json json) =>
      Passenger(
        type: json["type"],
        gender: json["gender"],
        latinFirstName: json["latinFirstName"],
        latinLastName: json["latinLastName"],
        isForeigners: json["isForeigners"],
        nationalCode: json["nationalCode"],
        birthDay: json["birthDay"],
        passportNumber: json["passportNumber"],
        passportExpireDate: json["passportExpireDate"],
      );

  Json toJson() => {
    "type": type,
    "gender": gender,
    "latinFirstName": latinFirstName ?? "",
    "latinLastName": latinLastName ?? "",
    "isForeigners": isForeigners,
    "nationalCode": nationalCode ?? "",
    "birthDay": birthDay,
    "passportNumber": passportNumber ?? "",
    "passportExpireDate": passportExpireDate,
  };

  bool get _validAge {
    double age = -(birthDay ?? DateTime.now()).difference(DateTime.now()).inDays / 365.24;
    log("age: $type, $age");
    if(type == 0) {
      return age > 12;
    } else if(type == 1) {
      return age > 2 && age <= 12;
    } else {
      return age <= 2;
    }

  }

  bool get _validPassportExpiry {
    int daysValid = (passportExpireDate ?? DateTime.now()).difference(TicketModel.i.fromDate ?? DateTime.now()).inDays;
    return daysValid > 0;
  }

  List<String> get errors {
    List<String> e = [];
    if(birthDay == null) {
      e.add("Please enter birthday");
    } else if(!_validAge) {
      e.add("Entered Birth date is not valid");
    }

    if(!_checkNameEn(latinFirstName ?? "")) {
      e.add("First Name is not valid");
    }
    if(!_checkNameEn(latinLastName ?? "")) {
      e.add("Last Name is not valid");
    }

    if(isForeigners) {
      if(passportExpireDate == null) {
        e.add("Please enter expiry date of your passport");
      } else if(!_validPassportExpiry) {
        e.add("Your passport is not valid at flight time");
      }
      if(!_checkPassportNumber(passportNumber)) {
        e.add("Please enter valid passport number");
      }
    } else {
      if(!_checkCodeMelli(nationalCode)) {
        e.add("Entered National code is not valid");
      }
    }


    return e;
  }

  Color get color => type == 0 ? AppColors.accent : type == 1 ? Colors.blueAccent : Colors.pinkAccent;
  String get typeString => _typesString[type];

}