// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:jozapp_flutter/models/types.dart';

import 'wid.dart';

class LoginResponse {
  LoginResponse({
    this.user,
    this.authToken,
    this.branch,
    this.agency,
  });

  final User? user;
  final String? authToken;
  final Branch? branch;
  final Agency? agency;

  LoginResponse copyWith({
    User? user,
    String? authToken,
    Branch? branch,
    Agency? agency,
  }) =>
      LoginResponse(
        user: user ?? this.user,
        authToken: authToken ?? this.authToken,
        branch: branch ?? this.branch,
        agency: agency ?? this.agency,
      );

  factory LoginResponse.fromRawJson(String str) => LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Json json) => LoginResponse(
    user: User.fromJson(json["user"]),
    authToken: json["authToken"],
    branch: Branch.fromJson(json["branch"]),
    agency: Agency.fromJson(json["agency"]),
  );

  Json toJson() => {
    "user": user?.toJson(),
    "authToken": authToken,
    "branch": branch?.toJson(),
    "agency": agency?.toJson(),
  };
}

class Agency {
  Agency({
    this.verified,
    this.referred,
    this.id,
    this.role,
    this.password,
    this.phone,
    this.address,
    this.uid,
    this.webUrl,
    this.supportEmail,
    this.supportTel,
    this.logo2,
    this.logo3,
    this.displayName,
    this.copyrightTitle,
    this.defaultLang,
    this.hideSelectCurrencies,
    this.aid,
    this.bid,
    this.supportTel2,
    this.wid,
    this.createdAt,
    this.updatedAt,
  });

