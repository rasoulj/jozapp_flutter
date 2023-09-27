import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jozapp_flutter/models/wid.dart';
import 'package:jozapp_flutter/utils/etc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({Key? key}) : super(key: key);

  @override
  _ScanQRCodeState createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan"),
      ),
      body: Column(
        children: <Widget>[
          // Expanded(
          //   flex: 1,
          //   child: Row(
          //     children: [
          //       const BackButton(),
          //       Center(
          //         child: (result != null)
          //             ? Text(
          //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //             : const Text('Scan a code'),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if(result != null) return;
      setState(() {
        result = scanData;
      });
      Wid? wid = Wid.fromBarCode(result?.code);
      if(wid == null) {
        showInfo("Invalid Customer code scanned");
        setState(() {
          result = null;
        });
        return;
      }

      Get.back<Wid>(result: wid);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
