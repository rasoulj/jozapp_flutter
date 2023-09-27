import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/aticket/models/search_result.dart';
import 'package:jozapp_flutter/aticket/models/ticket.dart';
import 'package:jozapp_flutter/aticket/providers/ticket_model.dart';
import 'package:jozapp_flutter/aticket/screens/ticket_row.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/widgets/no_content.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

import 'new_aticket.dart';

class TicketsView extends StatefulWidget {
  final CurTypes? cur;

  const TicketsView({Key? key, this.cur}) : super(key: key);

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {

  List<Ticket>? _list;

  @override
  void initState() {
    // Timer(3.seconds, () {
    //   setState(() {
    //     _list = List.generate(20, (index) => index+1);
    //   });
    // });
    fetchData();
    super.initState();
  }

  void fetchData() async {
    Timer(0.seconds, () async {
      var resp = await RestApi.getAtickets();
      setState(() {
        _list = resp;
      });
      log("message: ${resp.length}");
    });
  }

  void addTicket() async {
    TicketModel.i.clear();
    bool? res = await Get.to<bool>(() => const NewAticket(),
      opaque: true,
      transition: Transition.fadeIn,
    );
    if(res ?? false) fetchData();
  }

  Widget get progress {
    var appModel = Provider.of<AppDataModel>(context, listen: true);
    return LinearProgressIndicator(
        value: appModel.loading ? null : 0,
        backgroundColor: Colors.transparent,
      );
  }

  Widget get empty =>
      const NoContent(
        imagePath: "no_ticket2",
        title: "No Airplane Ticket",
        subtitle: "Your airplane tickets will appear here",
      );

  Widget get body {
    var ll = _list ?? [];
    return AnimatedSwitcher(
    duration: 1000.milliseconds,
    child: ll.isEmpty ? empty : ListView.builder(
        itemCount: _list?.length ?? 0,
        itemBuilder: (_, i) => TicketRow(hasDate: true, result: ll[i].search ?? SearchResult(),),
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: addTicket,
          heroTag: newTicketTitle,
          label: const Text("New Ticket"),
        icon: const Icon(Icons.add),
      ),
      backgroundColor: AppColors.black,
      appBar: getAppBar(OrderTypes.airplaneTicket.longName),
      body: SafeArea(child: Column(
        children: [
          progress,
          Expanded(child: body),
        ],
      ),),

    );
  }
}
