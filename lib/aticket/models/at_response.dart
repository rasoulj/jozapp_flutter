// To parse this JSON data, do
//
//     final atResponse = atResponseFromJson(jsonString);

import 'dart:convert';

import 'package:http/http.dart';

typedef ItemsParser<T> = T Function(dynamic value);


class AtResponse<T> {
  AtResponse({
    this.success,
    this.items,
    this.token,
  });

  final bool? success;
  final T? items;
  final String? token;
  String? get message => items == null ? null : items.runtimeType == "String".runtimeType ? items?.toString() : null;

  AtResponse copyWith({
    bool? success,
    T? items,
    String? token,
  }) =>
      AtResponse(
        success: success ?? this.success,
        items: items ?? this.items,
        token: token ?? this.token,
      );

  factory AtResponse.fromRawJson(String str, {ItemsParser<T>? parser}) => AtResponse.fromJson(json.decode(str), parser: parser);

  static Future<AtResponse> fromResponse<T>(StreamedResponse response, {ItemsParser<T>? parser}) async {
    if (response.statusCode == 200) {
      return AtResponse.fromRawJson(await response.stream.bytesToString(), parser: parser);
    }
    else {
      return AtResponse(success: false, items: "Error code ${response.statusCode} : ${response.reasonPhrase}");
    }
  }

  String toRawJson() => json.encode(toJson());

  factory AtResponse.fromJson(Map<String, dynamic> json,
      {ItemsParser<T>? parser}) => AtResponse(
    success: json["Success"],
    items: parser != null ? parser(json["Items"]) : json["Items"],
    token: json["token"],
  );


  Map<String, dynamic> toJson() => {
    "Success": success,
    "Items": items,
    "token": token,
  };
}
