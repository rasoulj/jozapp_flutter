import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';


class NoContent extends StatelessWidget {
  const NoContent({
    Key? key,
    this.title = "wallet",
    this.imagePath,
    this.subtitle = "sub-title"
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String? imagePath;
  bool get hasLogo => imagePath == null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Column(
        children: <Widget>[
          if(imagePath != null) Image.asset(
            "assets/images/nodata/$imagePath.png",
            width: 2*Get.width/3,
          ),
          if(hasLogo) const WalletLogo(),
          // const Icon(Icons.cloud_off, size: 120, color: AppColors.white,),
          PadV(
            padding: 16,
            child: Text(
              title.T(),
              style: AppStyles.whiteText32,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subtitle,
              style: AppStyles.greyText12,
            ),
          ),
        ],
      ),
    );
  }
}

Widget underConstruction = const NoContent(
  imagePath: "under_construction",
  title: "Not Implemented",
  subtitle: "Under Construction!!",);
