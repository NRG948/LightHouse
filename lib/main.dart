import "package:flutter/material.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/pages/data_entry_paged.dart";
import "package:lighthouse/pages/home.dart";
import "package:lighthouse/pages/data_entry.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/pages/settings.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initConfig();
  runApp(MainWidget());
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {

    
    return MaterialApp(
      theme: ThemeData(
        
      ),
      title: "LightHouse Prototype",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        "/home": (context) => HomePage(),
        "/entry": (context) => DataEntryPaged(),
        "/settings": (context) => SettingsPage()
      },
    );
  }
}