  final bool? verified;
  final bool? referred;
  final String? id;
  final String? role;
  final String? password;
  final String? phone;
  final String? address;
  final String? uid;
  final String? webUrl;
  final String? supportEmail;
  final String? supportTel;
  final String? logo2;
  final String? logo3;
  final String? displayName;
  final String? copyrightTitle;
  final String? defaultLang;
  final bool? hideSelectCurrencies;
  final String? aid;
  final String? bid;
  final String? supportTel2;
  final Wid? wid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Agency copyWith({
    bool? verified,
    bool? referred,
    String? id,
    String? role,
    String? password,
    String? phone,
    String? address,
    String? uid,
    String? webUrl,
    String? supportEmail,
    String? supportTel,
    String? logo2,
    String? logo3,
    String? displayName,
    String? copyrightTitle,
    String? defaultLang,
    bool? hideSelectCurrencies,
    String? aid,
    String? bid,
    String? supportTel2,
    Wid? wid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Agency(
        verified: verified ?? this.verified,
        referred: referred ?? this.referred,
        id: id ?? this.id,
        role: role ?? this.role,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        uid: uid ?? this.uid,
        webUrl: webUrl ?? this.webUrl,
        supportEmail: supportEmail ?? this.supportEmail,
        supportTel: supportTel ?? this.supportTel,
        logo2: logo2 ?? this.logo2,
        logo3: logo3 ?? this.logo3,
        displayName: displayName ?? this.displayName,
        copyrightTitle: copyrightTitle ?? this.copyrightTitle,
        defaultLang: defaultLang ?? this.defaultLang,
        hideSelectCurrencies: hideSelectCurrencies ?? this.hideSelectCurrencies,
        aid: aid ?? this.aid,
        bid: bid ?? this.bid,
        supportTel2: supportTel2 ?? this.supportTel2,
        wid: wid ?? this.wid,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Agency.fromRawJson(String str) => Agency.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Agency.fromJson(Json json) => Agency(
    verified: json["verified"],
    referred: json["referred"],
    id: json["_id"],
    role: json["role"],
    password: json["password"],
    phone: json["phone"],
    address: json["address"],
    uid: json["uid"],
    webUrl: json["webUrl"],
    supportEmail: json["supportEmail"],
    supportTel: json["supportTel"],
    logo2: json["logo2"],
    logo3: json["logo3"],
    displayName: json["displayName"],
    copyrightTitle: json["copyrightTitle"],
    defaultLang: json["defaultLang"],
    hideSelectCurrencies: json["hideSelectCurrencies"],
    aid: json["aid"],
    bid: json["bid"],
    supportTel2: json["supportTel2"],
    wid: Wid.fromJson(json),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Json toJson() => {
    "verified": verified,
    "referred": referred,
    "_id": id,
    "role": role,
    "password": password,
    "phone": phone,
    "address": address,
    "uid": uid,
    "webUrl": webUrl,
    "supportEmail": supportEmail,
    "supportTel": supportTel,
    "logo2": logo2,
    "logo3": logo3,
    "displayName": displayName,
    "copyrightTitle": copyrightTitle,
    "defaultLang": defaultLang,
    "hideSelectCurrencies": hideSelectCurrencies,
    "aid": aid,
    "bid": bid,
    "supportTel2": supportTel2,
    "wid": wid,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Branch {
  Branch({
    this.defCurrency = CurTypes.usd,
    this.verified,
    this.referred,
    this.id,
    this.aid,
    this.displayName,
    this.address,
    this.status,
    this.phone,
    this.role,
    this.validFrom,
    this.validTo,
    this.password,
    this.loggedUid,
    this.wid,
    this.uid,
    this.createdAt,
    this.updatedAt,
  });

  final CurTypes defCurrency;
  final bool? verified;
  final bool? referred;
  final String? id;
  final String? aid;
  final String? displayName;
  final String? address;
  final String? status;
  final String? phone;
  final String? role;
  final DateTime? validFrom;
  final DateTime? validTo;
  final String? password;
  final String? loggedUid;
  final Wid? wid;
  final String? uid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Branch copyWith({
    CurTypes defCurrency = CurTypes.usd,
    bool? verified,
    bool? referred,
    String? id,
    String? aid,
    String? displayName,
    String? address,
    String? status,
    String? phone,
    String? role,
    DateTime? validFrom,
    DateTime? validTo,
    String? password,
    String? loggedUid,
    Wid? wid,
    String? uid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Branch(
        defCurrency: defCurrency,
        verified: verified ?? this.verified,
        referred: referred ?? this.referred,
        id: id ?? this.id,
        aid: aid ?? this.aid,
        displayName: displayName ?? this.displayName,
        address: address ?? this.address,
        status: status ?? this.status,
        phone: phone ?? this.phone,
        role: role ?? this.role,
        validFrom: validFrom ?? this.validFrom,
        validTo: validTo ?? this.validTo,
        password: password ?? this.password,
        loggedUid: loggedUid ?? this.loggedUid,
        wid: wid ?? this.wid,
        uid: uid ?? this.uid,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Branch.fromRawJson(String str) => Branch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Branch.fromJson(Json json) => Branch(
    defCurrency: toCurTypes(json["defCurrency"]),
    verified: json["verified"],
    referred: json["referred"],
    id: json["_id"],
    aid: json["aid"],
    displayName: json["displayName"],
    address: json["address"],
    status: json["status"],
    phone: json["phone"],
    role: json["role"],
    // validFrom: DateTime.parse(json["validFrom"]),
    // validTo: DateTime.parse(json["validTo"]),
    password: json["password"],
    loggedUid: json["logged_uid"],
    wid: Wid.fromJson(json),
    uid: json["uid"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Json toJson() => {
    "defCurrency": defCurrency.name,
    "verified": verified,
    "referred": referred,
    "_id": id,
    "aid": aid,
    "displayName": displayName,
    "address": address,
    "status": status,
    "phone": phone,
    "role": role,
    "validFrom": validFrom?.toIso8601String(),
    "validTo": validTo?.toIso8601String(),
    "password": password,
    "logged_uid": loggedUid,
    "wid": wid,
    "uid": uid,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class User {
  User({
    this.verified,
    this.referred,
    this.id,
    this.bid,
    this.displayName,
    this.aid,
    this.role,
    this.address,
    this.phone,
    this.referPhone,
    this.wid,
    this.uid,
    this.createdAt,
    this.updatedAt,
    this.loggedUid,
  });

  final bool? verified;
  final bool? referred;
  final String? id;
  final String? bid;
  final String? displayName;
  final String? aid;
  final String? role;
  final String? address;
  final String? phone;
  final String? referPhone;
  final Wid? wid;
  final String? uid;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? loggedUid;

  User copyWith({
    bool? verified,
    bool? referred,
    String? id,
    String? bid,
    String? displayName,
    String? aid,
    String? role,
    String? address,
    String? phone,
    String? referPhone,
    Wid? wid,
    String? uid,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? loggedUid,
  }) =>
      User(
        verified: verified ?? this.verified,
        referred: referred ?? this.referred,
        id: id ?? this.id,
        bid: bid ?? this.bid,
        displayName: displayName ?? this.displayName,
        aid: aid ?? this.aid,
        role: role ?? this.role,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        referPhone: referPhone ?? this.referPhone,
        wid: wid ?? this.wid,
        uid: uid ?? this.uid,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        loggedUid: loggedUid ?? this.loggedUid,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Json json) => User(
    verified: json["verified"],
    referred: json["referred"],
    id: json["_id"],
    bid: json["bid"],
    displayName: json["displayName"],
    aid: json["aid"],
    role: json["role"],
    address: json["address"],
    phone: json["phone"],
    referPhone: json["referPhone"],
    wid: Wid.fromJson(json),
    uid: json["uid"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    loggedUid: json["logged_uid"],
  );

  Json toJson([bool toSent = false]) => {
    "verified": verified,
    "referred": referred,
    if(!toSent) "_id": id,
    "bid": bid,
    "displayName": displayName,
    "aid": aid,
    "role": role,
    "address": address,
    "phone": phone,
    "referPhone": referPhone,
    "wid": wid?.value,
    "uid": uid,
    if(!toSent) "createdAt": createdAt?.toIso8601String(),
    if(!toSent) "updatedAt": updatedAt?.toIso8601String(),
    "logged_uid": loggedUid,
  };

  @override
  String toString() {
    return displayName ?? "NA";
  }
}
