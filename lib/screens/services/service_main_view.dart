import 'dart:async';

import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/screens/wallet/view_currency.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/app_modal.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';


class SelectCur extends StatelessWidget {
  // const SelectCur({Key? key}) : super(key: key);

  late final FixedExtentScrollController _scrollController;// = FixedExtentScrollController(initialItem: 2);

  final CurTypes selectedCur;
  static const double _itemHeight = 100;

  SelectCur({
    Key? key,
    this.onChanged,
    this.selectedCur = CurTypes.usd
  }) : super(key: key) {
    int initialItem = AppConfig.activeCurrencies.indexOf(selectedCur);
    _scrollController = FixedExtentScrollController(initialItem: initialItem);
  }

  final ValueChanged<CurTypes>? onChanged;


  @override
  Widget build(BuildContext context) {
    var all = AppConfig.activeCurrencies;


    return ClickableListWheelScrollView(
        scrollController: _scrollController,
        itemHeight: _itemHeight,
        itemCount: all.length,
        onItemTapCallback: (index) {

          if(onChanged != null && _scrollController.selectedItem == index) {
            onChanged!(all[index]);
            Get.back();
          }
        },
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          itemExtent: _itemHeight,
          physics: const FixedExtentScrollPhysics(),
          overAndUnderCenterOpacity: 0.75,
          perspective: 0.0039,
          // onSelectedItemChanged: (index) {
          //   log("onSelectedItemChanged index: $index");
          // },
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) => ViewCurrency(cur: all[index], color: AppColors.accent,),
            childCount: all.length,
          ),
        ),
    );
  }


  static void select(CurTypes? cur, ValueChanged<CurTypes> onChanged) async {
    Navigator.of(Get.context!).push(AppModalOverlay(
        SelectCur(
          selectedCur: cur ?? CurTypes.usd,
          onChanged: onChanged,
        ), hasDismiss: cur != null),);
  }


}

class ServiceMainView extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final CurTypes? cur;
  final CurBuilder? builder;
  final MainAxisAlignment mainAxisAlignment;
  const ServiceMainView({
    Key? key,
    this.cur,
    this.title,
    this.subtitle,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween, this.builder,
  }) : super(key: key);

  @override
  State<ServiceMainView> createState() => _ServiceMainViewState();
}

class _ServiceMainViewState extends State<ServiceMainView> {

  CurTypes? _cur;
  CurTypes? get cur => _cur;
  set cur(CurTypes? value) => setState(() => _cur = value);


  @override
  void initState() {
    super.initState();
    cur = widget.cur;
    if(widget.cur == null) Timer(200.milliseconds, onSelectCur);
  }

  void onSelectCur() {
    SelectCur.select(cur, (value) => cur = value);
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: hideKeyboard,
      child: Scaffold(
        appBar: getAppBar(widget.title ?? "NA", subtitle: widget.subtitle),
        body: cur == null ? null : SizedBox(
          height: Get.height,
          child: Column(
            mainAxisAlignment: widget.mainAxisAlignment,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ViewCurrency(
                  color: AppColors.white,
                  cur: cur!,
                  onPress: widget.cur == null ? onSelectCur : null,
                ),
              ),
              if(widget.builder != null) widget.builder!(cur ?? CurTypes.usd),
            ],
          ),
        ),
        backgroundColor: AppColors.black,
      ),
    );
  }
}
