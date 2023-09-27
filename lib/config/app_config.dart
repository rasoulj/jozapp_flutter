
import 'package:jozapp_flutter/models/types.dart';

abstract class AppConfig {
  static const int ordersCount = 20;
  static const bool isDebug = false;

  static const String defLang = "ar";
  static const String defPhoneCode = "964";
  static const String aid = "bahbahan";// "bahbahan";// "nnw2";
  static const String version = "1.0.8";

  static const List<CurTypes> activeCurrencies = [
    CurTypes.usd,
    CurTypes.iqd,
    CurTypes.eur,
    CurTypes.irr,
  ];

  static const String _baseUrlDebug = "http://157.90.207.53:2537";
  static const String _baseUrlProduction = "http://135.181.237.237:2537";
  static const String baseUrl = isDebug ? _baseUrlDebug : _baseUrlProduction;
}

class _Tags {
  const _Tags();

  final String auth = "auth";
  final String setPassword = "auth/setPassword";
  final String wallets = "wallets";
  final String fees = "fees";
  final String orders = "orders";
  final String rates = "rates";
  final String hist = "hist";
  final String otp = "users/otp";
  final String changePassword = "users/changePassword";
  final String sms = "sms";
  final String smsVerify = "sms/verify";
  final String atickets = "atickets";
}

abstract class C {
  static const _Tags tags = _Tags();

  static const String otp = "otp";
  static const String bid = "bid";
  static const String aid = "aid";
  static const String phone = "phone";
  static const String role = "role";
  static const String code = "code";
  static const String password = "password";
  static const String curPassword = "curPassword";
  static const String newPassword = "newPassword";

  static const String wid = "wid";
  static const String status = "status";
  static const String limit = "limit";
  static const String cur = "cur";
  static const String orderNo = "orderNo";
  static const String desc = "desc";
  static const String transactions = "transactions";

}