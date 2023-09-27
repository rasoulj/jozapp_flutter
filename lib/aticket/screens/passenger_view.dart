import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/aticket/models/passenger.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';
import 'package:jozapp_flutter/widgets/input_ex.dart';
import 'package:jozapp_flutter/widgets/input_ex2.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

import 'tiny_aticket_widgets.dart';

class PassengerView extends StatefulWidget {
  final Passenger passenger;
  final int index;
  const PassengerView({Key? key, required this.passenger, required this.index}) : super(key: key);

  @override
  State<PassengerView> createState() => _PassengerViewState();
}

class _PassengerViewState extends State<PassengerView> {
  late final AppController? _c;

  bool get isForeigners => _c?.getValue<bool?>("isForeigners") ?? false;
  set isForeigners(bool value) => _c?.setValue("isForeigners", value);

  int get gender => _c?.getValue<int?>("gender") ?? 0;
  set gender(int value) => _c?.setValue("gender", value);

  String? get latinFirstName => _c?.getValue<String?>("latinFirstName");
  set latinFirstName(String? value) => _c?.setValue("latinFirstName", value);

  String? get latinLastName => _c?.getValue<String?>("latinLastName");
  set latinLastName(String? value) => _c?.setValue("latinLastName", value);

  String? get nationalCode => _c?.getValue<String?>("nationalCode");
  set nationalCode(String? value) => _c?.setValue("nationalCode", value);

  DateTime? get birthDay => _c?.getValue<DateTime?>("birthDay");
  set birthDay(DateTime? value) => _c?.setValue("birthDay", value);

  String? get passportNumber => _c?.getValue<String?>("passportNumber");
  set passportNumber(String? value) => _c?.setValue("passportNumber", value);

  DateTime? get passportExpireDate => _c?.getValue<DateTime?>("passportExpireDate");
  set passportExpireDate(DateTime? value) => _c?.setValue("passportExpireDate", value);


  @override
  void initState() {
    _c = AppController(this);
    _c?.append(widget.passenger.toJson());
    super.initState();
  }

  Widget get body {
    bool f = isForeigners;
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InputEx2(controller: _c,
              field: "latinFirstName",
              title: "First Name",
              hintText: "First Name",),
            InputEx2(controller: _c,
              field: "latinLastName",
              title: "Last Name",
              hintText: "Last Name",),
            if(!f) InputEx2(controller: _c,
              field: "nationalCode",
              title: "National Code",
              keyboardType: TextInputType.number,
              hintText: "National Code",),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectDate(
                    label: 'Birth Date',
                    date: birthDay,
                    onSelect: (date) => birthDay = date,
                    maxTime: DateTime.now(),
                  ),
                  if(f) SelectDate(
                    minTime: DateTime.now(),
                    label: 'Passport Expiry',
                    date: passportExpireDate,
                    onSelect: (date) => passportExpireDate = date,
                  ),
                ],
              ),

            ),
            if(f) InputEx2(controller: _c,
              keyboardType: TextInputType.number,
              field: "passportNumber",
              title: "Passport Number",
              hintText: "passport Number",),
            navBtn,
          ],
        ),
      ),
    );
  }

  Widget get isForeignersWidget => CupertinoSlidingSegmentedControl<bool>(
    backgroundColor: AppColors.black,
    thumbColor: AppColors.accent,
    padding: const EdgeInsets.only(bottom: 10),
    groupValue: isForeigners,
    children: const {
      false: Text("Domestic", style: AppStyles.whiteText,),
      true: Text("Foreigners", style: AppStyles.whiteText,),
    },
    onValueChanged: (p) => isForeigners = p ?? false,
  );

  Widget get genderWidget => CupertinoSlidingSegmentedControl<int>(
    backgroundColor: AppColors.black,
    thumbColor: AppColors.accent,
    padding: const EdgeInsets.only(bottom: 10),
    groupValue: gender,
    children: const {
      0: Text("Male", style: AppStyles.whiteText,),
      1: Text("Female", style: AppStyles.whiteText,),
    },
    onValueChanged: (p) => gender = p ?? 0,
  );

  Widget get navBtn => Padding(
    padding: const EdgeInsets.only(top: 18.0),
    child: GenButton(
      color: AppColors.accent,
      title: "Save",
      onPressed: onBook,
    ),
  );

  void onBook() {
    var p = Passenger.fromJson(_c?.toJson() ?? {});
    var errors = p.errors;
    if(errors.isNotEmpty) {
      showErrors(errors);
    } else {
      Get.back(result: p);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      headerSection: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextIcon((widget.index+1).toString(), color: widget.passenger.color, size: 16,),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(widget.passenger.typeString, style: AppStyles.whiteText16,),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              isForeignersWidget,
              genderWidget,
            ],
          ),
        ],
      ),
      title: "Passenger Detail",
      fromTop: true,
      headerColor: AppColors.black,
      bodyColor: AppColors.white,
      body: body,
    );
  }
}
