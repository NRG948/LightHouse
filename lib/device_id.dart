import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
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
              if (snapshot.data == null) {
                return Center(child: Text("Something went wrong. Device ID is null."),);
              }
              return Column(
                children: [
                  Text(
                    "DEVICE ID:",
                    style: comfortaaBold(23, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    snapshot.data ?? "NO DEVICE ID",
                    style: comfortaaBold(18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  QrImageView(
                    data: snapshot.data!,
                    size: 225,
                  ),
                  SizedBox(height: 50,),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(context: context, builder: (context) {
                        return Container(
                          height: 50,
                          width: 325,
                          decoration: BoxDecoration(
                            color: Constants.pastelGrayDark
                          ),
                          child: Center(child: Text("Copied to Clipboard!",style: comfortaaBold(18),textAlign: TextAlign.center,)),
                        );
                      });
                      Clipboard.setData(ClipboardData(text: snapshot.data!));},
                    child: Container(
                      height: 50,
                      width: 325,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Constants.borderRadius),
                        color: Constants.pastelBlue
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Icon(Icons.copy,color: Colors.white,),
                        Text("COPY",style: comfortaaBold(25),)
                      ],),
                    ),
                  ),
                  SizedBox(height: 10,),
                   GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 50,
                      width: 325,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Constants.borderRadius),
                        color: Constants.pastelRedDark
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Icon(Icons.close,color: Colors.white,),
                        Text("CLOSE",style: comfortaaBold(25),)
                      ],),
                    ),
                  )
                ],
              );
            }),
                ),
              ),
      ),
    );
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
