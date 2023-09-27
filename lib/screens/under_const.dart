import 'package:flutter/material.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/widgets/no_content.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class UnderConstruction extends StatelessWidget {
  final String title;
  const UnderConstruction({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: getAppBar(title),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            underConstruction,
          ],
        ),
      ),
    );
  }
}
