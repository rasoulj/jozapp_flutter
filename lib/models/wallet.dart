// To parse this JSON data, do
//
//     final wallet = walletFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/models/rate.dart';
import 'package:jozapp_flutter/models/types.dart';

class Wallet {
  final Map<CurTypes, double> _values = {};

  bool hasAvailable(CurTypes? cur, double amount) {
    log("${cur?.longName} = $amount");
    if(cur == null) return false;
    return value(cur) >= amount;
  }


  double getBalanceInDomestic(CurTypes cur, Rate rates) {
    double b = rates.bronze?.b ?? 1;
    double balance = value(cur);
    double rate0 = rates.getRate(cur);
    return balance*rate0*b;
  }

  double getTotalBalanceInDomestic(CurTypes defCurrency, Rate rates) {
    double sum = 0.0;
    for(var cur in AppConfig.activeCurrencies) {
      var val = cur == defCurrency ? value(defCurrency) : getBalanceInDomestic(cur, rates);
      sum += val;
    }
    return sum;
  }




  Wallet({
    double iqd = 0.0,
    double usd = 0.0,
    double aed = 0.0,
    double eur = 0.0,
    double cny = 0.0,
    double irr = 0.0,
    double gbp = 0.0,
    double aud = 0.0,
    double cad = 0.0,
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
  }

  // final double iqd;
  // final double usd;
  // final double aed;
  // final double eur;
  // final double cny;
  // final double irr;
  // final double gbp;
  // final double aud;
  // final double cad;

  Wallet copyWith({
    double iqd = 0.0,
    double usd = 0.0,
    double aed = 0.0,
    double eur = 0.0,
    double cny = 0.0,
    double irr = 0.0,
    double gbp = 0.0,
    double aud = 0.0,
    double cad = 0.0,
  }) =>
      Wallet(
        iqd: iqd,
        usd: usd,
        aed: aed,
        eur: eur,
        cny: cny,
        irr: irr,
        gbp: gbp,
        aud: aud,
        cad: cad,
      );

  factory Wallet.fromRawJson(String str) => Wallet.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Wallet.fromJson(Json json) => Wallet(
    iqd: getDoubleField(json, "iqd"),
    usd: getDoubleField(json, "usd"),
    aed: getDoubleField(json, "aed"),
    eur: getDoubleField(json, "eur"),
    cny: getDoubleField(json, "cny"),
    irr: getDoubleField(json, "irr"),
    gbp: getDoubleField(json, "gbp"),
    aud: getDoubleField(json, "aud"),
    cad: getDoubleField(json, "cad"),
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
    "usd": usd,
    "aed": aed,
    "eur": eur,
    "cny": cny,
    "irr": irr,
    "gbp": gbp,
    "aud": aud,
    "cad": cad,
  };
}
