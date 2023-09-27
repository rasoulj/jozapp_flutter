// To parse this JSON data, do
//
//     final fees = feesFromJson(jsonString);

import 'dart:convert';

class Fees {
  Fees({
    this.id,
    this.membership = 0,
    this.topUp = 0,
    this.withdraw = 0,
    this.exchange = 0,
    this.transfer = 0,
    this.airplaneTicket = 0,
  });

  final String? id;
  final double membership;
  final double topUp;
  final double withdraw;
  final double exchange;
  final double transfer;
  final double airplaneTicket;

  Fees copyWith({
    String id = "id",
    double membership = 0,
    double topUp = 0,
    double withdraw = 0,
    double exchange = 0,
    double transfer = 0,
    double airplaneTicket = 0,
  }) =>
      Fees(
        id: id,
        membership: membership,
        topUp: topUp,
        withdraw: withdraw,
        exchange: exchange,
        transfer: transfer,
        airplaneTicket: airplaneTicket,
      );

  factory Fees.fromRawJson(String str) => Fees.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fees.fromJson(Map<String, dynamic> json) => Fees(
    id: json["_id"],
    membership: json["membership"].toDouble(),
    topUp: json["topUp"].toDouble(),
    withdraw: json["withdraw"].toDouble(),
    exchange: json["exchange"].toDouble(),
    transfer: json["transfer"].toDouble(),
    airplaneTicket: json["airplaneTicket"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "membership": membership,
    "topUp": topUp,
    "withdraw": withdraw,
    "exchange": exchange,
    "transfer": transfer,
    "airplaneTicket": airplaneTicket,
  };
}
