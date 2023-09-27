// To parse this JSON data, do
//
//     final aticket = aticketFromJson(jsonString);

import 'dart:convert';

import 'package:jozapp_flutter/models/types.dart';

class Aticket {
  Aticket({
    this.id,
    this.data,
    this.usdPrice,
    this.loggedUid,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final AticketData? data;
  final double? usdPrice;
  final String? loggedUid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Aticket copyWith({
    String? id,
    AticketData? data,
    double? usdPrice,
    String? loggedUid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Aticket(
        id: id ?? this.id,
        data: data ?? this.data,
        usdPrice: usdPrice ?? this.usdPrice,
        loggedUid: loggedUid ?? this.loggedUid,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Aticket.fromRawJson(String str) => Aticket.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Aticket.fromJson(Map<String, dynamic> json) => Aticket(
    id: json["_id"],
    data: AticketData.fromJson(json["data"]),
    usdPrice: getDoubleField(json, "usdPrice"),
    loggedUid: json["logged_uid"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "data": data?.toJson(),
    "usdPrice": usdPrice,
    "logged_uid": loggedUid,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class AticketData {
  AticketData({
    this.items,
  });

  final List<AticketDataItem>? items;

  AticketData copyWith({
    List<AticketDataItem>? items,
  }) =>
      AticketData(
        items: items ?? this.items,
      );

  factory AticketData.fromRawJson(String str) => AticketData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AticketData.fromJson(Map<String, dynamic> json) => AticketData(
    items: List<AticketDataItem>.from(json["Items"].map((x) => AticketDataItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Items": List<dynamic>.from((items ?? []).map((x) => x.toJson())),
  };
}

class AticketDataItem {
  AticketDataItem({
    this.success,
    this.items,
  });

  final bool? success;
  final Items? items;

  AticketDataItem copyWith({
    bool? success,
    Items? items,
  }) =>
      AticketDataItem(
        success: success ?? this.success,
        items: items ?? this.items,
      );

  factory AticketDataItem.fromRawJson(String str) => AticketDataItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AticketDataItem.fromJson(Map<String, dynamic> json) => AticketDataItem(
    success: json["Success"],
    items: Items.fromJson(json["Items"]),
  );

  Map<String, dynamic> toJson() => {
    "Success": success,
    "Items": items?.toJson(),
  };
}

class Items {
  Items({
    this.airItinerary,
    this.travelerInfo,
  });

  final AirItinerary? airItinerary;
  final TravelerInfo? travelerInfo;

  Items copyWith({
    AirItinerary? airItinerary,
    TravelerInfo? travelerInfo,
  }) =>
      Items(
        airItinerary: airItinerary ?? this.airItinerary,
        travelerInfo: travelerInfo ?? this.travelerInfo,
      );

  factory Items.fromRawJson(String str) => Items.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    airItinerary: AirItinerary.fromJson(json["AirItinerary"] ?? {}),
    travelerInfo: TravelerInfo.fromJson(json["TravelerInfo"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "AirItinerary": airItinerary?.toJson(),
    "TravelerInfo": travelerInfo?.toJson(),
  };
}

class AirItinerary {
  AirItinerary({
    this.sessionId,
    this.combinationId,
    this.recommendationId,
    this.subsystemId,
    this.subsystemName,
    this.pnr,
  });

  final String? sessionId;
  final int? combinationId;
  final int? recommendationId;
  final int? subsystemId;
  final String? subsystemName;
  final String? pnr;

  AirItinerary copyWith({
    String? sessionId,
    int? combinationId,
    int? recommendationId,
    int? subsystemId,
    String? subsystemName,
    String? pnr,
  }) =>
      AirItinerary(
        sessionId: sessionId ?? this.sessionId,
        combinationId: combinationId ?? this.combinationId,
        recommendationId: recommendationId ?? this.recommendationId,
        subsystemId: subsystemId ?? this.subsystemId,
        subsystemName: subsystemName ?? this.subsystemName,
        pnr: pnr ?? this.pnr,
      );

  factory AirItinerary.fromRawJson(String str) => AirItinerary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirItinerary.fromJson(Map<String, dynamic> json) => AirItinerary(
    sessionId: json["SessionId"],
    combinationId: getIntField(json, "CombinationId"),
    recommendationId: getIntField(json, "RecommendationId"),
    subsystemId: getIntField(json, "SubsystemId"),
    subsystemName: json["SubsystemName"],
    pnr: json["pnr"],
  );

  Map<String, dynamic> toJson() => {
    "SessionId": sessionId,
    "CombinationId": combinationId,
    "RecommendationId": recommendationId,
    "SubsystemId": subsystemId,
    "SubsystemName": subsystemName,
    "pnr": pnr,
  };
}

class TravelerInfo {
  TravelerInfo({
    this.airTraveler,
  });

  final List<AirTraveler>? airTraveler;

  TravelerInfo copyWith({
    List<AirTraveler>? airTraveler,
  }) =>
      TravelerInfo(
        airTraveler: airTraveler ?? this.airTraveler,
      );

  factory TravelerInfo.fromRawJson(String str) => TravelerInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TravelerInfo.fromJson(Map<String, dynamic> json) => TravelerInfo(
    airTraveler: List<AirTraveler>.from(json["AirTraveler"].map((x) => AirTraveler.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AirTraveler": List<dynamic>.from((airTraveler ?? []).map((x) => x.toJson())),
  };
}

class AirTraveler {
  AirTraveler({
    this.email,
    this.gender,
    this.document,
    this.personId,
    this.birthDate,
    this.nationalId,
    this.personName,
    this.nationality,
    this.passengerId,
    this.currencyCode,
    this.passengerTypeCode,
    this.ticketNumber,
    this.referenceId,
  });

  final String? email;
  final String? gender;
  final Document? document;
  final int? personId;
  final DateTime? birthDate;
  final String? nationalId;
  final PersonName? personName;
  final String? nationality;
  final int? passengerId;
  final String? currencyCode;
  final String? passengerTypeCode;
  final List<String>? ticketNumber;
  final String? referenceId;

  AirTraveler copyWith({
    String? email,
    String? gender,
    Document? document,
    int? personId,
    DateTime? birthDate,
    String? nationalId,
    PersonName? personName,
    String? nationality,
    int? passengerId,
    String? currencyCode,
    String? passengerTypeCode,
    List<String>? ticketNumber,
    String? referenceId,
  }) =>
      AirTraveler(
        email: email ?? this.email,
        gender: gender ?? this.gender,
        document: document ?? this.document,
        personId: personId ?? this.personId,
        birthDate: birthDate ?? this.birthDate,
        nationalId: nationalId ?? this.nationalId,
        personName: personName ?? this.personName,
        nationality: nationality ?? this.nationality,
        passengerId: passengerId ?? this.passengerId,
        currencyCode: currencyCode ?? this.currencyCode,
        passengerTypeCode: passengerTypeCode ?? this.passengerTypeCode,
        ticketNumber: ticketNumber ?? this.ticketNumber,
        referenceId: referenceId ?? this.referenceId,
      );

  factory AirTraveler.fromRawJson(String str) => AirTraveler.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirTraveler.fromJson(Map<String, dynamic> json) => AirTraveler(
    email: json["Email"],
    gender: json["Gender"],
    document: Document.fromJson(json["Document"]),
    personId: getIntField(json, "PersonId"),
    birthDate: DateTime.parse(json["BirthDate"]),
    nationalId: json["NationalId"],
    personName: PersonName.fromJson(json["PersonName"]),
    nationality: json["Nationality"],
    passengerId: getIntField(json, "PassengerId"),
    currencyCode: json["CurrencyCode"],
    passengerTypeCode: json["PassengerTypeCode"],
    ticketNumber: List<String>.from(json["TicketNumber"].map((x) => x)),
    referenceId: json["ReferenceId"],
  );

  Map<String, dynamic> toJson() => {
    "Email": email,
    "Gender": gender,
    "Document": document?.toJson(),
    "PersonId": personId,
    "BirthDate": birthDate?.toIso8601String(),
    "NationalId": nationalId,
    "PersonName": personName?.toJson(),
    "Nationality": nationality,
    "PassengerId": passengerId,
    "CurrencyCode": currencyCode,
    "PassengerTypeCode": passengerTypeCode,
    "TicketNumber": List<dynamic>.from((ticketNumber ?? []).map((x) => x)),
    "ReferenceId": referenceId,
  };
}

class Document {
  Document({
    this.docId,
    this.expireDate,
    this.innerDocType,
    this.docIssueCountry,
  });

  final String? docId;
  final DateTime? expireDate;
  final String? innerDocType;
  final String? docIssueCountry;

  Document copyWith({
    String? docId,
    DateTime? expireDate,
    String? innerDocType,
    String? docIssueCountry,
  }) =>
      Document(
        docId: docId ?? this.docId,
        expireDate: expireDate ?? this.expireDate,
        innerDocType: innerDocType ?? this.innerDocType,
        docIssueCountry: docIssueCountry ?? this.docIssueCountry,
      );

  factory Document.fromRawJson(String str) => Document.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    docId: json["DocID"],
    expireDate: DateTime.parse(json["ExpireDate"]),
    innerDocType: json["InnerDocType"],
    docIssueCountry: json["DocIssueCountry"],
  );

  Map<String, dynamic> toJson() => {
    "DocID": docId,
    "ExpireDate": expireDate?.toIso8601String(),
    "InnerDocType": innerDocType,
    "DocIssueCountry": docIssueCountry,
  };
}

class PersonName {
  PersonName({
    this.surname,
    this.givenName,
    this.namePrefix,
  });

  final String? surname;
  final String? givenName;
  final String? namePrefix;

  PersonName copyWith({
    String? surname,
    String? givenName,
    String? namePrefix,
  }) =>
      PersonName(
        surname: surname ?? this.surname,
        givenName: givenName ?? this.givenName,
        namePrefix: namePrefix ?? this.namePrefix,
      );

  factory PersonName.fromRawJson(String str) => PersonName.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonName.fromJson(Map<String, dynamic> json) => PersonName(
    surname: json["Surname"],
    givenName: json["GivenName"],
    namePrefix: json["NamePrefix"],
  );

  Map<String, dynamic> toJson() => {
    "Surname": surname,
    "GivenName": givenName,
    "NamePrefix": namePrefix,
  };
}
