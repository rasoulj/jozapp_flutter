import 'package:flutter/cupertino.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/models/wid.dart';
import 'package:jozapp_flutter/models/fees.dart';
import 'package:jozapp_flutter/models/login_response.dart';
import 'package:jozapp_flutter/models/order.dart';
import 'package:jozapp_flutter/models/rate.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/models/wallet.dart';


class AppDataModel extends ChangeNotifier {

  bool get logged => _token != null;

  String? _token;
  String? get token => _token;

  set token(String? value) {
    _token = value;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  Wid get wid => user?.wid ?? Wid.empty();
  String get bid => user?.bid ?? "NA";
  String get aid => user?.aid ?? "NA";

  CurTypes get defCurrency => branch?.defCurrency ?? CurTypes.usd;


  Fees _fees = Fees();
  Fees get fees => _fees;
  set fees(Fees value) {
    _fees = value;
    notifyListeners();
  }

  Branch? _branch;
  Branch? get branch => _branch;
  set branch(Branch? value) {
    _branch = value;
    notifyListeners();
  }

  Agency? _agency;
  Agency? get agency => _agency;
  set agency(Agency? value) {
    _agency = value;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Order> _orders = [];
  List<Order> get orders => _orders;
  set orders(List<Order> value) {
    _orders = value;
    notifyListeners();
  }

  Wallet _wallet = Wallet();
  Wallet get wallet => _wallet;
  set wallet(Wallet value) {
    _wallet = value;
    notifyListeners();
  }

  Rate _rate = Rate();
  Rate get rate => _rate;
  set rate(Rate value) {
    _rate = value;
    notifyListeners();
  }

  List<Order> _hist = [];
  List<Order> get hist => _hist;
  set hist(List<Order> value) {
    _hist = value;
    notifyListeners();
  }


  void clear() {
    _transHist.clear();
    hist = [];
    setTransHist(C.limit, AppConfig.ordersCount.toString());
    token = null;
  }



  final Map<String, String> _transHist = {
    C.limit: AppConfig.ordersCount.toString(),
  };
  Json get transHist => _transHist;
  void setTransHist(String key, String value) {
    _transHist[key] = value;
    notifyListeners();
  }

  double getRate(CurTypes cur) {
    CurTypes def = branch?.defCurrency ?? CurTypes.usd;
    if(cur == def) return 1.0;
    double buy = rate.bronze?.b ?? rate.usd;
    return buy * 1/rate.value(cur);
  }

  double get totalBalance {
    double sum = 0.0;
    for(CurTypes cur in AppConfig.activeCurrencies) {
      double rate = getRate(cur);
      sum += rate * wallet.value(cur);
    }
    return sum;
  }

  List<Order> openOrders(CurTypes cur) => orders.where((order) => order.status == OrderStatus.issued && order.cur == cur).toList();

}