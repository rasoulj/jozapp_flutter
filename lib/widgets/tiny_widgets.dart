import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';

double get visWidth => Get.width/1.3;


class AppBackButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  const AppBackButton({Key? key, this.backgroundColor, this.foregroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BackButtonIcon();
  }
}


class AppCloseButton extends StatelessWidget {
  const AppCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Get.back(),
      child: const Icon(Icons.close),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
        primary: Colors.grey, // <-- Button color
        // onPrimary: Colors.red, // <-- Splash color
      ),
    );
  }
}


class ZeroWidget extends StatelessWidget {
  const ZeroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AppController {
  final Json _data = {};
  final State? state;

  Json toJson() => _data;
  void append(Json json) => state?.setState(() {
    _data.addAll(json);
  });

  AppController(this.state, {Json init = const {}});

  T? getValue<T>(String key, {T? defValue}) => _data.containsKey(key) ? _data[key] as T : defValue;
  void setValue<T>(String key, T value) {
    if(!state!.mounted) return;
    // ignore: invalid_use_of_protected_member
    state?.setState(() {
      _data[key] = value;
    });
  }
}

class Delim extends StatelessWidget {
  const Delim({Key? key, this.fromTop = true, this.negative = true, this.bodyColor, this.headerColor}) : super(key: key);
  final bool fromTop;
  final bool negative;
  final Color? bodyColor;
  final Color? headerColor;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: bodyColor ?? (negative ? AppColors.accent : AppColors.black),
      child: Container(
        height: AppStyles.cardBorderRadius,
        decoration: BoxDecoration(
          color: headerColor ?? (!negative ? AppColors.accent : AppColors.black),
          borderRadius: fromTop ? AppStyles.borderBottom : AppStyles.borderHeader,
        ),
      ),
    );
  }
}


class SliverDelim extends StatelessWidget {
  final bool fromTop;
  final bool negative;
  final Color? bodyColor;
  final Color? headerColor;

  const SliverDelim({Key? key, this.fromTop = true, this.negative = true, this.bodyColor, this.headerColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Delim(fromTop: fromTop, negative: negative, bodyColor: bodyColor, headerColor: headerColor,),
    );
  }
}

class ListTileDiv extends StatelessWidget {
  const ListTileDiv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: ZeroWidget()),
        Expanded(flex: 5, child: Container(
          height: 0.1, color: const Color(0xffeeeeee),
        )),
      ],
    );
  }
}

Widget getTitle(String title, {String? subTitle, String? heroTag}) {
  var child = Text(title.T());
  return Column(
  children: [
    heroTag  == null ? child : Hero(tag: heroTag, child: child),
    if(subTitle != null) Text(subTitle.T(), style: AppStyles.greyText12,),
  ],
);
}

AppBar getAppBar(String title, {String? subtitle, String? heroTag}) => AppBar(
  backgroundColor: AppColors.black,
  elevation: 0,
  leading: const BackButton(),
  title: getTitle(title, subTitle: subtitle, heroTag: heroTag
  ),
);

class WalletLogo extends StatelessWidget {
  final double? width;
  const WalletLogo({Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/images/logo.svg",
      width: width ?? Get.height/3,);
  }
}

class FlexWalletLogo extends StatelessWidget {
  final bool keyboardOpen;
  const FlexWalletLogo({Key? key, this.keyboardOpen = false}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double w = Get.height / (keyboardOpen ? 7 : 3);
    return AnimatedContainer(
      duration: 0.3.seconds,
      height: w,
        width: w,
        child: const WalletLogo());
  }
}


Future<bool?> askQuestion(String question, {String title = "Question"}) async {
  await EasyLoading.dismiss(animation: true);
  return showCupertinoDialog<bool>(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          AlertDialog(
            title: Text(title.T()),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(question.T()),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Yes'.T(),
                  style: const TextStyle(
                      color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Get.back(result: true);
                },
              ),
              TextButton(
                child: Text('No'.T(), style: AppStyles.darkText,),
                onPressed: () {
                  Get.back(result: false);
                },
              ),
            ],
          ));
}

class ButtonProgress extends StatelessWidget {
  final bool dark;
  const ButtonProgress({Key? key, this.dark = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25, height: 25,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(dark ? Colors.white : Colors.black),
        strokeWidth: 2,
      ),
    );
  }
}


class PadV extends StatelessWidget {
  final double padding;
  final Widget? child;
  const PadV({Key? key, this.child, this.padding = 4}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: child ?? const ZeroWidget(),
    );
  }
}


class GrayBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? color;
  const GrayBox({Key? key, this.width, this.height, this.borderRadius, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200,
      height: height ?? 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        color: (color ?? AppColors.grey2).withAlpha(70),
      ),
    );
  }
}



class TextIcon extends StatelessWidget {
  final String text;
  final Color? foregroundColor;
  final Color? color;
  final double size;
  const TextIcon(this.text, {Key? key,
    this.foregroundColor,
    this.color,
    this.size = 16,
  }) : super(key: key);

  String get letter => text.isEmpty ? "-" : text[0];

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text(letter, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),),
      radius: size,
      backgroundColor: color ?? stringToHslColor(text),
      foregroundColor: foregroundColor ?? AppColors.white,
    );
  }
}
class RoundIcon extends StatelessWidget {
  final IconData icon;
  final Color? foregroundColor;
  final Color? color;
  final double size;
  const RoundIcon(this.icon, {Key? key,
    this.foregroundColor,
    this.color,
    this.size = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Icon(icon, size: size*1.25,),
      radius: size,
      backgroundColor: color ?? AppColors.accent,
      foregroundColor: foregroundColor ?? AppColors.white,
    );
  }
}



