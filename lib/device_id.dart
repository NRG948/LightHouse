import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class DeviceAuthSetupDialog extends StatefulWidget {
  const DeviceAuthSetupDialog({super.key});

  @override
  State<DeviceAuthSetupDialog> createState() => _DeviceAuthSetupDialogState();
}

class _DeviceAuthSetupDialogState extends State<DeviceAuthSetupDialog> {
  String key = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        child: Container(
          width: 350,
          height: 250,
          decoration: Constants.roundBorder(),
          child: Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "AUTHORIZE DEVICE",
                  style: comfortaaBold(25, color: Constants.black),
                ),
                Text(
                  "Authorizing to Server:",
                  style: comfortaaBold(16, color: Constants.black),
                ),
                AutoSizeText(
                  "${configData["serverIP"]}",
                  style: comfortaaBold(16, color: Constants.pastelBlue),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 14,
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    autocorrect: false,
                    style: comfortaaBold(18, color: Constants.black),
                    onChanged: (e) => key = e,
                    decoration: InputDecoration(
                        fillColor: Constants.pastelRed,
                        filled: true,
                        label: Text("Enter key")),
                  ),
                ),
                SizedBox(
                    width: 300,
                    child: AutoSizeText(
                      "Talk to the strat team to get a one-time key to allow your phone to upload to/download from the server.",
                      style: comfortaaBold(10, color: Colors.black),
                      textAlign: TextAlign.center,
                      minFontSize: 10,
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DeviceAuthUploadDialog(
                              oneTimeKey: key,
                            );
                          });
                    },
                    child: Container(
                      height: 30,
                      width: 300,
                      decoration:
                          Constants.roundBorder(color: Constants.pastelRed),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_lock,
                            color: Constants.pastelWhite,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Authorize",
                            style: comfortaaBold(18),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pop-up that appears when a device authorization request is made. It displays the status of the request.
class DeviceAuthUploadDialog extends StatefulWidget {
  final String oneTimeKey;
  const DeviceAuthUploadDialog({super.key, required this.oneTimeKey});

  @override
  State<DeviceAuthUploadDialog> createState() => _DeviceAuthUploadDialogState();
}

/// Steps in the device ID authentication process.
enum Step { retrieveID, uploadToServer, showReturnCode }

class _DeviceAuthUploadDialogState extends State<DeviceAuthUploadDialog> {
  Step? currentStep;
  String uuid = "";
  dynamic responseCode;

  @override
  void initState() {
    super.initState();
    uploadAuthorizeKey();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        child: Container(
          width: 350,
          height: 250,
          decoration: Constants.roundBorder(),
          child: Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "AUTHORIZE DEVICE",
                  style: comfortaaBold(25, color: Constants.black),
                ),
                if (currentStep == Step.retrieveID)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: Constants.pastelWhite,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Constants.pastelBlue),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Loading Device ID...")
                    ],
                  ),
                if (currentStep == Step.uploadToServer ||
                    currentStep == Step.showReturnCode)
                  Column(
                    children: [
                      Text("Device ID:"),
                      AutoSizeText(
                        uuid,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                if (currentStep == Step.uploadToServer)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: Constants.pastelWhite,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Constants.pastelBlue),
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Uploading to server...")
                    ],
                  ),
                if (currentStep == Step.showReturnCode)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Occurs if POST request completed
                      if (responseCode.runtimeType == int)
                        Container(
                            width: 300,
                            decoration: Constants.roundBorder(
                                color: responseCode == 200
                                    ? Constants.pastelGreen
                                    : Constants.pastelRed),
                            child: AutoSizeText(
                              "Recieved Code $responseCode - ${responseCodes[responseCode]}",
                              style: comfortaaBold(14,
                                  color: Constants.pastelWhite),
                              textAlign: TextAlign.center,
                            )),
                      // Occurs if POST statement encounters an error
                      if (responseCode.runtimeType == String)
                        Container(
                            width: 300,
                            decoration: Constants.roundBorder(
                                color: Constants.pastelRed),
                            child: AutoSizeText(
                              responseCode,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: comfortaaBold(14),
                            )),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: Constants.roundBorder(
                              color: Constants.pastelGray),
                          child: Center(
                              child: Text(
                            "OK",
                            style: comfortaaBold(30),
                            textAlign: TextAlign.center,
                          )),
                        ),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Uploads the authorization key to the server and sets the response code.
  void uploadAuthorizeKey() async {
    setState(() {
      currentStep = Step.retrieveID;
    });
    uuid = await getPersistentDeviceID();
    setState(() {
      currentStep = Step.uploadToServer;
    });
    try {
      http.Response response = await http.post(
          Uri.parse("${configData["serverIP"]}/secure/create"),
          headers: {"key": widget.oneTimeKey, "uuid": uuid});
      responseCode = response.statusCode;
    } catch (e) {
      responseCode = e.toString();
    }
    setState(() {
      currentStep = Step.showReturnCode;
    });
  }
}

// Opens a dialog which displays the phone's UUID, both in plain text and as a QR Code
// The UUID can also be copied to the clipboard from here
// This function is deprecated, replaced with the DeviceAuthSetupDialog and DeviceAuthUploadDialog system
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
                          backgroundColor: Constants.pastelWhite,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Constants.pastelBlue),
                        ),
                        Text(
                          "Loading Device ID",
                          style: comfortaaBold(18, color: Colors.black),
                        )
                      ],
                    );
                  }
                  if (snapshot.data == null) {
                    return Center(
                      child: Text("Something went wrong. Device ID is null."),
                    );
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
                      SizedBox(
                        height: 20,
                      ),
                      QrImageView(
                        data: snapshot.data!,
                        size: 225,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            "Copied to Clipboard!",
                            style: comfortaaBold(18),
                            textAlign: TextAlign.center,
                          )));
                          Clipboard.setData(
                              ClipboardData(text: snapshot.data!));
                        },
                        child: Container(
                          height: 50,
                          width: 325,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Constants.borderRadius),
                              color: Constants.pastelBlue),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.copy,
                                color: Constants.pastelWhite,
                              ),
                              Text(
                                "COPY",
                                style: comfortaaBold(25),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 50,
                          width: 325,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Constants.borderRadius),
                              color: Constants.pastelRedDark),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.close,
                                color: Constants.pastelWhite,
                              ),
                              Text(
                                "CLOSE",
                                style: comfortaaBold(25),
                              )
                            ],
                          ),
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
}

/// Gets the device ID from an android or iOS device. Creates a new device ID if it is null.
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

class AuthButton extends StatelessWidget {
  final bool background;
  const AuthButton({super.key, this.background = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return DeviceAuthSetupDialog();
            });
      },
      icon: Container(
        width: 30,
        height: 30,
        decoration: background
            ? Constants.roundBorder(color: Constants.pastelRedSuperDark)
            : null,
        child: Icon(
          Icons.lock_open,
          color: Constants.pastelWhite,
        ),
      ),
    );
  }
}
