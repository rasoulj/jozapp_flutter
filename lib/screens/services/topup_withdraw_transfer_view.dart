import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/wid.dart';
import 'package:jozapp_flutter/models/order.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/screens/services/services_widgets.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/available_cur.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'confirm_view.dart';
import 'service_main_view.dart';

const Map<OrderTypes, String> _subtitles = {
  OrderTypes.topUp: "OrderTypes.topUp.ts",
  OrderTypes.withdraw: "OrderTypes.withdraw.ts",
  OrderTypes.transfer: "OrderTypes.transfer.ts",
};

const Map<OrderTypes, String> _titles = {
  OrderTypes.topUp: "OrderTypes.topUp.t",
  OrderTypes.withdraw: "OrderTypes.withdraw.t",
  OrderTypes.transfer: "OrderTypes.transfer.t",
};


class TWTView extends StatefulWidget {
  final CurTypes? cur;
  final OrderTypes type;

  const TWTView({Key? key, this.cur, this.type = OrderTypes.topUp}) : super(key: key);

  @override
  State<TWTView> createState() => _TWTViewState();
}

class _TWTViewState extends State<TWTView> {


  String rightSymbol =  " ";

  @override
  void initState() {
    _wid = MaskedTextController(mask: "0000-0000-0000-0000");



    if(widget.type == OrderTypes.transfer) {
      _loadFees();
    }
    super.initState();
  }

  void _loadFees() async {
    EasyLoading.show(status: "Loading fees ...");
    await RestApi.loadFees();
    EasyLoading.dismiss(animation: true);
    // RestApi.appModel.loading = false;
  }

  String get _title => _titles[widget.type] ?? "NA";
  String get _titleShort => widget.type.longName;
  String get _subtitle => _subtitles[widget.type] ?? "NA";

  CurTypes? existing;

  @override
  Widget build(BuildContext context) {


    return ServiceMainView(
      cur: widget.cur,
      title:  _title,
      subtitle: _subtitle,
      builder: (CurTypes cur) {
        if(cur != existing) {
          existing = cur;
          rightSymbol = " " + cur.symbol;
          _amount = MoneyMaskedTextController(
              rightSymbol: rightSymbol,
              precision: 0, decimalSeparator: '', thousandSeparator: ',');
        }
        return Container(
        decoration: const BoxDecoration(
            color: AppColors.accent,
            borderRadius: AppStyles.borderBottom2,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 8),
              child: Center(child: Text(_titleShort, style: AppStyles.whiteText18,),),
            ),
            AvailableCur(cur: cur,),
            AmountWidget(controller: _amount, enabled: stage == 0,),
            if(widget.type == OrderTypes.transfer) WidWidget(controller: _wid, enabled: stage == 0,),
            if(!keyboardOpen) ButtonsWidget(stage: stage, onBack: onBack, onNext: () => onNext(cur),),
            // _buildButtons(),
          ],
        ),
      );
      },
    );
  }

  bool get keyboardOpen => MediaQuery.of(context).viewInsets.bottom > 0;

  MoneyMaskedTextController? _amount;
  late final MaskedTextController _wid;

  int _stage = 0;
  int get stage => _stage;
  set stage(int value) => setState(() => _stage = value);



  String? checkErrors(CurTypes cur) {

    if(amount <= 0) {
      return "err.invalid_amount";
    }

    if(widget.type == OrderTypes.transfer && Wid.fromFormal(_wid.text) == null) {
      return "err.invalid_wallet_number";
    }

    if(widget.type != OrderTypes.topUp && !RestApi.appModel.wallet.hasAvailable(cur, amount)) {
      return("err.insufficient_liquidity");
    }

    return null;
  }

  double get amount {
    if(_amount?.text == rightSymbol) return 0;
    return _amount?.numberValue ?? 0;
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

  void onNext(CurTypes cur) async {
    if(stage == 0) {
      if(keyboardOpen) {
        hideKeyboard();
      } else {
        log(_wid.text);

        String? err = checkErrors(cur);
        if(err != null) {
          showInfo(err.T());
        } else {
          stage = 1;
        }
      }
    } else if(widget.type != OrderTypes.transfer) { //OrderTypes.topUp, OrderTypes.withdraw
      Order order = Order(
          type: widget.type,
          cur: cur,
          amount: amount,
          wid: RestApi.appModel.wid
      );

      var model = Provider.of<AppDataModel>(context, listen: false);

      model.loading = true;
      if(order.type == OrderTypes.withdraw) {
        var pp = await RestApi.blockAmount(order);
        if(pp != null) {
          model.loading = false;
          showToast(pp);
          return;
        }
      }
      String? res = await RestApi.saveOrder(order);
      model.loading = false;

      if(res == null) {
        Get.to(() => ConfirmView(closeTimes: 2, type: widget.type));
      } else {
        showToast(res);
      }

    } else if(widget.type == OrderTypes.transfer) {

      Order order = Order(
          amount: amount,
          wid: RestApi.appModel.wid,
          cur: cur,
          cwid: Wid.fromFormal(_wid.text),
          fee: RestApi.appModel.fees.transfer*amount/100.0,
          bid: RestApi.appModel.bid,
          bwid: RestApi.appModel.branch?.wid,
      );
      RestApi.loading = true;
      String? res = await RestApi.doWallets(order.transferTransactions);
      RestApi.loading = false;

      if(res == null) {
        Get.to(() => ConfirmView(closeTimes: 2, type: widget.type));
      } else {
        showToast(res);
      }

    }
  }

}
