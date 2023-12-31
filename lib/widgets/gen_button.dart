import 'package:flutter/material.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class GenButton extends StatelessWidget {
  const GenButton({
    Key? key,
    this.title,
    this.icon,
    this.onPressed,
    this.color = AppColors.black3,
    this.loading,
    // this.dark = true,
    this.child,
    this.rightIcon = false,
  }) : super(key: key);
  final String? title;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;
  final bool? loading;
  // final bool dark;
  final Widget? child;
  final bool rightIcon;

  // EdgeInsetsGeometry get _iconPadding =>  EdgeInsets.only(right: rightIcon ? 0 : 8.0, left: !rightIcon ? 0 : 8.0);
  EdgeInsetsGeometry get _iconPadding =>  EdgeInsets.zero;//(right: rightIcon ? 0 : 8.0, left: !rightIcon ? 0 : 8.0);

  bool get dark => AppColors.isDark(color);

  Widget? get _icon {
    return (loading ?? false) ? Padding(
      padding: _iconPadding,
      child: ButtonProgress(dark: dark,),
    )
        : (icon == null ? null : Padding(
      padding: _iconPadding,
      child: Icon(icon, color: !dark ? AppColors.black : AppColors.white,),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var width = double.infinity;
    var style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      primary:  color,
      minimumSize: Size(width, 50), // fromHeight use double.infinity as width and 40 is the height
    );

    var label = child ?? Text(title?.T() ?? "NA", style: dark ? AppStyles.whiteText16 : AppStyles.darkText16,);

    List<Widget> ch = [
      _icon ?? const ZeroWidget(),
      label,
      const ZeroWidget(),
    ];

    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rightIcon ^ isRTL() ? ch.reversed.toList() : ch,
        ),
      ),
    );
  }
}
