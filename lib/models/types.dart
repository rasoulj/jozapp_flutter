import 'package:flutter/material.dart';
import 'package:jozapp_flutter/aticket/screens/tickets_view.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/screens/services/exchange_view.dart';
import 'package:jozapp_flutter/screens/services/otp_view.dart';
import 'package:jozapp_flutter/screens/services/topup_withdraw_transfer_view.dart';
import 'package:jozapp_flutter/screens/under_const.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';

typedef Json = Map<String, dynamic>;

typedef SetStateFunc = void Function(VoidCallback fn);

typedef CurBuilder = Widget Function(CurTypes cur);

enum OrderStatus {
  issued,
  accepted,
  rejected,
  suspended,
  canceled,
}

enum OrderTypes {
  all,
  topUp,
  withdraw,
  exchange,
  transfer,
  fee,
  airplaneTicket,
  otp,
}

enum CurTypes {
  iqd,
  irr,
  aud,
  usd,
  eur,
  gbp,
  aed,
  cad,
  cny,
}

/*
export const Roles = {
    AGENCY: "AGENCY",
    BRANCH: "BRANCH",
    AGENCY_ADMIN: "1-agencyAdmin",
    BRANCH_ADMIN: "2-branchAdmin",
    BRANCH_AGENT: "3-branchAgent",
    CUSTOMER: "4-branchCustomer",
    NONE: "5-none"
};
 */

// enum UserRoles {
//   agency,
//   branch,
//   agencyAdmin,
//   branchAdmin,
//   branchAgent,
//   branchCustomer,
//   none,
// }



extension CurTypesEx on CurTypes {
  String get shortName => "cur.$name.s".T();

  String get longName => "cur.$name.l".T();

  String get symbol => "cur.$name.sym".T();

  String get blocked => "$name-blocked";

  Widget icon([double? size]) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          boxShadow: AppStyles.boxShadow,
        ),
        child: Image.asset("assets/flags/$name.png"),
      );
}

class OrderTypesUiOptions {
  final IconData icon;
  final Color color;

  OrderTypesUiOptions(this.icon, this.color);

  static final Map<OrderTypes, OrderTypesUiOptions> all = {
    OrderTypes.all: OrderTypesUiOptions(Icons.all_inbox, Colors.black),
    OrderTypes.airplaneTicket:
        OrderTypesUiOptions(Icons.airplane_ticket, Colors.lime),
    OrderTypes.exchange: OrderTypesUiOptions(Icons.money, const Color(0xfffff2f2)),
    OrderTypes.fee: OrderTypesUiOptions(Icons.attach_money, Colors.deepPurple),
    OrderTypes.topUp: OrderTypesUiOptions(Icons.trending_up, Colors.green),
    OrderTypes.transfer: OrderTypesUiOptions(Icons.trending_flat, Colors.blue),
    OrderTypes.otp: OrderTypesUiOptions(Icons.password, Colors.blue),
    OrderTypes.withdraw:
        OrderTypesUiOptions(Icons.trending_down_outlined, Colors.white),
  };
}

extension OrderTypesEx on OrderTypes {
  String get shortName => "OrderTypes.$name.s".T();

  String get longName => "OrderTypes.$name.l".T();

  Icon icon([double size = 32]) {
    var opt =
        OrderTypesUiOptions.all[this] ?? OrderTypesUiOptions.all.values.first;
    return Icon(
      opt.icon,
      color: AppColors.white,
      size: size,
    );
  }

  dynamic route(CurTypes? cur) {
    switch(this) {
      case OrderTypes.topUp: return () => TWTView(cur: cur, type: OrderTypes.topUp,);
      case OrderTypes.withdraw: return () => TWTView(cur: cur, type: OrderTypes.withdraw);
      case OrderTypes.exchange: return () => ExchangeView(cur: cur);
      case OrderTypes.transfer: return () => TWTView(cur: cur, type: OrderTypes.transfer,);
      case OrderTypes.otp: return () => OtpView(cur: cur,);
      case OrderTypes.airplaneTicket: return () => TicketsView(cur: cur,);
      default: return () => UnderConstruction(title: longName,);
    }
  }
}

String getStringField(Map<dynamic, dynamic>? json, String key,
    {String defValue = ""}) {
  if (json == null) return defValue;
  return json.containsKey(key) ? json[key] ?? defValue : defValue;
}

int getIntField(Map<dynamic, dynamic>? json, String key, {int defValue = 0}) {
  try {
    if (json == null) return defValue;
    return json.containsKey(key) ? json[key] : defValue;
  } catch(e) {
    return defValue;
  }
}

DateTime? getDateTimeField(Map<dynamic, dynamic>? json, String key) {
  try {
    if (json == null) return null;
    return json.containsKey(key) ? DateTime.parse(json[key]) : null;
  } catch(e) {
    return null;
  }
}

double getDoubleField(Map<dynamic, dynamic>? json, String key,
    {double defValue = 0}) {
  if (json == null) return defValue;
  return json.containsKey(key) ? json[key] + 0.0 : defValue;
}

OrderStatus toOrderStatus(String? str) => OrderStatus.values
    .firstWhere((e) => e.name == str, orElse: () => OrderStatus.issued);

OrderTypes toOrderTypes(String? str) => OrderTypes.values
    .firstWhere((e) => e.name == str, orElse: () => OrderTypes.all);

CurTypes toCurTypes(String? str) {
  var lstr = str?.toLowerCase();
  return CurTypes.values
    .firstWhere((e) => e.name == lstr, orElse: () => CurTypes.values.first);
}

// UserRoles toUserRoles(String? str) => UserRoles.values
//     .firstWhere((e) => e.name == str, orElse: () => UserRoles.none);
