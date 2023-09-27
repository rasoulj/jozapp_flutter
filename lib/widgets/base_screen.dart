import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class BaseScreen extends StatelessWidget {
  final bool fromTop;
  final bool negative;
  final Widget? body;
  final String? title;
  final Widget? back;
  final Widget? headerSection;
  final VoidCallback? onBack;
  final Color? bodyColor;
  final Color? headerColor;

  const BaseScreen({
    Key? key,
    this.fromTop = false,
    this.negative = false,
    this.body, this.title, this.back,
    this.headerSection, this.onBack, this.bodyColor, this.headerColor,
  }) : super(key: key);

  Color get bgBody => bodyColor ?? (negative ? AppColors.accent : AppColors.black);
  Color get bgHeader => headerColor ?? (!negative ? AppColors.accent : AppColors.black);


  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      child: headerSection ?? const WalletLogo(),
      decoration: BoxDecoration(
        color: bgHeader,
        borderRadius: AppStyles.borderHeader,
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: double.infinity,
      child: body ?? const ZeroWidget(),
      decoration: BoxDecoration(
        color: bgBody,
        borderRadius: AppStyles.borderBottom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool dark = AppColors.isDark(bgHeader);
    Color color = dark ? AppColors.white : AppColors.black;
    return GestureDetector(
      onTap: hideKeyboard,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: onBack ?? Get.back, icon: Icon(Icons.arrow_back_ios, color: color,),), // ,
          backgroundColor: bgHeader,
          elevation: 0,
          title: title != null ? Text(title!.T(), style: !dark ? AppStyles.darkText : AppStyles.whiteText,) : null,
        ),
        backgroundColor: fromTop ? bgHeader : bgBody,
        body: Column(
          children: [
            Expanded(flex: 2, child: _buildHeader()),
            Expanded(flex: 7, child: _buildBody()),
          ],
        ),
      ),
    );
  }
}
