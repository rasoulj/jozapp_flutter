import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/aticket/models/search_result.dart';
import 'package:jozapp_flutter/aticket/providers/ticket_model.dart';
import 'package:jozapp_flutter/aticket/screens/ticket_row.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:jozapp_flutter/widgets/no_content.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class FlightsList extends StatefulWidget {
  const FlightsList({Key? key}) : super(key: key);

  @override
  State<FlightsList> createState() => _FlightsListState();
}

class _FlightsListState extends State<FlightsList> {
  late int _value, minValue, maxValue;

  @override
  void initState() {
    adjustValues();
    super.initState();
  }

  void adjustValues() {
    DateTime t = TicketModel.i.fromDate?.getDay ?? DateTime.now().getDay;
    int min = -t.difference(DateTime.now().getDay).inDays;
    setState(() {
      _value = 0;
      minValue = math.max(-20, min);
      maxValue = 40;
    });
  }

  int get value => _value;

  set value(int p) => setState(() {
    _value = p;
  });


  Widget get list {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);
    List<SearchResult> results = model.searchResult ?? <SearchResult>[];
    int len = model.searchResult?.length ?? 0;
    return Visibility(
      visible: len > 0,
      replacement: SliverToBoxAdapter(child: NoContent(
        title: "No Flight",
        subtitle: "No Flight in ${model.fromDate?.formatDate ?? "-"} ",
      )),
      child: SliverList(
        delegate: SliverChildBuilderDelegate((_, i) {
            return TicketRow(result: results[i], last: i+1 == len, index: i,);
          },
          childCount: len,
        ),
      ),
    );
  }

  Timer? _timer;

  void setIsTyping() {
    _timer?.cancel();
    _timer = Timer(1.5.seconds, loadTickets);
  }



  void loadTickets() async {
    if(value == 0) return;
    showLoading();
    TicketModel.i.fromDate = TicketModel.i.fromDate?.add(value.days);
    adjustValues();
    await TicketModel.i.doSearch();
    hideLoading();
  }

  String textMapper(String ss) {
    int i = int.tryParse(ss) ?? -100;
    DateTime t = TicketModel.i.fromDate?.add(i.days) ?? DateTime.now();
    return " ${t.day}\n${t.formatMonth}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.accent,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                leading: IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios, color: AppColors.black,),), // ,
                backgroundColor: AppColors.white,
                expandedHeight: 160.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Flight List", style: AppStyles.darkText24Bold,),
                      number,
                    ],
                  ),
                  // background: WalletLogo(width: 3,),
                ),

              ),
              const SliverDelim(
                headerColor: AppColors.accent,
                bodyColor: AppColors.white,
                fromTop: true,
                negative: true,
              ),
              list,

            ],


        ),

      ),
    );
  }

  Widget get number {
    try {
      // log("min, max, value: $minValue, $maxValue, $value");
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: NumberPicker(
          decoration: BoxDecoration(
            color: AppColors.accent.withAlpha(70),
            borderRadius: BorderRadius.circular(16),
            // border: Border.all(color: Colors.black26),
          ),
          // selectedTextStyle: TextStyle(color: Colors.grey[200]),
          textStyle: AppStyles.accentText,
          zeroPad: true,
          itemHeight: 70,
          textMapper: textMapper,
          // itemCount: 7,
          axis: Axis.horizontal,
          onChanged: (p) {
            value = p;
            setIsTyping();
          },
          maxValue: maxValue,
          value: value,
          minValue: minValue,),
      );
    } catch(e) {
      return const ZeroWidget();
    }
  }
}
