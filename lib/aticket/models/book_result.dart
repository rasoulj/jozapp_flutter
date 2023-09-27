// To parse this JSON data, do
//
//     final bookResult = bookResultFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:jozapp_flutter/models/types.dart';

class BookResult {
  BookResult({
    this.bookId,
    this.contractInfo,
    this.items,
    this.lri,
  });

  bool get success {
    var p = items ?? [];
    if(p.isEmpty) return false;
    return p.first.success ?? false;
  }

  ItinTotalFare? get totalFare {
    var it1 = items ?? [];
    if(it1.isEmpty) return null;
    return it1.first.items?.airItineraryPricingInfo?.itinTotalFare;
  }

  int get contractNo => contractInfo?.contractNo ?? 0;
  String get currency => contractInfo?.currency ?? "USD";

  Json get issueInfo =>
      {
        "ContractNo": contractNo.toString(),
        "Credit": true.toString(),
        "Wallet": false.toString(),
        "Currency": currency
      };


  final String? bookId;
  final ContractInfo? contractInfo;
  final List<Item>? items;
  final String? lri;



  factory BookResult.fromRawJson(String str) => BookResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookResult.fromJson(Map<String, dynamic> json) => BookResult(
    bookId: json["BookId"],
    contractInfo: ContractInfo.fromJson(json["ContractInfo"] ?? {}),
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
    lri: json["lri"],
  );

  Map<String, dynamic> toJson() => {
    "BookId": bookId,
    "ContractInfo": contractInfo?.toJson(),
    "Items": List<dynamic>.from((items ?? []).map((x) => x.toJson())),
    "lri": lri,
  };
}

class ContractInfo {
  ContractInfo({
    this.contractNo,
    this.amount,
    this.currency,
  });

  final int? contractNo;
  final int? amount;
  final String? currency;

  factory ContractInfo.fromRawJson(String str) => ContractInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContractInfo.fromJson(Map<String, dynamic> json) => ContractInfo(
    contractNo: getIntField(json, "ContractNo"),
    amount: getIntField(json, "Amount"),
    currency: json["Currency"],
  );

  Map<String, dynamic> toJson() => {
    "ContractNo": contractNo,
    "Amount": amount,
    "Currency": currency,
  };
}

class Item {
  Item({
    this.success,
    this.items,
    this.lri,
  });

