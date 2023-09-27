
import 'package:flutter/material.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class InputEx extends StatefulWidget {
  final AppController? controller;
  final String? field;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool isPassword;

  const InputEx({
    Key? key,
    @required this.controller,
    @required this.field,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  })
      : super(key: key);

  @override
  State<InputEx> createState() => _InputExState();
}

class _InputExState extends State<InputEx> {
  void _onChange(String value) {
    if (widget.field == null) return;
    widget.controller?.setValue(widget.field ?? "NA", value);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppStyles.whiteText,
        obscureText: widget.isPassword,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        onChanged: _onChange,
        decoration: InputDecoration(
          hintStyle: AppStyles.greyText,
          isDense: true,
          filled: true,
          fillColor: AppColors.black2,
          // isCollapsed: true,
          suffixIconColor: AppColors.accent,
          border: AppStyles.inputBorder,
          focusedBorder: AppStyles.inputBorder,
          hintText: widget.hintText?.T(),
        ));
  }
}
