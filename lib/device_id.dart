import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lighthouse/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class DeviceIDDialog extends StatefulWidget {
  const DeviceIDDialog({super.key});

  @override
  State<DeviceIDDialog> createState() => _DeviceIDDialogState();
}

class _DeviceIDDialogState extends State<DeviceIDDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 350,
      height: 500,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          color: Constants.pastelWhite),
      child: Material(
        child: FutureBuilder(
            future: getPersistentDeviceID(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Row(
                  children: [
                    CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Constants.pastelBlue),
                    ),
                    Text(
                      "Loading Device ID",
                      style: comfortaaBold(18),
                    )
                  ],
                );
              }
              return Column(
                children: [
                  Text(
                    "Your unique device ID is:",
                    style: comfortaaBold(18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    snapshot.data ?? "NO DEVICE ID",
                    style: comfortaaBold(18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  QrImageView(data: snapshot.data!,
                  size: 325.0,)
                ],
              );
            }),
      ),
    ));
  }

  Future<String> getPersistentDeviceID() async {
    const storage = FlutterSecureStorage();
    const key = 'NRGLighthouseID';

    // Primary storage method: uses android keystore/iOS keychain to store device ID
    // This is persistent across installs on iOS, but resets upon uninstall on Android
    String? deviceID = await storage.read(key: key);

    if (deviceID == null) {
      deviceID = const Uuid().v4();
      await storage.write(key: key, value: deviceID);
    }

    return deviceID;
  }
}
