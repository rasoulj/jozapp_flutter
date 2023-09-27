import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

class OtpView extends StatefulWidget {
  final CurTypes? cur;
  const OtpView({Key? key, this.cur = CurTypes.usd}) : super(key: key);

  @override
  _OtpViewState createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {

  @override
  void initState() {
    Timer(50.milliseconds, initTimer);
    super.initState();
  }

  double _time = 120.0;
  double get time => _time;
  set time(double value) {
    if(mounted) setState(() => _time = value);
  }

  double get value => _time/120.0;

  int _otp = 0;
  int get otp => _otp;
  set otp(int value) => setState(() => _otp = value);

  String get otpLabel => enable ? otp.toString() : "-----";

  void initTimer() async {
    if(enable) return;
    // EasyLoading.show(status: "Loading ...");
    otp = await RestApi.createOtp();
    // EasyLoading.dismiss();

    time = 0;
    Timer.periodic(5.milliseconds, (timer) {
      time = time + 0.005;
      if(!enable) timer.cancel();
    });
  }

  String get timeLabel {
    var val = 120 - time.floor();
    if(val <= 0) return "NEW";
    if(val < 10) return "00" + val.toString();
    if(val < 100) return "0" + val.toString();
    return val.toString();

  }

  Color get color {
    if(time < 10) return Colors.green[900]!;
    if(time < 20) return Colors.green[800]!;
    if(time < 30) return Colors.green[700]!;
    if(time < 40) return Colors.green[600]!;
    if(time < 50) return Colors.green[500]!;
    if(time < 60) return Colors.green[400]!;
    if(time < 70) return Colors.red[100]!;
    if(time < 80) return Colors.red[300]!;
    if(time < 90) return Colors.red[500]!;
    if(time < 100) return Colors.red[700]!;
    if(time < 110) return Colors.red[800]!;
    return Colors.red[900]!;
  }

  bool get enable => time < 120;

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("OrderTypes.otp.l".T()),
        backgroundColor: AppColors.black,
      ),
      backgroundColor: AppColors.black,

      body: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: [
                SizedBox(
                    width: Get.width/2,
                    height: Get.width/2,
                    child: CircularProgressIndicator(
                      color: Colors.grey[800],
                      value: model.loading ? null : value,
                      strokeWidth: 10,
                      backgroundColor: model.loading ? Colors.grey[600] : color,
                    )),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(child:
                          model.loading ? const ZeroWidget() :
                          !enable ? Icon(Icons.refresh, color: Colors.grey[800]!, size: 80,) :
                          Text(timeLabel, style: AppStyles.whiteText40T,), onTap: initTimer,))),

              ],
            ),

            if(enable) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(otpLabel, style: AppStyles.whiteText40T,),
                const SizedBox(width: 10,),
                IconButton(onPressed:  !enable ? null : () {
                  Clipboard.setData(ClipboardData(text: otpLabel));
                  EasyLoading.showSuccess("OTP copied to clipboard");

                }, icon: const Icon(Icons.copy, color: AppColors.white,))
              ],
            ),

            if(!enable) const SizedBox(height: 50,),

            const ZeroWidget(),
          ],
        ),
      ),
    );
  }
}
