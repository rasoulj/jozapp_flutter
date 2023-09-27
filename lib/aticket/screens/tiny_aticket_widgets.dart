import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/aticket/models/airport.dart';
import 'package:jozapp_flutter/aticket/screens/airport_picker.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jozapp_flutter/widgets/simple_picker.dart';

class SelectDate extends StatefulWidget {
  final String label;
  final DateTime? date;
  final DateTime? minTime;
  final DateTime? maxTime;
  final ValueChanged<DateTime>? onSelect;
  final CrossAxisAlignment? crossAxisAlignment;

  const SelectDate({Key? key, required this.label, this.date, this.onSelect, this.crossAxisAlignment, this.minTime, this.maxTime}) : super(key: key);

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  @override
  Widget build(BuildContext context) {
    return Box3(
      crossAxisAlignment: widget.crossAxisAlignment,
      label: widget.label,
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Icon(Icons.calendar_today, color: AppColors.black2,),
          ),
          Text(widget.date?.formatDate ?? "(Select)", style: AppStyles.darkText14B,),
        ],
      ),
      onTap: () {
        DatePicker.showPicker(context,
            onConfirm: widget.onSelect,
            pickerModel: DatePickerModel(
                maxTime: widget.maxTime,
                minTime: widget.minTime,
                currentTime: widget.date,
            ),
        );
      },
    );
  }
}


class AirportSelect extends StatelessWidget {
  final Airport? airport;
  final String label;
  final ValueChanged<Airport?>? onSelect;
  const AirportSelect({Key? key, this.airport, required this.label, this.onSelect, this.crossAxisAlignment}) : super(key: key);
  final CrossAxisAlignment? crossAxisAlignment;


  void onTap() async {
      Airport? airport = await Get.to<Airport>(() => const AirportPicker());
      if(onSelect != null) {
        onSelect!(airport);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Box3(
      crossAxisAlignment: crossAxisAlignment,
      label: label,
      titleText: airport?.cityNameEn ?? "(Select)",
      subtitle: airport?.airportCode == null ? "-" : "( ${airport?.airportCode} )",
      onTap: onTap,
    );
  }
}

class Box3Label extends StatelessWidget {
  final String label;
  const Box3Label({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(color: Colors.grey[600]),);
  }
}


class Box3 extends StatelessWidget {
  final String label;
  final String titleText;
  final Widget? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final CrossAxisAlignment? crossAxisAlignment;

  Widget get body => Container(
    padding: const EdgeInsets.only(bottom: 8),
    decoration: AppStyles.underLineDecoration,
    child: Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        Box3Label(label: label),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: title ?? Text(titleText, style: AppStyles.accentText16B,),
        ),
        if(subtitle != null) Text(subtitle!, style: AppStyles.accentText,),
      ],
    ),
  );

  const Box3({Key? key, required this.label, this.titleText = "", this.subtitle, this.onTap, this.title, this.crossAxisAlignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return onTap == null ? body : GestureDetector(onTap: onTap, child: body,);
  }
}

class CountPicker extends StatelessWidget {
  final String label;
  final int count;
  final int minValue;
  final int length;
  final IconData icon;
  final CrossAxisAlignment? crossAxisAlignment;
  final ValueChanged<int>? onSelect;

  const CountPicker(
      {Key? key,
        required this.label,
        required this.count,
        required this.icon,
        this.crossAxisAlignment,
        this.onSelect,
        this.minValue = 0,
        this.length = 7,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimplePicker(
      items: List.generate(length, (index) => index+minValue),
      value: count,
      onChanged: (int c) {
        if(onSelect != null) onSelect!(c);
      },
      child: Box3(
        // onTap: () {},
        label: label,
        crossAxisAlignment: crossAxisAlignment,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(icon, color: AppColors.black2,),
            ),
            Text(count.toString(), style: AppStyles.darkText14B,),
          ],
        ),
      ),
    );
  }
}

class EasyDateChooser extends StatelessWidget {
  const EasyDateChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

