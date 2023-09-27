
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/widgets/gen_button.dart';

class AuthHeroButton extends StatelessWidget {
  const AuthHeroButton({Key? key, this.title, this.icon, this.onPressed, this.color}) : super(key: key);
  final String? title;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title ?? "NA",
      child: GenButton(
        color: color ?? AppColors.black2,
        title: title,
        onPressed: onPressed,
      ),
    );
  }
}


class AuthBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AuthBackButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const BackButton();
    return GenButton(
      rightIcon: isRTL(),
      icon: Icons.arrow_back_ios,
      color: Colors.grey,
      onPressed: onPressed ?? Get.back,
      title: "Back",
    );
  }
}

