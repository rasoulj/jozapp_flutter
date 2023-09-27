// To parse this JSON data, do
//
//     final orderHist = orderHistFromJson(jsonString);

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:jozapp_flutter/models/types.dart';

import 'wid.dart';

//amount oAmount cur ocur bwid wid back bid

class Order {
  List<Order> get exchangeTransactions => [
    Order(amount: -amount, wid: wid, cur: cur, desc: "Exchanged to ${ocur?.longName}", type: OrderTypes.exchange, ocur: ocur, oAmount: oAmount, bid: bid, hasDone: true),
    Order(amount: oAmount, wid: wid, cur: ocur ?? CurTypes.usd, desc: "Exchanged from ${cur.longName}", type: OrderTypes.exchange, ocur: cur, oAmount: oAmount, bid: bid),

    Order(amount: amount, wid: bwid, cur: cur, desc: "Exchanged from ${ocur?.longName} by User=${wid?.formal}", type: OrderTypes.exchange, ocur: ocur, oAmount: oAmount, owid: wid, bid: bid),
    Order(amount: -oAmount, wid: bwid, cur: ocur ?? CurTypes.usd, desc: "Exchanged to ${cur.longName} by User=${wid?.formal}", type: OrderTypes.exchange, ocur: ocur, oAmount: oAmount, owid: wid, bid: bid),
  ];

  List<Order> get transferTransactions => [
      Order(amount: -amount, wid: wid, cur:cur, desc: "Transferred to ${cwid?.formal}", type: OrderTypes.transfer, owid: cwid, fee: fee, bid: bid, hasDone: true),
      Order(amount: -fee, wid: wid, cur: cur, desc: "For Transaction fee", type: OrderTypes.fee, owid: cwid, fee: fee, bid: bid, hasDone: true),
      Order(amount: fee, wid: bwid, cur: cur, desc: "Transaction fee from ${cwid?.formal}", type: OrderTypes.fee, owid: cwid, bid: bid),
      Order(amount: amount, wid: cwid, cur: cur, desc: "Transferred from ${wid?.formal}", type: OrderTypes.transfer, owid: wid, fee: fee, bid: bid),
  ];
  /*
  const transactions = [
            {amount: -amount, wid: formalCustomerNumber(wid), cur: "usd", desc: "Buy airplane ticket from "+stdCustomerNumber(bwid), type: "airplane_ticket", owid: bwid, bid},
            {amount, wid: formalCustomerNumber(bwid), cur: "usd", desc: "Transfer to "+stdCustomerNumber(wid) + " for airplane ticket", type: "airplane_ticket", owid: wid, bid},
        ];
   */
  List<Order> get aticketTransactions => [
    Order(amount: -amount, wid: wid, cur: cur, desc: "Buy airplane ticket from ${bwid?.formal}", type: OrderTypes.airplaneTicket, owid: bwid, bid: bid),
    Order(amount: amount, wid: bwid, cur: cur, desc: "Transfer to ${wid?.formal} for airplane ticket", type: OrderTypes.airplaneTicket, owid: wid, bid: bid),
  ];


  const Order({
    this.hasDone,
    this.id,
    this.bid,
    this.isPositive = true,
    this.desc,
    this.cur = CurTypes.usd,
    this.type,
    this.wid,
    this.ocur,
    this.oAmount = 0.0,
    this.cwid,
    this.fee = 0.0,
    this.owid,
    this.bwid,
    this.amount = 0.0,
    this.orderNo,
    this.createdAt,
    this.updatedAt,
    this.status = OrderStatus.issued,

  });


  final bool? hasDone;
  final OrderStatus status;
  final String? id;
  final String? bid;
  final bool? isPositive;
  final String? desc;
  final CurTypes cur;
  final OrderTypes? type;
  final Wid? wid;
  final CurTypes? ocur;
  final double oAmount;
  final Wid? cwid;
  final double fee;
  final Wid? owid;
  final Wid? bwid;
  final double amount;
  final String? orderNo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order copyWith({
    bool? hasDone,
    OrderStatus status = OrderStatus.issued,
    String? id,
    String? bid,
    bool isPositive = true,
    String? desc,
    CurTypes? cur,
    OrderTypes? type,
    Wid? wid,
    CurTypes? ocur,
    double oAmount = 0.0,
    Wid? cwid,
    double fee = 0.0,
    Wid? owid,
    Wid? bwid,
    double amount = 0.0,
    String? orderNo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Order(
        hasDone: hasDone ?? this.hasDone,
        id: id ?? this.id,
        bid: bid ?? this.bid,
        isPositive: isPositive,
        desc: desc ?? this.desc,
        cur: cur ?? this.cur,
        type: type ?? this.type,
        wid: wid ?? this.wid,
        ocur: ocur ?? this.ocur,
        oAmount: oAmount,
        cwid: cwid ?? this.cwid,
        fee: fee,
        owid: owid ?? this.owid,
        bwid: bwid ?? this.bwid,
        amount: amount,
        orderNo: orderNo ?? this.orderNo,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status
      );

  factory Order.fromRawJson(String str) =>
      Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Json json) => Order(
        hasDone: json["hasDone"],
        id: json["_id"],
        bid: json["bid"],
        isPositive: json["isPositive"],
        desc: json["desc"],
        cur: toCurTypes(json["cur"]),
        type:  toOrderTypes(json["type"]),
        wid: Wid.fromJson(json),
        ocur: toCurTypes(json["ocur"]),
        oAmount: getDoubleField(json, "oAmount"),
        cwid: Wid.fromJson(json, "cwid"),
        fee: getDoubleField(json, "fee"),
        owid: Wid.fromJson(json, "owid"),
        bwid: Wid.fromJson(json, "bwid"),
        amount: getDoubleField(json, "amount"),
        orderNo: json["orderNo"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        status: toOrderStatus(json["status"]),

  );

  Json toJson([bool toSent = false]) => {
        if(!toSent) "_id": id,
        "hasDone": hasDone,
        "bid": bid,
        "isPositive": isPositive,
        "desc": desc,
        "cur": cur.name,
        "type": type?.name,
        "wid": wid?.value,
        "ocur": ocur?.name,
        "oAmount": oAmount,
        "cwid": cwid?.value,
        "fee": fee,
        "owid": owid?.value,
        "bwid": bwid?.value,
        "amount": amount,
        "orderNo": orderNo,
        "status": status.name,

        if(!toSent) "createdAt": createdAt?.toIso8601String(),
        if(!toSent) "updatedAt": updatedAt?.toIso8601String(),
      };

  Widget getBadge([double size = 40]) {
    return Hero(
    tag: id ?? orderNo ?? "NA",
    child: Badge(

      toAnimate: false,
      // position: small ? null : const BadgePosition(top: 25, start: 10),
      badgeColor: Colors.transparent,
      badgeContent: cur.icon(size/2),
      child: type?.icon(size),
    ),
  );
  }
}
