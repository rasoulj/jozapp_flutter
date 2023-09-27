import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/widgets/base_screen.dart';
import 'package:jozapp_flutter/widgets/no_content.dart';

class UserSettings extends StatelessWidget {
  final AppSettings? settings;
  const UserSettings({Key? key, required this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onBack: Get.back,
      title: "profile.user_settings",
      body: underConstruction,
    );
  }
}
