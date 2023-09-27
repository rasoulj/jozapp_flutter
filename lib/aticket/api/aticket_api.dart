
import 'dart:convert';
import 'dart:developer';

import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/aticket/models/airport.dart';
import 'package:jozapp_flutter/aticket/models/at_response.dart';
import 'package:jozapp_flutter/aticket/models/book_result.dart';
import 'package:jozapp_flutter/aticket/models/search_result.dart';
import 'package:jozapp_flutter/aticket/models/ticket_result.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/intl/langs/fa.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:http/http.dart' as http;

abstract class _Services {
  static const String authenticate = "authenticate";
  static const String airportList = "airportlist";

  static const String search = "flights/search";
  static const String book = "flights/book";
  static const String ticket = "flights/ticket";
}

enum _Methods {
  get, post,
}

abstract class Atf {
  static const String authorization = "Authorization";
  static const String connection = "connection";
  static const String keepAlive = 'keep-alive';
  static const String bearer = 'bearer';
  static const String contentType = 'Content-Type';
  static const String origin = 'origin';
  static const String contentType1 = 'application/x-www-form-urlencoded';
  static const String contentType2 =  'application/json';

  static const String username = "username";
  static const String password = "password";

}

enum _ConfigsEnum {
  test, tav, bahbahan,
}

class FlightConfig {
  final CurTypes cur;
  final String username;
  final String password;
  final bool hasDomestic;
  final String origin;

  FlightConfig({required this.cur, required this.username, required this.password, required this.hasDomestic, required this.origin});

  static final Map<_ConfigsEnum, FlightConfig> all = {
    _ConfigsEnum.test: FlightConfig(
      cur: CurTypes.irr,
      username: "00987161938675",
      password: "kaskas",
      hasDomestic: true,
      origin: "https://www.demo.citynet.ir",
    ),
    _ConfigsEnum.tav: FlightConfig(
      cur: CurTypes.irr,
      username: "info@tavenergy.com",
      password: "123Inf!@#",
      hasDomestic: true,
      origin: "www.tavenergy.com",
    ),
    _ConfigsEnum.bahbahan: FlightConfig(
      cur: CurTypes.usd,
      username: "wallet",
      password: "123Wallet!@#",
      hasDomestic: false,
      origin: 'https://www.bahbahan.com'
    )
  };

  static const _ConfigsEnum _flightOwner = _ConfigsEnum.bahbahan;
  static FlightConfig get defConfig => all[_flightOwner]!;

  static const ticketBaseUrl = "https://171.22.24.69";
  static const ticketBaseApi = "$ticketBaseUrl/api/v1.0/";



}

class AticketApi {
  static String? token;

  static Map<String, String> get headers => {
      if(token != null) Atf.authorization: "${Atf.bearer} $token",
      Atf.connection: Atf.keepAlive,
      Atf.contentType: token == null ? Atf.contentType1 : Atf.contentType2,
      Atf.origin: FlightConfig.defConfig.origin
  };

  static String getAirlineLogoUrl(String airlineCode) {
    return "${AppConfig.baseUrl}/static/AirlineLogo/$airlineCode.png";
  }


  static Uri _getUri(String ep, [Json? q]) {
    String base = FlightConfig.ticketBaseApi + ep;
    if(q != null) base += "?" + Uri(queryParameters: q).query;
    log(base);
    return Uri.parse(base);
  }

  static Future<AtResponse> authenticate() async {
    try {
      token = null;
      var config = FlightConfig.defConfig;
      var request = http.Request(
          _Methods.post.name,
          _getUri(_Services.authenticate),
      )..bodyFields = {
        Atf.username: config.username,
        Atf.password: config.password
      }..headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var resp = await AtResponse.fromResponse(response);
      token = resp.token;
      return resp;
    } catch(e) {
      log(e.toString());
      return AtResponse(success: false, items: e.toString());
    }
  }


  static Future<AtResponse> getAirports(String q) async {
    try {
      log("11");
      if(token == null) {
        await authenticate();
        if(token == null) return AtResponse(success: false, items: "Cannot login to Ticket Service");
      }
      log("22: $token");

      var request = http
          .Request(_Methods.get.name, _getUri(_Services.airportList, {"q": q}))
          ..headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      return await AtResponse.fromResponse(response, parser: Airport.parserArr);
    } catch(e) {
      return AtResponse(success: false, items: e.toString());
    }
  }

  static Future<AtResponse> ticket(Json options) async {
    // try {
      if (token == null) {
        await authenticate();
        if (token == null) {
          return AtResponse(success: false, items: "Cannot login to Ticket Service");
        }
      }
      var request = http
          .Request(_Methods.get.name, _getUri(_Services.ticket, options))
        ..headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if(response.statusCode == 403) {
        token = null;
        return AtResponse(success: false, items: "Session expired, Please try again");
      }
      if (response.statusCode == 200) {
        TicketResult bookResult = TicketResult.fromRawJson(await response.stream.bytesToString());
        return AtResponse(success: bookResult.success, items: bookResult,);
      }
      else {
        return AtResponse(success: false, items: "Error code ${response.statusCode} : ${response.reasonPhrase}");
      }


    // } catch(e) {
    //   log(e.toString());
    //   return AtResponse(success: false, items: e.toString());
    // }
  }


  static Future<AtResponse> book(Json options) async {
    try {
      if(token == null) {
        await authenticate();
        if(token == null) return AtResponse(success: false, items: "Cannot login to Ticket Service");
      }

      var request = http
          .Request(_Methods.post.name, _getUri(_Services.book,))
        ..headers.addAll(headers)
        ..body = json.encode(options);

      http.StreamedResponse response = await request.send();
      if(response.statusCode == 403 || response.statusCode == 401) {
        token = null;
        return AtResponse(success: false, items: "Session expired, Please try again");
      }

      if (response.statusCode == 200) {
        BookResult bookResult = BookResult.fromRawJson(await response.stream.bytesToString());
        return AtResponse(success: bookResult.success, items: bookResult,);
      }
      else {
        return AtResponse(success: false, items: "Error code ${response.statusCode} : ${response.reasonPhrase}");
      }

    } catch(e) {
      log(e.toString());
      return AtResponse(success: false, items: e.toString());
    }
  }
  static Future<AtResponse> getSearch(Json options) async {
    try {

      if(token == null) {
        await authenticate();
        if(token == null) return AtResponse(success: false, items: "Cannot login to Ticket Service");
      }

      var request = http
          .Request(_Methods.post.name, _getUri(_Services.search,))
          ..headers.addAll(headers)
          ..body = json.encode(options);

      // log(headers.toString());

      http.StreamedResponse response = await request.send();

      if(response.statusCode == 403) {
        token = null;
        await authenticate();
        if(token == null) return AtResponse(success: false, items: "Cannot login to Ticket Service");
        var req2 = http
            .Request(_Methods.post.name, _getUri(_Services.search,))
          ..headers.addAll(headers)
          ..body = json.encode(options);
        response = await req2.send();
      }

      return await AtResponse.fromResponse(response, parser: SearchResult.parserArr);
    } catch(e) {
      log(e.toString());
      return AtResponse(success: false, items: e.toString());
    }
  }
}