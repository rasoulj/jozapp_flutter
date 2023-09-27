import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';
import 'package:jozapp_flutter/aticket/api/aticket_api.dart';
import 'package:jozapp_flutter/aticket/models/airport.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/input_ex.dart';
import 'package:jozapp_flutter/widgets/input_ex2.dart';
import 'package:jozapp_flutter/widgets/no_content.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

const String _kSearchField = "searchText";

///  Created by rasoulj on 5/13/2022 AD.
class AirportPicker extends StatefulWidget {
  const AirportPicker({Key? key}) : super(key: key);

  @override
  State<AirportPicker> createState() => _AirportPickerState();
}

class _AirportPickerState extends State<AirportPicker> {
  AppController? _c;


  String get searchText => _c?.getValue(_kSearchField) ?? '';

  set searchText(String value) => _c?.setValue(_kSearchField, value);

  bool get loading => _c?.getValue('loading') ?? false;

  set loading(bool value) => _c?.setValue('loading', value);

  List<Airport> get airports => _c?.getValue('airports') ?? [];

  set airports(List<Airport> value) => _c?.setValue('airports', value);

  Widget get progress =>
      LinearProgressIndicator(
        value: loading ? null : 0,
        backgroundColor: Colors.transparent,
      );

  @override
  void initState() {
    _c = AppController(this);
    loadAirports("thr");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Airport Picker"),
      backgroundColor: AppColors.black,
      body: Column(
        children: [
          progress,
          input,
          searchResult,
        ],
      ),

    );
  }

  Timer? _timer;

  void setIsTyping() {
    _timer?.cancel();
    _timer = Timer(1.4.seconds, () => loadAirports(searchText));
  }

  void loadAirports(String q) async {
    if (q == "") {
      airports = [];
      return;
    }

    loading = true;

    var res = await AticketApi.getAirports(q);


    loading = false;

    if (res.success ?? false) {
      airports = res.items as List<Airport>;
    } else {
      airports = [];
    }
  }

  Widget get input =>
      Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 12, left: 8, right: 8),
        child: InputEx2(
          onChange: (value) {
            if (value == "") airports = [];
            setIsTyping();
          },
          hintText: "Enter address",
          controller: _c,
          field: _kSearchField,
        ),
      );

  Widget get searchResult {
    return Expanded(
      child: Visibility(
        replacement: const NoContent(
          title: "No Airport",
          subtitle: "",
          imagePath: "no_airport",
        ),
        visible: airports.isNotEmpty,
        child: ListView.builder(
          itemCount: airports.length,
          itemBuilder: (_, i) {
            Airport a = airports[i];

            return ListTile(
              onTap: () => Get.back(result: a),
              trailing: const Icon(Icons.chevron_right, color: AppColors.white,),
              leading: const RoundIcon(Icons.local_airport),
              subtitle: Text("${a.airportCode}, ${a.countryCode}", style: AppStyles.greyText,),
              title: Text(a.airportNameEn ?? "-", style: AppStyles.whiteText,),
            );
          },
        ),
      ),
    );
  }
}
