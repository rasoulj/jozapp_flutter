// To parse this JSON data, do
//
//     final ticketResult = ticketResultFromJson(jsonString);

import 'dart:convert';

import 'package:jozapp_flutter/models/types.dart';

class TicketResult {
  TicketResult({
    this.items,
    this.rollback,
    this.lri,
  });

  bool get success {
    var p = items ?? [];
    if(p.isEmpty) return false;
    return p.first.success ?? false;
  }


  final List<Item>? items;
  final List<Rollback>? rollback;
  final String? lri;

  factory TicketResult.fromRawJson(String str) => TicketResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TicketResult.fromJson(Map<String, dynamic> json) => TicketResult(
    items: List<Item>.from((json["Items"] ?? []).map((x) => Item.fromJson(x))),
    rollback: List<Rollback>.from((json["rollback"] ?? []).map((x) => Rollback.fromJson(x))),
    lri: json["lri"],
  );

  Map<String, dynamic> toJson() => {
    "Items": List<dynamic>.from((items ?? []).map((x) => x.toJson())),
    "rollback": List<dynamic>.from((rollback ?? []).map((x) => x.toJson())),
    "lri": lri,
  };
}

class Item {
  Item({
    this.success,
    this.airItinerary,
  });

  final bool? success;
  final AirItinerary? airItinerary;

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    success: json["Success"],
    airItinerary: AirItinerary.fromJson(json["AirItinerary"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "Success": success,
    "AirItinerary": airItinerary?.toJson(),
  };
}

class AirItinerary {
  AirItinerary({
    this.sessionId,
    this.combinationId,
    this.recommendationId,
    this.subsystemId,
    this.subsystemName,
  });

  final String? sessionId;
  final int? combinationId;
  final int? recommendationId;
  final int? subsystemId;
  final String? subsystemName;

  factory AirItinerary.fromRawJson(String str) => AirItinerary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirItinerary.fromJson(Map<String, dynamic> json) => AirItinerary(
    sessionId: json["SessionId"],
    combinationId: getIntField(json, "CombinationId"),
    recommendationId: getIntField(json, "RecommendationId"),
    subsystemId: getIntField(json, "SubsystemId"),
    subsystemName: json["SubsystemName"],
  );

  Map<String, dynamic> toJson() => {
    "SessionId": sessionId,
    "CombinationId": combinationId,
    "RecommendationId": recommendationId,
    "SubsystemId": subsystemId,
    "SubsystemName": subsystemName,
  };
}

class Rollback {
  Rollback({
    this.action,
    this.data,
  });

  final String? action;
  final Data? data;

  factory Rollback.fromRawJson(String str) => Rollback.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rollback.fromJson(Map<String, dynamic> json) => Rollback(
    action: json["action"],
    data: Data.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    this.orgId,
    this.accountId,
    this.agentId,
    this.companyId,
    this.contractNo,
    this.amount,
    this.currencyId,
    this.currency,
  });

  final int? orgId;
  final int? accountId;
  final int? agentId;
  final int? companyId;
  final String? contractNo;
  final int? amount;
  final int? currencyId;
  final String? currency;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orgId: getIntField(json, "orgId"),
    accountId: getIntField(json, "accountId"),
    agentId: getIntField(json, "agentId"),
    companyId: getIntField(json, "companyId"),
    contractNo: json["contractNo"],
    amount: getIntField(json, "amount"),
    currencyId: getIntField(json, "currencyId"),
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "orgId": orgId,
    "accountId": accountId,
    "agentId": agentId,
    "companyId": companyId,
    "contractNo": contractNo,
    "amount": amount,
    "currencyId": currencyId,
    "currency": currency,
  };
}
