import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/order.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/screens/services/confirm_view.dart';
import 'package:jozapp_flutter/screens/services/service_main_view.dart';
import 'package:jozapp_flutter/screens/services/services_widgets.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/available_cur.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class ExchangeView extends StatefulWidget {
  final CurTypes? cur;

  const ExchangeView({Key? key, this.cur}) : super(key: key);

  @override
  _ExchangeViewState createState() => _ExchangeViewState();
}

class _ExchangeViewState extends State<ExchangeView> {
  late final MoneyMaskedTextController _amountRes;

  MoneyMaskedTextController? _amount;
  String rightSymbol =  " ";

  @override
  void initState() {
    _amount = MoneyMaskedTextController(
        rightSymbol: rightSymbol,
        precision: 0, decimalSeparator: '', thousandSeparator: ',');
    _amountRes = MoneyMaskedTextController(
        // rightSymbol: rightSymbol,
        precision: 0, decimalSeparator: '', thousandSeparator: ',');

    amStr = rightSymbol;
    super.initState();
  }

  CurTypes? _selected;
  CurTypes? get selected => _selected;
  set selected(CurTypes? value) => setState(() => _selected = value);

  int _stage = 0;
  int get stage => _stage;
  set stage(int value) => setState(() => _stage = value);

  String _amStr = " ";
  String get amStr => _amStr;
  set amStr(String value) => setState(() => _amStr = value);

  bool get keyboardOpen => MediaQuery.of(context).viewInsets.bottom > 0;

  CurTypes? existing;

  double get amount {
    if(_amount?.text == rightSymbol) return 0;
    return _amount?.numberValue ?? 0;
  }

  @override
  Widget build(BuildContext context) {

    return ServiceMainView(
      mainAxisAlignment: MainAxisAlignment.start,
      cur: widget.cur,
      title: OrderTypes.exchange.longName,
      builder: (CurTypes cur) {
        if(cur != existing) {
          existing = cur;
          rightSymbol = " " + cur.symbol;
          _amount = MoneyMaskedTextController(
              rightSymbol: rightSymbol,
              precision: 0, decimalSeparator: '', thousandSeparator: ',');
        }
        return Column(
        children: [
          AvailableCur(
            cur: cur,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
            child: SelectCur2(
              exclude: cur,
              selected: selected,
              onChanged: (value) {
                selected = value;
              },
            ),
          ),

          if(selected != null) AmountWidget(
            labelText: "amount".T(cur.longName), // "Amount ${cur.longName}",
            onChanged: (value) {
              amStr = value;
              try {
                _amountRes.updateValue(getOAmount(amount, cur));
              } catch(e) {
                log(e.toString());
              }
            },
            controller: _amount,
            enabled: stage == 0,
            suffixText: "${cur.symbol}1=${selected?.symbol}${getOAmount(1, selected ?? CurTypes.usd).toTwoDigit()}",
          ),

          if(selected != null && amStr.length > rightSymbol.length ) AmountWidget(
            labelText: "amount".T(selected?.longName),
            suffixText: selected?.longName,
            controller: _amountRes,
            enabled: false,
          ),

          if(selected != null && amStr.length > rightSymbol.length && !keyboardOpen ) Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ButtonsWidget(
              stage: stage,
              onBack: onBack,
              onNext: () => onNext(cur),
            ),
          ),

        ],
      );
      },
    );
  }

  double getOAmount(double amount, CurTypes cur) {
    CurTypes defCurrency = RestApi.appModel.defCurrency;
    return RestApi.appModel.rate.calcOAmount(amount, cur, selected ?? CurTypes.usd, defCurrency);
  }

  String? checkErrors(CurTypes cur) {
    if(amount <= 0) {
      return "Invalid Amount";
    }

    if(!RestApi.appModel.wallet.hasAvailable(cur, amount)) {
      return("Insufficient liquidity");
    }

    return null;
  }

  void onNext(CurTypes cur) async {
    if(stage == 0) {
      if(keyboardOpen) {
        hideKeyboard();
      } else {
        String? err = checkErrors(cur);
        if(err != null) {
          showInfo(err.T());
        } else {
          stage = 1;
        }
      }
    } else {
      Order order = Order(
          type: OrderTypes.exchange,
          amount: amount,
          oAmount: getOAmount(amount, cur),
          cur: cur,
          ocur: selected,
          bwid: RestApi.appModel.branch?.wid,
          wid: RestApi.appModel.wid,
          bid: RestApi.appModel.bid,
      );

      RestApi.loading = true;
      String? res = await RestApi.blockAmount(order);
      if(res != null) {
        showInfo(res);
        RestApi.loading = false;
        return;
      }

      res = await RestApi.saveOrder(order);
      RestApi.loading = false;

      if(res != null) {
        showInfo(res);
      } else {
        Get.to(() => const ConfirmView(closeTimes: 2, type: OrderTypes.exchange));
      }
    }
  }

  void onBack() async {
    if(stage == 0) {
      if(amount > 0) {
        bool? h = await askQuestion("q.cancel");
        if((h ?? true)) Get.back();
      } else {
        Get.back();
      }
    } else {
      stage = 0;
    }
  }
}
