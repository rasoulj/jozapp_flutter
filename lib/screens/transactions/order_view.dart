import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/order.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class _Option {
  final String title;
  final String value;
  final IconData icon;

  _Option(this.title, this.value, this.icon);

}

class OrderView extends StatefulWidget {
  final Order order;


  const OrderView({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final ScreenshotController _controller = ScreenshotController();

  List<_Option> get options =>
      [
        _Option(
            "order.type",
            widget.order.type?.longName ?? "-",
            Icons.looks_one_rounded,
        ),
        _Option(
            "order.amount",
          "${widget.order.cur.symbol} ${widget.order.amount.toTwoDigit()}",
            Icons.looks_two_rounded,
        ),
        _Option(
            "order.issue_date",
            widget.order.createdAt?.formatDate ?? "-",
            Icons.three_p,
        ),
      ];

  void shareIt() async {
    _controller.shareIt();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      fromTop: true,
      title: "order.view",
      headerSection: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.order.getBadge(120),
          IconButton(onPressed: _controller.shareIt, icon: const Icon(Icons.share, color: AppColors.white, size: 32,)),
        ],
      ),
      body: Screenshot(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: options.map((e) =>
                ListTile(
                  leading: Icon(e.icon, color: AppColors.white,),
                  trailing: Text(e.value, style: AppStyles.whiteTextB,),
                  title: Text(e.title.T(), style: AppStyles.whiteText),
                )).toList(),
          ),
        ),
      ),
    );
  }
}
