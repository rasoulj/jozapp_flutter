
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/config/app_config.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/wid.dart';
import 'package:jozapp_flutter/models/types.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:jozapp_flutter/widgets/scan_qr_code.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

class AmountWidget extends StatelessWidget {
  final bool enabled;
  final String? suffixText;
  final String labelText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  const AmountWidget({Key? key, this.controller, this.enabled = true, this.suffixText, this.labelText = "amount", this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 6),
      child: TextField(
          controller: controller,
          onSubmitted: (stt) {
            hideKeyboard();
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: AppStyles.whiteText,
          enabled: enabled,
          onChanged: onChanged,
          decoration: InputDecoration(
              enabledBorder: AppStyles.inputBorderW,
              filled: !enabled,
              fillColor: AppColors.black.withAlpha(30),
              //label: Text("Amount".T(), style: AppStyles.whiteText,),
              hintStyle: AppStyles.greyText,
              border: AppStyles.inputBorderW2,
              disabledBorder: AppStyles.inputBorderW2,
              focusedBorder: AppStyles.inputBorderW2,
              labelText: labelText.T(),
              hintText: labelText.T(),
              labelStyle: AppStyles.whiteText,
            suffixText: suffixText,
          )
      ),
    );

  }
}

class WidWidget extends StatelessWidget {
  final TextEditingController? controller;
  final bool enabled;
  const WidWidget({Key? key, this.controller, this.enabled = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: TextField(
          controller: controller,
          onSubmitted: (stt) {
            hideKeyboard();
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: AppStyles.whiteText,
          enabled: enabled,
          decoration: InputDecoration(
              enabledBorder: AppStyles.inputBorderW,
              suffixIcon: IconButton(color: AppColors.white, onPressed: () async {
                Wid? wid = await Get.to<Wid>(() => const ScanQRCode());
                if(wid == null) return;
                controller?.text = wid.formal;
                hideKeyboard();
                // log(wid.formal);
              }, icon: const Icon(Icons.qr_code_2_rounded, ),),
              filled: !enabled,
              fillColor: AppColors.black.withAlpha(30),
              //label: Text("Amount".T(), style: AppStyles.whiteText,),
              hintStyle: AppStyles.greyText,
              border: AppStyles.inputBorderW2,
              disabledBorder: AppStyles.inputBorderW2,
              focusedBorder: AppStyles.inputBorderW2,
              labelText: "profile.wallet_number".T(),
              hintText: "xxxx-xxxx-xxxx-xxxx".T(),
              labelStyle: AppStyles.whiteText
          )
      ),
    );

  }
}


const Map<String, List<String>> _btnLabeles = {
  "back": ["Back", "Cancel"],
  "next": ["Next", "Confirm"],
};

class ButtonsWidget extends StatefulWidget {
  final int stage;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  const ButtonsWidget({Key? key, this.stage = 0, this.onBack, this.onNext}) : super(key: key);

  @override
  State<ButtonsWidget> createState() => _ButtonsWidgetState();
}

class _ButtonsWidgetState extends State<ButtonsWidget> {
  double get cardHeight {
    switch(widget.stage) {
      case 0: return 0;
      default: return 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);
    return Column(
      children: [
        AnimatedContainer(
          height: cardHeight,
          duration: 300.milliseconds,
          child: Container(
              alignment: Alignment.center,
              child: Text("q.do_that".T(), style: AppStyles.whiteText18,)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
          child: Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: OutlinedButton.icon(

                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.white),
                    primary: AppColors.white,
                  ),
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.clear),
                  label: Text(_btnLabeles["back"]?[widget.stage].T() ?? "Back"),
                ),
              ),),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      onPrimary: AppColors.black,
                      primary: AppColors.white),
                  onPressed: widget.onNext,
                  icon: model.loading ? const ButtonProgress() : const Icon(Icons.check),
                  label: Text(_btnLabeles["next"]?[widget.stage].T() ?? "Next"),),
              )),
            ],
          ),
        ),
      ],
    );

  }
}


class Row3 extends StatelessWidget {
  final Widget? child1, child2, child3;

  const Row3({Key? key, this.child1, this.child2, this.child3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (child1 != null) child1!,
            if (child2 != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: child2!,
              ),
          ],
        ),
        if (child3 != null) child3!,
      ],
    );
  }
}

class SelectCur2 extends StatelessWidget {
  final ValueChanged<CurTypes?>? onChanged;
  final CurTypes? selected;
  final CurTypes? exclude;

  const SelectCur2({Key? key, this.selected, this.onChanged, this.exclude})
      : super(key: key);

  String get title => "txt.dest_cur".T(sel ? ": ${selected?.shortName}" : "");

  bool get sel => selected != null;

  void _onSelect(CurTypes? cur) {
    if (onChanged != null) onChanged!(cur);
  }

  @override
  Widget build(BuildContext context) {
    var clr = sel ? AppColors.white : AppColors.accent;

    var style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      primary: clr,
    );

    bool dark = AppColors.isDark(clr);
    var onColor = dark ? AppColors.white : AppColors.black;

    return ElevatedButton(
      style: style,
      onPressed: () async {
        CurTypes? cur = await showCupertinoModalPopup<CurTypes>(
          builder: (context) => CupertinoActionSheet(
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
                _onSelect(null);
              },
              child: const Row3(
                child2: Text("Cancel"),
              ),
            ),
            actions: AppConfig.activeCurrencies
                .map((e) => CupertinoActionSheetAction(
              onPressed: () {
                if(e == exclude) return;
                Get.back<CurTypes>(result: e);
              },
              child: Row3(
                child1: e.icon(24),
                child2: Text(e.longName, style: e == exclude ? const TextStyle(color: AppColors.grey2) : null,),
                child3: selected?.index == e.index
                    ? const Icon(Icons.check)
                    : const ZeroWidget(),
              ),
            ))
                .toList(),
          ),
          context: context,
        );
        _onSelect(cur);
      },
      child: SizedBox(
          height: 60,
          width: double.infinity,
          child: Row3(
            child1: !sel
                ? const Icon(
              Icons.circle,
              size: 40,
            )
                : selected!.icon(40),
            child2: Text(
              title,
              style: TextStyle(color: onColor),
            ),
            child3: Icon(
              Icons.arrow_drop_down_circle_rounded,
              color: onColor,
            ),
          )),
    );
  }
}



