import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jozapp_flutter/aticket/models/aticket.dart';
import 'package:jozapp_flutter/aticket/models/search_result.dart';
import 'package:jozapp_flutter/aticket/models/ticket.dart';
import 'package:jozapp_flutter/aticket/models/ticket_result.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/models/wid.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/models/fees.dart';
import 'package:jozapp_flutter/models/login_response.dart';
import 'package:jozapp_flutter/models/order.dart';
import 'package:jozapp_flutter/models/rate.dart';
import 'package:jozapp_flutter/models/rest_response.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/models/wallet.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:provider/provider.dart';

const String unknownError = "Unknown error occurred.";

abstract class RestApi {

  static String? get _token => appModel.token;

  static Future<Map<String, String>> _getApiHeader() async {
    var token = _token;
    return {
      if(token != null) "x-access-token": _token!,
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }


  // static String get baseUrl => consts.baseUrl;
  static Future<RestResponse> _post(String tag, [Json body = const {}]) async {
    final response = await http.post(Uri.parse( '${AppConfig.baseUrl}/$tag'),
        headers: await _getApiHeader(), body: jsonEncode(body));
    log(response.body);

    if (response.statusCode == 200) {
      return RestResponse.fromJson(jsonDecode(response.body) ?? {});
    } else {
      return RestResponse.fromJson(jsonDecode(response.body) ?? {});
      // throw Exception(response.body);
    }
  }

  static Future<RestRespArr> _postArr(String tag, List<Json> body) async {
    final response = await http.post(Uri.parse( '${AppConfig.baseUrl}/$tag'),
        headers: await _getApiHeader(), body: jsonEncode(body));

    if (response.statusCode == 200) {
      return RestRespArr.fromJson(jsonDecode(response.body) ?? {});
    } else {
      throw Exception('Failed to POST $tag');
    }
  }

  static Future<RestRespArr> _fetchAll(String tag, {Json? query}) async {
    var base = '${AppConfig.baseUrl}/$tag';
    if (query != null) {
      base += "?" + Uri(queryParameters: query).query;
    }
    final url = Uri.parse( base);
    final response = await http.get(url, headers: await _getApiHeader());

    if (response.statusCode == 200) {
      return RestRespArr.fromJson(jsonDecode(response.body) ?? {});
    } else {
      log("----------------");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to GET-ALL $tag');
    }
  }

  static Future<RestResponse> _fetch(String tag, String id) async {

    var url = Uri.parse('${AppConfig.baseUrl}/$tag/$id');
    final response = await http.get(url, headers: await _getApiHeader());

    if (response.statusCode == 200) {
      return RestResponse.fromJson(jsonDecode(response.body) ?? {});
    } else {
      return RestResponse.fromJson(jsonDecode(response.body) ?? {});
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to GET $tag with id=$id');
    }
  }

  static Future<RestResponse> _put(String tag, String? id, Json body) async {
    var url = id == null ? Uri.parse('${AppConfig.baseUrl}/$tag') : Uri.parse('${AppConfig.baseUrl}/$tag/$id'); // todo check me
    final response = await http.put(url, headers: await _getApiHeader(), body: jsonEncode(body));

    if (response.statusCode == 200) {
      return RestResponse.fromJson(jsonDecode(response.body) ?? {});
    } else {
      return RestResponse.fromJson(jsonDecode(response.body) ?? {});
      //throw Exception('Failed to edit $tag with id=$id');
    }
  }

  static Future<RestResponse> _delete(String tag, String id) async {
    var url = Uri.parse('${AppConfig.baseUrl}/$tag/$id');
    final response = await http.delete(url, headers: await _getApiHeader());

    if (response.statusCode == 200) {
      return RestResponse.fromJson(jsonDecode(response.body) ?? {});
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete $tag with id=$id');
    }
  }


  static set loading(bool value) {
    appModel.loading = value;
  }

  static bool get loading {
    return appModel.loading;
  }

  static AppDataModel get appModel => Provider.of<AppDataModel>(Get.context!, listen: false);

  static Future<void> loadHist() async {
    var model = appModel;
    loading = true;
    try {
      Json q = {
        C.wid: appModel.wid.value,
        ...model.transHist,
      };
      log(q.toString());

      RestRespArr response = await _fetchAll(C.tags.hist, query: q);
      if(response.ok) {
        model.hist = (response.data ?? []).map((e) => Order.fromJson(e)).toList();
      }

    } catch(e) {
      log("loadHist: " + e.toString());
    } finally {
      loading = false;
    }
  }


  static Future<List<Order>> _loadOrdersInt([int limit = AppConfig.ordersCount, String? cur]) async {
    try {

      Json q = {
        C.wid: appModel.wid.value,
        C.status: OrderStatus.issued.name,
        C.limit: limit.toString(),
        if(cur != null) C.cur: cur,
      };


      RestRespArr res = await _fetchAll(C.tags.orders, query: q);
      showInfo(res.message);
      return !res.ok
          ? []
          : (res.data ?? []).map((e) => Order.fromJson(e)).toList();

    } catch(e) {
      log(e.toString());
      return [];
    }
  }

  static Future<void> removeOrder(Order order) async {
    loading = true;

    if([OrderTypes.exchange, OrderTypes.withdraw, OrderTypes.transfer].contains(order.type) ) {
      await blockAmount(order, true);
    }

    Json data = {
      C.status: OrderStatus.canceled.name,
      C.desc: "Order canceled by customer"
    };

    await _put(C.tags.orders, order.id ?? "NA", data);

    await loadOrders();
    await RestApi.loadWallet();

    loading = false;
  }

  static Future<void> loadOrders() async {
    appModel.orders = await _loadOrdersInt(500);
  }

  static Future<void> _loadRate() async {
    appModel.rate = await loadRate();
  }

  static Future<void> loadWallet() async {
    appModel.wallet = await loadWalletValues();
  }

  static Future<void> loadFees() async {
    var fees = await loadFeeValues();
    if(fees.isNotEmpty) {
      appModel.fees = fees.first;
    }
  }

  static Future<Wallet> loadWalletValues() async {
    try {
      RestResponse res = await _fetch(C.tags.wallets, appModel.wid.value);

      showInfo(res.message);

      return Wallet.fromJson(res.data ?? {});
    } catch(e) {
      log(e.toString());
      return Wallet();
    }
  }

  static Future<List<Fees>> loadFeeValues([int limit = 1]) async {
    try {
      RestRespArr res = await _fetchAll(C.tags.fees, query: {
        C.limit: limit.toString(),
        C.aid: appModel.aid,
      });

      return (res.data ?? []).map((e) => Fees.fromJson(e)).toList();

    } catch(e) {
      return [];
    }
  }

  static Future<List<Rate>> loadRates([int limit = 1]) async {
    try {
      Json q = {
        C.bid: appModel.bid,
        C.limit: limit.toString(),
      };

      RestRespArr res = await _fetchAll(C.tags.rates, query: q);
      showInfo(res.message);

      return !res.ok
          ? []
          : (res.data ?? []).map((e) => Rate.fromJson(e)).toList();

    } catch(e) {
      log(e.toString());
      return [];
    }

  }

  static Future<Rate> loadRate() async {
    var list = await loadRates();
    return list.isNotEmpty ? list.first : Rate();
  }

  static Timer? _loTimer;
  static Timer? _lwTimer;
  static Timer? _lrTimer;

  static void logout() {
    _loTimer?.cancel();
    _lwTimer?.cancel();
    _lrTimer?.cancel();
    appModel.clear();
  }

  static Future<bool> login(String phone, String password) async {
    try {

      log("$phone    $password");

      loading = true;
      RestResponse res = await _post(C.tags.auth, {
        C.aid: AppConfig.aid,
        C.phone: phone,
        C.password: password,
      });

      if(res.message != null) {
        showErrors([res.message!]);
        return false;
      }

      var logRes = LoginResponse.fromJson(res.data ?? {});

      String? token = logRes.authToken;
      if(token != null) {
        SembastDb? db = await SembastDb.init();
        await AppSettings.saveSetting(db, phoneNumber: phone, password: password);

        var model = appModel;
        model.user = logRes.user;
        model.agency = logRes.agency;
        model.branch = logRes.branch;
        model.token = logRes.authToken;

        await _loadRate();
        await loadWallet();
        await loadOrders();
        await loadHist();

        _loTimer = Timer.periodic(17.seconds, (timer) => loadOrders());
        _lwTimer = Timer.periodic(13.seconds, (timer) => loadWallet());
        _lrTimer = Timer.periodic(60.seconds, (timer) => _loadRate());

        return true;
      } else {
        return false;
      }

    } catch(e) {
      log(e.toString());
      return false;
    } finally {
      loading = false;
    }
  }

  static String createOrderNo() {

    String r = math.Random().nextInt(1000).toString();
    String rand = r.padLeft(3-r.length, "0");

    var now = DateTime.now().microsecondsSinceEpoch.toString();

    String cc = now+rand;
    return cc.substring(0, 16);
  }

  static Future<String?> blockAmount(Order order, [bool unBlock = false]) async {
    try {
      double amount = order.amount;
      double fee = order.fee;
      CurTypes cur = order.cur;
      Wid wid = order.wid ?? Wid.empty();
      double am = (amount - fee)*(unBlock ? -1 : 1);
      Json doc = {
        cur.name: -am,
        cur.blocked: am
      };
      RestResponse res = await _post("${C.tags.wallets}/${wid.value}", doc);
      return res.ok ? null : unknownError;
    } catch(e) {
      return e.toString();
    }
  }

  static Future<String?> saveOrder(Order order) async {
    try {
      Json doc = {
        ...order.toJson(true),
        ...(appModel.user?.toJson(true) ?? {}),
        C.orderNo: createOrderNo(),
        C.status: OrderStatus.issued.name,

        if(order.type == OrderTypes.exchange) C.transactions: order.exchangeTransactions.map((e) => e.toJson(true)).toList(),
      };

      var resp = await _post(C.tags.orders, doc);
      return resp.ok ? null : unknownError;
    } catch(e) {
      log(e.toString());
      return e.toString();
    } finally {
    }
  }

  static Future<String?> sendNotificationForTransactions(List<Order> orders) async {
    //TODO:
  }

  static Future<String?> doWallets(List<Order> orders) async {
    try {

      //log(jsonEncode(orders.map((e) => e.toJson(true)).toList()));

      RestRespArr resp = await _postArr(
        C.tags.wallets,
          orders.map((e) => e.toJson(true)).toList(),
      );
      if(!resp.ok) return unknownError;
      //TODO: await sendNotificationForTransactions(orders);
      return null;
    } catch(e) {
      return e.toString();
    }

  }



  static Future<int> createOtp() async {
    try {
      loading = true;
      RestResponse resp = await _post(C.tags.otp);

      if (resp.ok) {
        return getIntField(resp.data, C.otp, defValue: -1);
      } else {
        return -1;
      }
    } catch(e) {
      log(e.toString());
      return -1;
    } finally {
      loading = false;
    }
  }

  static Future<List<User>> fetchUsers({String? phone, String? role}) async {
    try {
      loading = true;
      RestRespArr response = await _fetchAll(C.tags.auth, query: {
        if(phone != null) C.phone: phone,
        if(role != null) C.role: role,
        C.aid: AppConfig.aid,
      });

      if(response.ok) {
        return (response.data ?? []).map((e) => User.fromJson(e)).toList();
      }
      return [];
    } catch(e) {
      log(e.toString());
      return [];
    } finally {
      loading = false;
    }
  }
  
  static Future<RestResponse> setPassword(String phone, String password) async {
    try {
      loading = true;
      RestResponse resp = await _post(C.tags.setPassword, {
        C.aid: AppConfig.aid,
        C.phone: phone,
        C.password: password,
      });
      return resp;
    } catch(e) {
      return RestResponse(status: 0, message: "err.set_password");
    } finally {
      loading = false;
    }
  }

  static Future<RestResponse> saveUserNoAuth(User user, String password) async {
    Json data = {
      "password": password,
      "bid": user.bid,
      "displayName": user.displayName,
      "aid": AppConfig.aid,
      "role": "4-branchCustomer",
      "address": "-",
      "phone": user.phone,
      "referPhone": user.phone,
    };

    log(data.toString());

    try {
      loading = true;
      RestResponse resp = await _put(C.tags.auth, null, data);
      return resp;
    } catch(e) {
      return RestResponse(status: 0, message: "err.saveUserNoAuth");
    } finally {
      loading = false;
    }

  }

  static Future<RestResponse> sendSms(String phone) async {
    try {
      loading = true;
      RestResponse resp = await _post(C.tags.sms, {
        C.phone: phone,
      });
      return resp;
    } catch(e) {
      return RestResponse(status: 0, message: "err.sendingVerificationCode");
    } finally {
      loading = false;
    }
  }

  static Future<RestResponse> verifySms(String phone, String code) async {
    try {
      loading = true;
      RestResponse resp = await _post(C.tags.smsVerify, {
        C.phone: phone,
        C.code: code,
      });
      return resp;
    } catch(e) {
      return RestResponse(status: 0, message: "err.verifyVerificationCode");
    } finally {
      loading = false;
    }

  }
  static Future<RestResponse> changePassword(String curPassword, String newPassword) async {
    try {
      loading = true;
      RestResponse resp = await _post(C.tags.changePassword, {
        C.curPassword: curPassword,
        C.newPassword: newPassword,
      });
      return resp;
    } catch(e) {
      return RestResponse(status: 0, message: "err.set_password");
    } finally {
      loading = false;
    }
  }

  static Future<List<Ticket>> getAtickets() async {
    try {
      loading = true;
      RestRespArr resp = await _fetchAll(C.tags.atickets);
      log(jsonEncode(resp.data));
      return List<Ticket>.from((resp.data ?? []).map((x) => Ticket.fromJson(x)));
    } catch(e) {
      return [];
    } finally {
      loading = false;
    }
  }

  static Future<RestResponse> saveTicket(SearchResult? searchResult, TicketResult? ticketResult) async {
    try {
      loading = true;
      return await _post(C.tags.atickets, {
        "data": ticketResult?.toJson(),
        "result": searchResult?.toJson(),
        "usdPrice": searchResult?.totalPrice,
      });
    } catch(e) {
      return RestResponse(status: 0, message: "err.save_ticket");
    } finally {
      loading = false;
    }
  }






}


/*


function sendTranNotification(transaction, user, lang) {
    const {token} = user || {};
    if (!token) return;
    console.log("desc", transaction);
    const {wid, amount, cur, type} = transaction;
    const body = getTransDesc(transaction, user, lang);

    const notification_body = {
        notification: {body, title: `${camelCase(type)} ${toTwoDigit(amount)} ${getCurrencyName(cur)}`, sound: 'default',},
        priority: "high",
        data: {more: "Salaam", id: 1, sound: 'default'},
        apns: { payload: { aps: { sound: 'default', } } },
        registration_ids: [token]
    };

    fetch('https://fcm.googleapis.com/fcm/send', {
        'method': 'POST',
        'headers': {
            // replace authorization key with your key
            'Authorization': `key=${serverToken}`,
            'Content-Type': 'application/json'
        },
        'body': JSON.stringify(notification_body)
    }).then(function (response) {
        console.log(response);
    }).catch(function (error) {
        console.error(error);
    });


    // console.log(`NOTIF: ${type} ${desc}`);
}


export function sendNotificationForTransactions(transactions, setLoader, onDone, onError, lang) {
    // const {wid, amount, cur, desc, type} = transaction;
    const wids = transactions.map(t => t.wid);
    // console.log("wids", wids);
    loadUsersByWid(wids, setLoader, users => {
        for (const transaction of transactions) {
            const {wid} = transaction;
            const user = users.find(u => u.wid === wid);
            sendTranNotification(transaction, user, lang);
            // console.log("tran", tran);
        }
        if(onDone) onDone();
        // console.log("users", users.map(p => p.token));
    }, onError);


}


 */