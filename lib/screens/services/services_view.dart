import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';

const double _iconSize = 70;


class _ServiceOption {
  String get title => type.longName;
  Widget get icon => type.icon(_iconSize);

  OrderTypes type;

  static final List<_ServiceOption> all = [
    _ServiceOption(OrderTypes.topUp),
    _ServiceOption(OrderTypes.withdraw),
    _ServiceOption(OrderTypes.transfer),
    _ServiceOption(OrderTypes.exchange),
    _ServiceOption(OrderTypes.airplaneTicket),
    _ServiceOption(OrderTypes.otp),
  ];

  _ServiceOption(this.type);
}


class ServicesView extends StatelessWidget {
  final bool shortList;
  final CurTypes? cur;
  const ServicesView({Key? key, this.shortList = false, this.cur}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 395 + (shortList ? 0 : 195),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          crossAxisCount: 2,
          children: _ServiceOption.all.sublist(0, shortList ? 4 : _ServiceOption.all.length).map((item) => GestureDetector(
            onTap: () => Get.to(item.type.route(cur), transition: Transition.fade),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.accent,
                boxShadow: AppStyles.boxShadow,
                borderRadius: AppStyles.borderAll(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item.icon,
                  Text(
                    item.title,
                    style: AppStyles.whiteText18,
                  ),
                ],
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }
}
