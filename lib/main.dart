import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/pages/amongview.dart";
import "package:lighthouse/pages/amongview_individual.dart";
import "package:lighthouse/pages/data_entry.dart";
import "package:lighthouse/pages/home_data_viewer.dart";
import "package:lighthouse/pages/home_scouter.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/saved_data.dart";
import "package:lighthouse/pages/settings.dart";
import "package:lighthouse/pages/sync.dart";
import "package:lighthouse/pages/tony_data_viewer.dart";

/// The main method also known as the entry point into the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initConfig();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Constants.pastelYellow,
    systemNavigationBarIconBrightness: Brightness.light
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_){
    runApp(MainWidget());
  });
}

/// The first widget shown when the app is first opened.
class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {

    
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: comfortaaBold(18,color: Colors.black),
          bodyMedium: comfortaaBold(14,color: Colors.black),
          bodySmall: comfortaaBold(10,color:Colors.black)
        )
      ),
      title: "LightHouse",
      home: ScouterHomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        "/home-scouter": (context) => ScouterHomePage(),
        "/entry": (context) => DataEntry(),
        "/settings": (context) => SettingsPage(),
        "/saved_data": (context) => SavedData(),
        "/home-data-viewer": (context) => DataViewerHome(),
        "/sync": (context) => SyncPage(),
        "/data-viewer-tony" : (context) => TonyDataViewerPage(),
        "/data-viewer-amongview": (context) => DataViewerAmongView(),
        "/amongview-individual": (context) => AmongViewIndividual()
      },
    );
  }
}

