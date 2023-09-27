
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/intl/localizations.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/screens/profile/index.dart';
import 'package:jozapp_flutter/screens/services/index.dart';
import 'package:jozapp_flutter/screens/transactions/index.dart';
import 'package:jozapp_flutter/screens/wallet/index.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/themes/text_styles.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';

class AppHome extends StatefulWidget {
  final AppSettings? settings;
  final SembastDb? db;

  const AppHome({Key? key, this.db, required this.settings}) : super(key: key);

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _TabModel {
  final String title;
  final IconData icon;
  final int index;

  const _TabModel(this.title, this.icon, this.index);

  GButton get button => GButton(text: title.T(), icon: icon, padding: const EdgeInsets.all(12),);

  static const List<_TabModel> all = [
    _TabModel("main.wallet", Icons.account_balance_wallet, 0),
    _TabModel("main.services", Icons.apps, 1),
    _TabModel("main.trans", Icons.attach_money, 2),
    _TabModel("main.profile", Icons.person, 3),
  ];
}

const allBg = [
  AppColors.black,
  AppColors.black,
  AppColors.black,
  AppColors.black,
];

class _AppHomeState extends State<AppHome> {
  AppController? _c;// = _Controller(setState);

  @override
  void initState() {
    _c = AppController(this);
    super.initState();
  }

  int get selectedIndex => _c?.getValue("selectedIndex") ?? 0;
  set selectedIndex(int value) => _c?.setValue("selectedIndex", value);

  void gotoHome() {
    selectedIndex = 0;
  }

  List<Widget> get _widgetOptions => [
    const WalletScreen(),
    ServicesScreen(gotoHome: gotoHome,),
    // const BaseScreen(negative: true, fromTop: false,),
    TransactionsScreen(gotoHome: gotoHome,),
    ProfileScreen(gotoHome: gotoHome, db: widget.db, settings: widget.settings,),
  ];

  @override
  Widget build(BuildContext context) {
    int index = selectedIndex;

    Color bg = allBg[index];

    return Scaffold(
      backgroundColor: bg,
      // appBar: AppBar(
      //   elevation: 20,
      //   title: const Text('GoogleNavBar'),
      // ),
      body: Container(
        color: bg,
        child: Center(
          child: _widgetOptions.elementAt(index),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey[700] ?? Colors.grey, width: 3),
          borderRadius: AppStyles.borderBottom,
          gradient: LinearGradient(
              colors: [
                    Colors.grey[700] ?? Colors.white,
                Colors.grey[800] ?? Colors.white,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp),
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     Colors.grey[800] ?? Colors.white,
          //     Colors.grey[600] ?? Colors.white,
          //   ],
          // ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 12),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: 400.milliseconds,
              tabBackgroundColor: AppColors.accent,
              color: Colors.white,
              tabs: _TabModel.all.map((e) => e.button).toList(),
              selectedIndex: index,
              onTabChange: (index) => selectedIndex = index,
            ),
          ),
        ),
      ),
    );
  }
}

