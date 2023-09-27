import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';
import 'package:jozapp_flutter/aticket/api/aticket_api.dart';
import 'package:jozapp_flutter/aticket/models/airport.dart';
import 'package:jozapp_flutter/aticket/models/search_result.dart';
import 'package:jozapp_flutter/aticket/providers/ticket_model.dart';
import 'package:jozapp_flutter/intl/langs/fa.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

import 'flights_list.dart';
import 'tiny_aticket_widgets.dart';

const String newTicketTitle = "New Ticket";

class NewAticket extends StatefulWidget {
  const NewAticket({Key? key}) : super(key: key);

  @override
  State<NewAticket> createState() => _NewAticketState();
}

class _NewAticketState extends State<NewAticket> {

  Widget get selectFlightDirWidget {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);

    return CupertinoSlidingSegmentedControl<int>(
      backgroundColor: AppColors.accent,
      thumbColor: AppColors.white,
      padding: const EdgeInsets.only(bottom: 10),
      groupValue: model.dirType,
      children: const {
        0: Text("One Way"),
        1: Text("Round Trip"),
      },
      onValueChanged: (p) => model.dirType = p ?? 0,
    );
  }

  Widget get selectDates {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SelectDate(
            minTime: DateTime.now(),
            crossAxisAlignment: CrossAxisAlignment.start,
            label: 'Depart',
            onSelect: (date) => model.fromDate = date,
            date: model.fromDate,
          ),
          if(model.dirType == 1) SelectDate(
            minTime: DateTime.now(),
            crossAxisAlignment: CrossAxisAlignment.end,
            label: 'Return',
            onSelect: (date) => model.toDate = date,
            date: model.toDate,
          ),
        ],
      ),
    );
  }

  void searchFlights() async {
    var errors = TicketModel.i.searchErrors;
    if(errors.isNotEmpty) {
      showErrors(errors);
      return;
    }

    if(await TicketModel.i.doSearch()) {
      Get.to(() => const FlightsList());
    }
  }

  Widget get searchBtn {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: GenButton(
        loading: model.loading,
        icon: Icons.search,
        rightIcon: true,
        color: AppColors.accent,
        onPressed: searchFlights,
        title: "Search Flights",
      ),
    );
  }

  Widget get selectClass {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: const [
              Box3Label(label: "Class"),
            ],
          ),
          CupertinoSlidingSegmentedControl<int>(
            backgroundColor: AppColors.white,
            // thumbColor: CupertinoColors.activeOrange,
            thumbColor: AppColors.accent,
            // padding: const EdgeInsets.only(bottom: 10),
            groupValue: model.flightClass,
            children: const {
              0: Text("Economy"),
              1: Text("Business"),
              2: Text("Elite"),
            },
            onValueChanged: (p) => model.flightClass = p ?? 0,
          )
        ],
      ),
    );
  }

  Widget get selectCounts {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CountPicker(
            minValue: 1,
            length: 6,
            onSelect: (i) => model.adultCount = i,
            label: "Adults",
            count: model.adultCount,
            icon: Icons.person,
          ),
          CountPicker(
            onSelect: (i) => model.childCount = i,
            label: "Children",
            count: model.childCount,
            icon: Icons.child_care,
          ),
          CountPicker(
            onSelect: (i) => model.infantCount = i,
            label: "Infants",
            count: model.infantCount,
            icon: Icons.child_friendly,
          ),
        ],
      ),
    );
  }

  Widget get selectAirportsWidget {
    TicketModel model = Provider.of<TicketModel>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AirportSelect(
            crossAxisAlignment: CrossAxisAlignment.start,
            onSelect: (airport) => model.from = airport,
            label: 'From',
            airport: model.from,
          ),
          Icon(Icons.flight_takeoff, color: Colors.grey[500], size: 50,),
          AirportSelect(
            crossAxisAlignment: CrossAxisAlignment.end,
            onSelect: (airport) => model.to = airport,
            label: 'To',
            airport: model.to,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      fromTop: true,
      bodyColor: AppColors.white,
      headerSection: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                PadV(child: Text("Book Your", style: AppStyles.whiteText24,)),
                PadV(child: Text("Flight Now", style: AppStyles.whiteText32B,)),
              ],
            ),
            selectFlightDirWidget
          ],
        ),
      ),
      body: Column(
        children: [
          selectAirportsWidget,
          selectDates,
          selectCounts,
          selectClass,
          searchBtn,
        ],
      ),
    );
  }
}
