import 'package:flutter/material.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';

import 'tiny_widgets.dart';

class BaseSliverScreen extends StatelessWidget {
  final bool fromTop;
  final bool negative;
  // final Color? bgBody;
  // final Color? bgHeader;
  final Widget? body;
  final String? title;
  final Widget? back;
  final Widget? headerSection;

  const BaseSliverScreen({
    Key? key,
    this.fromTop = false,
    this.negative = false,
    // this.bgBody,
    // this.bgHeader,
    this.body, this.title, this.back,
    this.headerSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.black,
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              leading: const BackButtonIcon(),
              backgroundColor: negative ? AppColors.black : AppColors.accent,
              // pinned: true,
              // snap: true,
              // floating: false,
              expandedHeight: 160.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(title.T()),
                background: headerSection,
                // background: FlutterLogo(),
              ),
            ),

            SliverDelim(fromTop: fromTop, negative: true,),
            if(body != null) body ?? const ZeroWidget(),
          ],
        ),
      ),
    );
  }
}
