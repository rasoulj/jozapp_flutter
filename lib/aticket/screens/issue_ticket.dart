import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/aticket/api/aticket_api.dart';
import 'package:jozapp_flutter/aticket/models/at_response.dart';
import 'package:jozapp_flutter/aticket/models/ticket_result.dart';
import 'package:jozapp_flutter/aticket/providers/ticket_model.dart';
import 'package:jozapp_flutter/models/order.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:jozapp_flutter/widgets/card_title.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:jozapp_flutter/widgets/ok_view.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

class _TermDef extends StatelessWidget {
  final String term;
  final String def;
  const _TermDef(this.term, this.def, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: TextIcon(term),
      title: Text(term),
      trailing: Text(def, style: AppStyles.darkText14B,),
    );
  }
}

String _toVal(double? val, String cur) {
  return (val ?? 0).toTwoDigit()+cur;
}

class IssueTicket extends StatelessWidget {
  const IssueTicket({Key? key}) : super(key: key);

  Widget get passengers {
    var model = TicketModel.i;
    return TitledCard(
      title: "Passenger(s) Summary",
      child: Column(
        children: [
          ...model.getPassengers(0).map((p) => _TermDef(p.name, "Adult")),
          ...model.getPassengers(1).map((p) => _TermDef(p.name, "Child")),
          ...model.getPassengers(2).map((p) => _TermDef(p.name, "Infant")),
        ],
      ),
    );
  }

  Widget get summary {
    var model = TicketModel.i;
    int pc = model.adultCount + model.childCount + model.infantCount;
    var info = TicketModel.i.bookResult;
    var price = info?.totalFare;
    String cur = price?.currency ?? "";
    return TitledCard(
      title: "Ticket Summary",
      child: Column(
        children: [
          _TermDef("Passengers", pc.toString()),
          _TermDef("Contract No", info?.contractNo.toString() ?? "-"),
          _TermDef("Total Fare", _toVal(price?.totalFare, cur)),
        ],
      ),
    );
  }

  void issueTicket() async {

    var model = TicketModel.i;
    // log(model.bookResult?.issueInfo?.toString() ?? "-");
    // return;


    CurTypes cur = toCurTypes(TicketModel.i.selectedResult?.currency ?? "usd");
    double avail = RestApi.appModel.wallet.value(cur);

    double amount = model.selectedResult?.totalPrice ?? 0;

    if(amount > avail) {
      log("amount > avail: $amount > $avail");
      showErrors(["Insufficient liquidity"]);
      return;
    }

    model.loading = true;
    AtResponse resp = await AticketApi.ticket(model.bookResult?.issueInfo ?? {});
    model.loading = false;

    if(resp.success ?? false) {
      RestApi.saveTicket(model.selectedResult, resp.items as TicketResult);



      Order order = Order(
        amount: amount,
        wid: RestApi.appModel.wid,
        cur: toCurTypes(model.selectedResult?.currency),
        bid: RestApi.appModel.bid,
        bwid: RestApi.appModel.branch?.wid,
      );
      RestApi.loading = true;
      String? res = await RestApi.doWallets(order.aticketTransactions);
      RestApi.loading = false;

      Get.to(() => const OkView(closeTimes: 5, title: "msg.ticket_issue",));
    } else {
      showErrors([resp.items?.toString() ?? "Unknown Error"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);

    return BaseScreen(
      headerSection: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Ticket almost ready!", style: AppStyles.whiteText24,),
        ],
      ),
      bodyColor: Colors.grey[200],
      title: "Issue Ticket",
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            summary,
            passengers,
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: GenButton(
                color: AppColors.accent,
                rightIcon: true,
                icon: Icons.check_circle,
                loading: model.loading || RestApi.loading,
                onPressed: issueTicket,
                title: "Issue Ticket",
              ),
            )
          ],
        ),
      ),
    );
  }
}
