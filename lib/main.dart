import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/pages/rebuilt/aryav_data_viewer.dart";
import "package:lighthouse/pages/game_agnostic/home_data_viewer.dart";
import "package:lighthouse/pages/game_agnostic/home_scouter.dart";
import "package:lighthouse/pages/game_agnostic/saved_data.dart";
import "package:lighthouse/pages/game_agnostic/settings.dart";
import "package:lighthouse/pages/game_agnostic/sync.dart";
import "package:lighthouse/pages/game_agnostic/testing_ground.dart";
import "package:lighthouse/pages/rebuilt/atlas.dart";
import "package:lighthouse/pages/rebuilt/pit_scout.dart";
import "package:lighthouse/themes.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initConfig();
  await loadConfig();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MainWidget());
  });
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: ThemeController.currentTheme,
      builder: (context, value, child) {
        return MaterialApp(
          theme: ThemeData(
            extensions: <ThemeExtension<dynamic>>[
              LightHouseThemes.themes[value] ??
                  LightHouseThemes.themes.values.first,
            ],
            textTheme: TextTheme(
              bodyLarge: comfortaaBold(18, color: Colors.black),
              bodyMedium: comfortaaBold(14, color: Colors.black),
              bodySmall: comfortaaBold(10, color: Colors.black),
            ),
          ),
          title: "LightHouse",
          home: ScouterHomePage(),
          debugShowCheckedModeBanner: false,
          routes: {
            // TODO: figure out how to transition to page-based data entry layouts
            "/home-scouter": (context) => ScouterHomePage(),
            "/atlas": (context) => Atlas(),
            "/pit": (context) => PitScout(),
            "/settings": (context) => SettingsPage(),
            "/saved_data": (context) => SavedData(),
            "/home-data-viewer": (context) => DataViewerHome(),
            "/sync": (context) => SyncPage(),
            "/testing-ground": (context) => TestingGroundPage(),
            "/data-viewer-aryav": (context) => AryavDataViewer(),
            // TODO: add these again:
            // "/data-viewer-amongview": (context) => DataViewerAmongView(),
            // "/amongview-individual": (context) => AmongViewIndividual()
          },
        );
      },
    );
  }
}
