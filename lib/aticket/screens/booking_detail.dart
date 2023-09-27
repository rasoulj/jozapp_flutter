import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/aticket/api/aticket_api.dart';
import 'package:jozapp_flutter/aticket/models/at_response.dart';
import 'package:jozapp_flutter/aticket/models/book_result.dart';
import 'package:jozapp_flutter/aticket/models/passenger.dart';
import 'package:jozapp_flutter/aticket/models/search_result.dart';
import 'package:jozapp_flutter/aticket/providers/ticket_model.dart';
import 'package:jozapp_flutter/aticket/screens/issue_ticket.dart';
import 'package:jozapp_flutter/aticket/screens/passenger_view.dart';
import 'package:jozapp_flutter/aticket/screens/ticket_row.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

class _Title extends StatelessWidget {
  final String title;
  const _Title(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 18),
      child: Text(title, style: AppStyles.whiteText18,),
    );
  }
}

class PassengerTile extends StatelessWidget {
  final Passenger passenger;
  final int index;
  final VoidCallback? onRemove;
  final VoidCallback? onPressed;
  const PassengerTile({Key? key, required this.passenger, this.onRemove, this.onPressed, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      title: Text(passenger.isEmpty ? "(Select)" : passenger.name, style: AppStyles.whiteText,),
      leading: icon,
      trailing:  passenger.isEmpty || onRemove == null ? Icon(Icons.chevron_right, color: AppColors.grey1,) : IconButton(onPressed: onRemove, icon: const Icon(Icons.close, color: AppColors.accent,),),
    );
  }

  Widget get icon => TextIcon((index+1).toString(), color: passenger.color);
}

const _titles = [
  "Adult Passenger(s)",
  "Child Passenger(s)",
  "Infant Passenger(s)",
];

class BookingDetail extends StatelessWidget {
  const BookingDetail({Key? key}) : super(key: key);

  void onTap(Passenger p, int index) {
  }


  List<Widget> getChilds(BuildContext context) {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);

    List<Widget> all = <Widget>[];
    for(int type=0; type<3; type++) {
      var list = model.getPassengers(type);
      int len = list.length;
      if(len > 0) all.add(_Title(_titles[type]));
      for(int i=0; i<len; i++) {
        all.add(PassengerTile(
          passenger: list[i],
          index: i,
          onPressed: () async {
            Passenger? p = await Get.to<Passenger>(() => PassengerView(passenger: list[i], index: i,));
            if(p != null) {
              model.setPassenger(p, i);
            }
          },
          onRemove: () {
            model.setPassenger(Passenger.empty(type), i);
          },
        ));
      }
    }
    return all;
  }

  @override
  Widget build(BuildContext context) {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);

    return Scaffold(
      appBar: getAppBar("Passenger(s) Info"),
      backgroundColor: AppColors.black,
      body: ListView(
        children: [
          TicketRow(
            result: model.selectedResult ?? SearchResult(),
            isDetail: true
          ),
          ...getChilds(context),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: GenButton(
              rightIcon: true,
              icon: Icons.arrow_forward_ios,
              loading: model.loading,
              color: AppColors.accent,
              title: "Check Availability",
              onPressed: book,
            ),
          ),
        ],
      ),
    );
  }

  void book() async {
    var errors = TicketModel.i.passengerErrors;
    if(errors.isNotEmpty) {
      showErrors(errors);
      return;
    }

    Json bookData = await TicketModel.i.bookData;
    log(jsonEncode(bookData));

    TicketModel.i.loading = true;
    AtResponse resp = await AticketApi.book(bookData);
    TicketModel.i.loading = false;
    if(resp.success ?? false) {
      TicketModel.i.bookResult = resp.items as BookResult;
      Get.to(() => const IssueTicket());
    } else {
      showErrors([resp.items?.toString() ?? "Unknown error occurred"]);
    }
  }

}
