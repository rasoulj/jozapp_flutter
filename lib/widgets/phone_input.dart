import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class PhoneInput extends StatefulWidget {
  final AppController? controller;
  final String? field;

  const PhoneInput({Key? key, @required this.controller, this.field})
      : super(key: key);

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

String _norm(String phone) =>
    phone.startsWith("0") ? phone.substring(1) : phone;

class _PhoneInputState extends State<PhoneInput> {
  String _prefix = AppConfig.defPhoneCode;

  String get prefix => _prefix;

  set prefix(String value) => setState(() => _prefix = value);

  String _phone = "";

  String get phone => _phone;

  set phone(String value) => setState(() => _phone = value);

  String get value => prefix + _norm(phone);

  void _onChange() {
    if (widget.field == null) return;
    widget.controller?.setValue(widget.field ?? "NA", value);
  }

  Widget _buildPrefix() => GestureDetector(
    onTap: () {
      showCountryPicker(
        context: context,
        showPhoneCode: true,
        // optional. Shows phone code before the country name.
        onSelect: (Country country) {
          prefix = country.phoneCode;
          _onChange();
        },
      );
    },
    child: Container(
      decoration: const BoxDecoration(
          color: Color(0xff181818),
          borderRadius: BorderRadius.only(
              topLeft: AppStyles.corner,
              bottomLeft: AppStyles.corner),
      ),
      height: 48,
      width: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "+$prefix",
            style: AppStyles.whiteText,
          ),
          const Icon(
            Icons.arrow_drop_down_rounded,
            color: AppColors.white,
          )
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          Expanded(flex: 2, child: _buildPrefix()),
          Expanded(flex: 5, child:TextField(
              keyboardType: TextInputType.phone,
              onChanged: (String value) {
                phone = value;
                _onChange();
              },
              style: AppStyles.whiteText,
              decoration: InputDecoration(
                hintStyle: AppStyles.greyText,
                filled: true,
                fillColor: AppColors.black2,
                // hoverColor: Colors.brown[200],
                // isCollapsed: true,
                isDense: true,

                border: AppStyles.inputBorderZero,
                focusedBorder: AppStyles.inputBorderZero,
                hintText: "auth.phone_number".T(),
              )),
          )],
      ),
    );
  }
}
