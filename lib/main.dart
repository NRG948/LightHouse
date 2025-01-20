import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/pages/data_entry.dart";
import "package:lighthouse/pages/home.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/saved_data.dart";
import "package:lighthouse/pages/settings.dart";

/// The main method also known as the entry point into the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initConfig();
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
        
      ),
      title: "LightHouse",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        "/home": (context) => HomePage(),
        "/entry": (context) => DataEntry(),
        "/settings": (context) => SettingsPage(),
        "/saved_data": (context) => SavedData()
      },
    );
  }
}

