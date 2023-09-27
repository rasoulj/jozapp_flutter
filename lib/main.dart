

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/aticket/providers/ticket_model.dart';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/screens/auth/main_page.dart';
import 'package:jozapp_flutter/screens/home/app_home.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:provider/provider.dart';

import 'intl/localizations.dart';
import 'screens/auth/log_reg_page.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() {
  HttpOverrides.global = MyHttpOverrides();

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = AppColors.accent.withOpacity(0.5)
    ..userInteractions = false
    ..errorWidget = const Icon(Icons.error, color: AppColors.accent, size: 32,)
    ..dismissOnTap = false;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppController? c;

  @override
  void initState() {
    c = AppController(this);
    super.initState();
  }

  void _setLang(AppSettings settings) {
    String? currentLang = Get.locale?.languageCode;
    if(currentLang == null || currentLang != settings.lang) {
      Get.locale = Locale(settings.lang);
    }
  }

  Widget _buildApp(SembastDb? db, AppSettings settings) {
    _setLang(settings);

    // bool logged = c?.getValue("logged") ?? false;


    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppDataModel>(create: (context) => AppDataModel(),),
        ChangeNotifierProvider<TicketModel>(create: (context) => TicketModel(),),
      ],
      child: GetMaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (BuildContext context) => "title".T(),
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalization.locales(),
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: "iransans"
        ),
        home: LoggedApp(settings: settings, db: db,),
      ),
    );
  }

  Widget _buildWithDb(SembastDb? db) {
    if (db == null) {
      return const ZeroWidget();
    } else {
      return StreamBuilder<AppSettings>(
          stream: AppSettings.getStream(db),
          builder: (context, snapshot) {
            AppSettings settings = snapshot.data ?? const AppSettings();

            return _buildApp(db, settings);
          });
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SembastDb>(
        future: SembastDb.init(),
        builder: (context, snapshot) {
          SembastDb? db =
              snapshot.hasError || !snapshot.hasData ? null : snapshot.data;
          return _buildWithDb(db);
        });
  }
}

class LoggedApp extends StatelessWidget {
  final AppSettings? settings;
  final SembastDb? db;

  const LoggedApp({Key? key, required this.settings, this.db}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppDataModel>(context, listen: true);
    var logged = model.logged;

    return logged ? AppHome(db: db, settings: settings,) : MainPage(
      changeLang: true,
      settings: settings,
      child: LogReg(settings: settings, db: db,),
    );
  }
}


