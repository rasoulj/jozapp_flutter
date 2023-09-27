// To parse this JSON data, do
//
//     final airport = airportFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:jozapp_flutter/models/types.dart';

class Airport {
  Airport({
    this.multiAirportCityInd,
    this.cityCode,
    this.originalCityCode,
    this.cityNameEn,
    this.originalCityName,
    this.priority,
    this.cityNameFa,
    this.originalCityNameFa,
    this.airportCode,
    this.originalAirportCode,
    this.airportNameEn,
    this.airportNameFa,
    this.originalAirportName,
    this.countryCode,
    this.originalCountryCode,
    this.countryNameFa,
    this.originalCountryNameFa,
    this.isCity,
    this.count,
  });

  final String? cityCode;
  final String? originalCityCode;
  final String? cityNameEn;
  final String? originalCityName;
  final int? priority;
  final String? cityNameFa;
  final String? originalCityNameFa;
  final String? airportCode;
  final String? originalAirportCode;
  final String? airportNameEn;
  final String? airportNameFa;
  final String? originalAirportName;
  final String? countryCode;
  final String? originalCountryCode;
  final String? countryNameFa;
  final String? originalCountryNameFa;
  final bool? isCity;
  final int? count;
  final bool? multiAirportCityInd;

  Airport copyWith({
    String? cityCode,
    String? originalCityCode,
    String? cityNameEn,
    String? originalCityName,
    int? priority,
    String? cityNameFa,
    String? originalCityNameFa,
    String? airportCode,
    String? originalAirportCode,
    String? airportNameEn,
    String? airportNameFa,
    String? originalAirportName,
    String? countryCode,
    String? originalCountryCode,
    String? countryNameFa,
    String? originalCountryNameFa,
    bool? isCity,
    int? count,
    bool? multiAirportCityInd,
  }) =>
      Airport(
          cityCode: cityCode ?? this.cityCode,
          originalCityCode: originalCityCode ?? this.originalCityCode,
          cityNameEn: cityNameEn ?? this.cityNameEn,
          originalCityName: originalCityName ?? this.originalCityName,
          priority: priority ?? this.priority,
          cityNameFa: cityNameFa ?? this.cityNameFa,
          originalCityNameFa: originalCityNameFa ?? this.originalCityNameFa,
          airportCode: airportCode ?? this.airportCode,
          originalAirportCode: originalAirportCode ?? this.originalAirportCode,
          airportNameEn: airportNameEn ?? this.airportNameEn,
          airportNameFa: airportNameFa ?? this.airportNameFa,
          originalAirportName: originalAirportName ?? this.originalAirportName,
          countryCode: countryCode ?? this.countryCode,
          originalCountryCode: originalCountryCode ?? this.originalCountryCode,
          countryNameFa: countryNameFa ?? this.countryNameFa,
          originalCountryNameFa: originalCountryNameFa ??
              this.originalCountryNameFa,
          isCity: isCity ?? this.isCity,
          count: count ?? this.count,
          multiAirportCityInd: multiAirportCityInd ?? this.multiAirportCityInd
      );

  factory Airport.fromRawJson(String str) => Airport.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Airport.fromJson(Map<String, dynamic> json) {
    // log(jsonEncode(json));
    return Airport(
      cityCode: json["cityCode"],
      originalCityCode: json["originalCityCode"],
      cityNameEn: json["cityNameEn"],
      originalCityName: json["originalCityName"],
      priority: getIntField(json, "priority"),
      cityNameFa: json["cityNameFa"],
      originalCityNameFa: json["originalCityNameFa"],
      airportCode: json["airportCode"],
      originalAirportCode: json["originalAirportCode"],
      airportNameEn: json["airportNameEn"],
      airportNameFa: json["airportNameFa"],
      originalAirportName: json["originalAirportName"],
      countryCode: json["countryCode"],
      originalCountryCode: json["originalCountryCode"],
      countryNameFa: json["countryNameFa"],
      originalCountryNameFa: json["originalCountryNameFa"],
      isCity: json["isCity"],
      count: getIntField(json, "count"),
      multiAirportCityInd: json["MultiAirportCityInd"] != null,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "cityCode": cityCode,
        "originalCityCode": originalCityCode,
        "cityNameEn": cityNameEn,
        "originalCityName": originalCityName,
        "priority": priority,
        "cityNameFa": cityNameFa,
        "originalCityNameFa": originalCityNameFa,
        "airportCode": airportCode,
        "originalAirportCode": originalAirportCode,
        "airportNameEn": airportNameEn,
        "airportNameFa": airportNameFa,
        "originalAirportName": originalAirportName,
        "countryCode": countryCode,
        "originalCountryCode": originalCountryCode,
        "countryNameFa": countryNameFa,
        "originalCountryNameFa": originalCountryNameFa,
        "isCity": isCity,
        "count": count,
        "MultiAirportCityInd": multiAirportCityInd,
      };

  static List<Airport> parserArr(dynamic items) {
    return List<Airport>.from((items ?? []).map((x) => Airport.fromJson(x)));
  }


  Json get getLocation =>
      {
        "CodeContext": "IATA",
        "LocationCode": airportCode,
        "MultiAirportCityInd": multiAirportCityInd ?? false,
      };

}
