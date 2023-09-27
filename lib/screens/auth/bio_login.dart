
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jozapp_flutter/api/rest_api.dart';
import 'package:jozapp_flutter/db/sembast_db.dart';
import 'package:jozapp_flutter/models/app_settings.dart';
import 'package:jozapp_flutter/providers/app_provider.dart';
import 'package:jozapp_flutter/themes/app_colors.dart';
import 'package:jozapp_flutter/widgets/tiny_widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

const bool _debug = false;

class BioLogin extends StatefulWidget {
  final AppSettings? settings;
  final SembastDb? db;
  const BioLogin({Key? key, this.db, required this.settings}) : super(key: key);

  @override
  State<BioLogin> createState() => _BioLoginState();
}

const Map<BiometricType, IconData> _bioIcons = {
  BiometricType.face: Icons.face,
  BiometricType.fingerprint: Icons.fingerprint,
  BiometricType.weak: Icons.fingerprint,
  BiometricType.strong: Icons.face,
  BiometricType.iris: Icons.wb_iridescent_sharp,
};

class _BioLoginState extends State<BioLogin> {
  final LocalAuthentication _auth = LocalAuthentication();

  void _doLogin() async {
    try {
      bool isAuth = _debug ? true : (await _auth.authenticate(localizedReason: "Login to BahBahan"));
      log("login: $isAuth ${widget.settings?.phoneNumber} - ${widget.settings?.password}");
      if(isAuth) {
        await RestApi.login(
          widget.settings?.phoneNumber ?? "",
          widget.settings?.password ?? "",
        );
      }
    } catch(e) {
      log(e.toString());
    }
  }

  bool get logged {
    var ph = widget.settings?.phoneNumber;
    var pass = widget.settings?.password;
    return (ph != null && pass != null);
  }

  @override
  Widget build(BuildContext context) {
    if(!logged) return const ZeroWidget();
    var model = Provider.of<AppDataModel>(context, listen: true);
    return FutureBuilder<List<BiometricType>>(
        future: _auth.getAvailableBiometrics(),
        builder: (context, snapshot) {
          List<BiometricType> list = snapshot.hasData ? snapshot.data ?? [] : [];

          if(_debug) list = [BiometricType.fingerprint];

          log(list.toString());

          return list.isEmpty ? const ZeroWidget() : Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: model.loading ? [
                const SizedBox(
                    width: 50, height: 50,
                    child: CircularProgressIndicator(color: AppColors.white,))
              ] : list.map((e) => IconButton(
                onPressed: _doLogin,
                icon: Icon(_bioIcons[e] ?? Icons.warning, color: AppColors.white, size: 50,),
              )
              ).toList(),
            ),
          );
        }
    );
  }
}
