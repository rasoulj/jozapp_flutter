import 'package:flutter/material.dart';
import 'package:jozapp_flutter/screens/services/services_view.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';



class ServicesScreen extends StatelessWidget {
  final VoidCallback? gotoHome;

  const ServicesScreen({Key? key, this.gotoHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: getTitle('main.services', subTitle: 'main.services.choice.service'),
        elevation: 0,
        backgroundColor: AppColors.black,
        leading: IconButton(
          onPressed: gotoHome,
          icon: const BackButtonIcon(),
        ),
      ),
      body: const ServicesView(),
    );
  }
}