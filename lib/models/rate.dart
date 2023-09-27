// To parse this JSON data, do
//
//     final rate = rateFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:jozapp_flutter/models/types.dart';

class Rate {
  double getRate(CurTypes cur) {
    double val = value(cur);
    return cur == CurTypes.usd || val <= 0.0 ? 1 : 1/val;
  }

  double calcInDomestic(CurTypes cur, CurTypes ocur, {bool isBuy = true}) {
  double sb = (isBuy ? bronze?.b : bronze?.s) ?? 1;
  return sb*getRate(cur)/getRate(ocur);
  }

  double calcRate(CurTypes cur, CurTypes ocur, CurTypes defCurrency) {
    if(ocur == defCurrency) {
      return calcInDomestic(cur, CurTypes.usd, isBuy: true);
    } else if(cur == defCurrency) {
      return 1/calcInDomestic(ocur, CurTypes.usd, isBuy: false);
    } else {
      return calcInDomestic(cur, defCurrency, isBuy: true) /
          calcInDomestic(ocur, defCurrency, isBuy: false);
    }
  }

  double calcOAmount(double amount, CurTypes cur, CurTypes ocur, CurTypes defCurrency) {
    return amount*calcRate(cur, ocur, defCurrency);
  }

  double calcAmount(double amount, CurTypes cur, CurTypes ocur, CurTypes defCurrency) {
    return amount/calcRate(cur, ocur, defCurrency);
  }


  final Map<CurTypes, double> _values = {};
  final BuySellPrice? bronze;

  Rate({
    double iqd = 1.0,
    double usd = 1.0,
    double aed = 1.0,
    double eur = 1.0,
    double cny = 1.0,
    double irr = 1.0,
    double gbp = 1.0,
    double aud = 1.0,
    double cad = 1.0,
    this.bronze,
  }) {
    _values[CurTypes.iqd] = iqd;
    _values[CurTypes.usd] = usd;
    _values[CurTypes.aed] = aed;
    _values[CurTypes.eur] = eur;
    _values[CurTypes.cny] = cny;
    _values[CurTypes.irr] = irr;
    _values[CurTypes.gbp] = gbp;
    _values[CurTypes.aud] = aud;
    _values[CurTypes.cad] = cad;

    log("Rates: $_values");
  }


  Rate copyWith({
    double iqd = 1.0,
    double irr = 1.0,
    double cny = 1.0,
    double aud = 1.0,
    double eur = 1.0,
    double gbp = 1.0,
    double aed = 1.0,
    double cad = 1.0,
    BuySellPrice? bronze,
  }) =>
      Rate(
        iqd: iqd,
        irr: irr,
        cny: cny,
        aud: aud,
        eur: eur,
        gbp: gbp,
        aed: aed,
        cad: cad,
        bronze: bronze ?? this.bronze,
      );

  factory Rate.fromRawJson(String str) => Rate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rate.fromJson(Json json) => Rate(
    iqd: getDoubleField(json, "iqd", defValue: 1.0),
    irr: getDoubleField(json, "irr", defValue: 1.0),
    cny: getDoubleField(json, "cny", defValue: 1.0),
    aud: getDoubleField(json, "aud", defValue: 1.0),
    eur: getDoubleField(json, "eur", defValue: 1.0),
    gbp: getDoubleField(json, "gbp", defValue: 1.0),
    aed: getDoubleField(json, "aed", defValue: 1.0),
    cad: getDoubleField(json, "cad", defValue: 1.0),
    bronze: BuySellPrice.fromJson(json["bronze"]),
  );

  double value(CurTypes cur) => _values[cur] ?? 0.0;

  double get iqd => value(CurTypes.iqd);
  double get usd => value(CurTypes.usd);
  double get aed => value(CurTypes.aed);
  double get eur => value(CurTypes.eur);
  double get cny => value(CurTypes.cny);
  double get irr => value(CurTypes.irr);
  double get gbp => value(CurTypes.gbp);
  double get aud => value(CurTypes.aud);
  double get cad => value(CurTypes.cad);

  Json toJson() => {
    "iqd": iqd,
    "irr": irr,
    "cny": cny,
    "aud": aud,
    "eur": eur,
    "gbp": gbp,
    "aed": aed,
    "cad": cad,
    "bronze": bronze?.toJson(),
  };
}

class BuySellPrice {
  BuySellPrice({
    this.b = 1.0,
    this.s = 1.0,
  });

  final double b;
  final double s;

  BuySellPrice copyWith({
    double b = 1.0,
    double s = 1.0,
  }) =>
      BuySellPrice(
        b: b,
        s: s,
      );

  factory BuySellPrice.fromRawJson(String str) => BuySellPrice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BuySellPrice.fromJson(Json json) => BuySellPrice(
    b: getDoubleField(json, "b", defValue: 1.0),
    s: getDoubleField(json, "s", defValue: 1.0),
  );

  Json toJson() => {
    "b": b,
    "s": s,
  };
}
