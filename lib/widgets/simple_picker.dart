import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/screens/services/services_widgets.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class SimplePicker<T> extends StatelessWidget {
  final String? title;
  final List<T> items;
  final T? value;
  final ValueChanged<T>? onChanged;
  final Widget child;
  final Widget? Function(T value)? iconBuilder;

  const SimplePicker({
    Key? key,
    this.items = const [],
    this.value,
    this.onChanged,
    this.child = const ZeroWidget(),
    this.title,
    this.iconBuilder,
  }) : super(key: key);

  Widget? _getIcon(T value) => iconBuilder == null ? null : iconBuilder!(value);

  CupertinoActionSheet get actionSheet => CupertinoActionSheet(
    message: title != null
        ? Text(
      title!.T(),
      style: const TextStyle(fontSize: 20),
    )
        : null,
    actions: items
        .map(
          (e) => CupertinoActionSheetAction(
        onPressed: () {
          // if (onChanged != null) onChanged!(e);
          Get.back(result: e);
        },
        child: Row3(
          child1: _getIcon(e),
          child2: Text(
            e.toString(),
            style: AppStyles.darkText,
          ),
          child3: value == e
              ? const Icon(
            Icons.check,
            color: AppColors.accent,
          )
              : null,
        ),
      ),
    )
        .toList(),
    cancelButton: CupertinoActionSheetAction(
        onPressed: () => Get.back(result: null),
        child: Text("cancel".T())),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        T? value = await showCupertinoModalPopup(
            context: Get.context!, builder: (_) => actionSheet);

        if (onChanged != null && value != null) onChanged!(value);
      },
      child: child,
    );
  }
}