  final bool? success;
  final Items? items;
  final String? lri;

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) {
    bool success = json["Success"] ?? false;
    return Item(
      success: success,
      items: success ? Items.fromJson(json["Items"] ?? {}) : null,
      lri: json["lri"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Success": success,
    "Items": items?.toJson(),
    "lri": lri,
  };
}

class Items {
  Items({
    this.airReservation,
    this.airItineraryPricingInfo,
  });

  final AirReservation? airReservation;
  final AirItineraryPricingInfo? airItineraryPricingInfo;

  factory Items.fromRawJson(String str) => Items.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    airReservation: AirReservation.fromJson(json["AirReservation"] ?? {}),
    airItineraryPricingInfo: AirItineraryPricingInfo.fromJson(json["AirItineraryPricingInfo"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "AirReservation": airReservation?.toJson(),
    "AirItineraryPricingInfo": airItineraryPricingInfo?.toJson(),
  };
}

class AirItineraryPricingInfo {
  AirItineraryPricingInfo({
    this.itinTotalFare,
    this.ptcFareBreakdowns,
  });

  final ItinTotalFare? itinTotalFare;
  final List<PtcFareBreakdown>? ptcFareBreakdowns;

  factory AirItineraryPricingInfo.fromRawJson(String str) => AirItineraryPricingInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirItineraryPricingInfo.fromJson(Map<String, dynamic> json) => AirItineraryPricingInfo(
    itinTotalFare: ItinTotalFare.fromJson(json["ItinTotalFare"]),
    ptcFareBreakdowns: List<PtcFareBreakdown>.from(json["PTC_FareBreakdowns"].map((x) => PtcFareBreakdown.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ItinTotalFare": itinTotalFare?.toJson(),
    "PTC_FareBreakdowns": List<dynamic>.from((ptcFareBreakdowns ?? []).map((x) => x.toJson())),
  };
}

class ItinTotalFare {
  ItinTotalFare({
    this.baseFare,
    this.totalFare,
    this.original,
    this.totalCommission,
    this.totalTax,
    this.serviceTax,
    this.currency,
  });

  final double? baseFare;
  final double? totalFare;
  final double? original;
  final double? totalCommission;
  final double? totalTax;
  final double? serviceTax;
  final String? currency;

  factory ItinTotalFare.fromRawJson(String str) => ItinTotalFare.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItinTotalFare.fromJson(Map<String, dynamic> json) => ItinTotalFare(
    baseFare: getDoubleField(json, "BaseFare"),
    totalFare: getDoubleField(json, "TotalFare"),
    original: getDoubleField(json, "Original"),
    totalCommission: getDoubleField(json, "TotalCommission"),
    totalTax: getDoubleField(json, "TotalTax"),
    serviceTax: getDoubleField(json, "ServiceTax"),
    currency: json["Currency"],
  );

  Map<String, dynamic> toJson() => {
    "BaseFare": baseFare,
    "TotalFare": totalFare,
    "Original": original,
    "TotalCommission": totalCommission,
    "TotalTax": totalTax,
    "ServiceTax": serviceTax,
    "Currency": currency,
  };
}

class PtcFareBreakdown {
  PtcFareBreakdown({
    this.passengerFare,
    this.passengerTypeQuantity,
  });

  final PassengerFare? passengerFare;
  final PassengerTypeQuantity? passengerTypeQuantity;

  factory PtcFareBreakdown.fromRawJson(String str) => PtcFareBreakdown.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PtcFareBreakdown.fromJson(Map<String, dynamic> json) => PtcFareBreakdown(
    passengerFare: PassengerFare.fromJson(json["PassengerFare"] ?? {}),
    passengerTypeQuantity: PassengerTypeQuantity.fromJson(json["PassengerTypeQuantity"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "PassengerFare": passengerFare?.toJson(),
    "PassengerTypeQuantity": passengerTypeQuantity?.toJson(),
  };
}

class PassengerFare {
  PassengerFare({
    this.baseFare,
    this.totalFare,
    this.original,
    this.commission,
    this.serviceTax,
    this.taxes,
    this.currency,
  });

  final double? baseFare;
  final double? totalFare;
  final double? original;
  final double? commission;
  final double? serviceTax;
  final double? taxes;
  final String? currency;

  factory PassengerFare.fromRawJson(String str) => PassengerFare.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PassengerFare.fromJson(Map<String, dynamic> json) => PassengerFare(
    baseFare: getDoubleField(json, "BaseFare"),
    totalFare: getDoubleField(json, "TotalFare"),
    original: getDoubleField(json, "Original"),
    commission: getDoubleField(json, "Commission"),
    serviceTax: getDoubleField(json, "ServiceTax"),
    taxes: getDoubleField(json, "Taxes"),
    currency: json["Currency"],
  );

  Map<String, dynamic> toJson() => {
    "BaseFare": baseFare,
    "TotalFare": totalFare,
    "Original": original,
    "Commission": commission,
    "ServiceTax": serviceTax,
    "Taxes": taxes,
    "Currency": currency,
  };
}

class PassengerTypeQuantity {
  PassengerTypeQuantity({
    this.code,
    this.quantity,
  });

  final String? code;
  final int? quantity;

  factory PassengerTypeQuantity.fromRawJson(String str) => PassengerTypeQuantity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PassengerTypeQuantity.fromJson(Map<String, dynamic> json) => PassengerTypeQuantity(
    code: json["Code"],
    quantity: getIntField(json, "Quantity"),
  );

  Map<String, dynamic> toJson() => {
    "Code": code,
    "Quantity": quantity,
  };
}

class AirReservation {
  AirReservation({
    this.bookingReferenceId,
    this.ticketing,
  });

  final BookingReferenceId? bookingReferenceId;
  final Ticketing? ticketing;

  factory AirReservation.fromRawJson(String str) => AirReservation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AirReservation.fromJson(Map<String, dynamic> json) => AirReservation(
    bookingReferenceId: BookingReferenceId.fromJson(json["BookingReferenceID"] ?? {}),
    ticketing: Ticketing.fromJson(json["Ticketing"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "BookingReferenceID": bookingReferenceId?.toJson(),
    "Ticketing": ticketing?.toJson(),
  };
}

class BookingReferenceId {
  BookingReferenceId({
    this.ticketTimeLimit,
    this.ticketType,
  });

  final DateTime? ticketTimeLimit;
  final String? ticketType;

  factory BookingReferenceId.fromRawJson(String str) => BookingReferenceId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BookingReferenceId.fromJson(Map<String, dynamic> json) => BookingReferenceId(
    ticketTimeLimit: DateTime.parse(json["TicketTimeLimit"]),
    ticketType: json["TicketType"],
  );

  Map<String, dynamic> toJson() => {
    "TicketTimeLimit": ticketTimeLimit?.toIso8601String(),
    "TicketType": ticketType,
  };
}

class Ticketing {
  Ticketing({
    this.type,
    this.idContext,
  });

  final String? type;
  final int? idContext;

  factory Ticketing.fromRawJson(String str) => Ticketing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ticketing.fromJson(Map<String, dynamic> json) => Ticketing(
    type: json["type"],
    idContext: getIntField(json, "ID_Context"),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "ID_Context": idContext,
  };
}
