import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/data_entry_page.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/checkbox.dart';
import 'package:lighthouse/widgets/game_agnostic/comment_box.dart';
import 'package:lighthouse/widgets/game_agnostic/default_container.dart';
import 'package:lighthouse/widgets/game_agnostic/match_info.dart';
import 'package:lighthouse/widgets/game_agnostic/match_prediction.dart';
import 'package:lighthouse/widgets/game_agnostic/rating.dart';
import 'package:lighthouse/widgets/game_agnostic/textbox.dart';
import 'package:lighthouse/widgets/rebuilt/metric.dart';
import 'package:lighthouse/widgets/rebuilt/rebuilt_auto_path_selector.dart';
import 'package:lighthouse/widgets/rebuilt/rebuilt_endgame_tag_selector.dart';
import 'package:lighthouse/widgets/rebuilt/rebuilt_location_tracker.dart';
import 'package:lighthouse/widgets/rebuilt/tower_location_selector.dart';

class Atlas extends StatefulWidget {
  const Atlas({super.key});

  @override
  State<Atlas> createState() => AtlasState();
}

class AtlasState extends State<Atlas> {
  double margin = 10;
  String? driverStation;
  bool get flipField =>
      (driverStation?.startsWith("B") ?? false) ^
      (configData["flipField"] == "true");

  @override
  void initState() {
    super.initState();
    if (configData["autofillLastMatch"] == "true") {
      driverStation = configData["currentDriverStation"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataEntryPage(name: "Atlas", pages: {
      "Setup": DataEntrySubPage(
          icon: CustomIcons.wrench,
          content: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                spacing: margin,
                children: [
                  Container(
                    height: 70,
                    padding: EdgeInsets.all(margin),
                    decoration: BoxDecoration(
                      color: context.colors.container,
                      borderRadius: BorderRadius.circular(margin),
                    ),
                    child: InputTextBox(
                      maxLines: 1,
                      hintText: "Scouter name",
                      jsonKey: "scouterName",
                      autofillKey: "scouterName",
                    ),
                  ),
                  MatchInfo(
                    margin: margin,
                    onDriverStationUpdate: (driverStation) {
                      setState(() {
                        this.driverStation = driverStation;
                      });
                    },
                  ),
                  MatchPrediction(
                    margin: margin,
                    jsonKey: "matchPrediction",
                  ),
                ],
              ))),
      "Auto": DataEntrySubPage(
        icon: CustomIcons.autonomous,
        content: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            spacing: 10,
            children: [
              RebuiltAutoPathSelector(
                margin: margin,
                flipField: flipField,
                pit: false,
              ),
              DefaultContainer(
                color: context.colors.container,
                child: AspectRatio(
                    aspectRatio: 8,
                    child: CustomCheckbox(
                      title: "Crossed Midline",
                      jsonKey: "autoCrossedMidline",
                      optionColor: context.colors.accent1,
                    )),
              ),
            ],
          ),
        ),
      ),
      "Offense": DataEntrySubPage(
        icon: Icons.workspaces_rounded,
        content: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            spacing: margin,
            children: [
              RebuiltLocationTracker(
                margin: margin,
                jsonKey: "scoringLocations",
                flipField: flipField,
              ),
              SizedBox(
                height: 50,
                child: DefaultContainer(
                  margin: margin,
                  child: CustomCheckbox(
                    title: "Being Defended",
                    jsonKey: "isBeingDefended",
                  ),
                ),
              ),
              DefaultContainer(
                expandHorizontal: true,
                margin: margin,
                child: Center(
                  child: DefaultContainer(
                    color: context.colors.muted,
                    margin: margin / 2,
                    child: Text(
                      "Feeding",
                      textAlign: TextAlign.center,
                      style: comfortaaBold(
                        17,
                        color: context.colors.container,
                        customFontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              Metric(
                checkboxTitle: "Pushing (Herding)",
                selectOptions: ["Poor", "Decent", "Great"],
                height: 80,
                optionColor: context.colors.accent1,
                jsonKey: "isHerding",
              ),
              Metric(
                checkboxTitle: "Shooting Over",
                selectOptions: ["Poor", "Decent", "Great"],
                height: 80,
                optionColor: context.colors.accent1,
                jsonKey: "isFeeding",
              ),
              Metric(
                checkboxTitle: "Counter Defense",
                selectOptions: ["Poor", "Decent", "Great"],
                height: 80,
                optionColor: context.colors.accent1,
                jsonKey: "isCounterDefending",
              ),
            ],
          ),
        ),
      ),
      "Defense": DataEntrySubPage(
        icon: Icons.shield_rounded,
        content: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            spacing: margin,
            children: [
              DefaultContainer(
                expandHorizontal: true,
                margin: margin,
                child: Center(
                  child: DefaultContainer(
                    color: context.colors.muted,
                    margin: margin / 2,
                    child: Text(
                      "Defending",
                      textAlign: TextAlign.center,
                      style: comfortaaBold(
                        17,
                        color: context.colors.container,
                        customFontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              Metric(
                checkboxTitle: "Trench / Bump",
                selectOptions: ["Poor", "Decent", "Great"],
                height: 80,
                optionColor: context.colors.accent2,
                jsonKey: "isAccessDefending",
              ),
              Metric(
                checkboxTitle: "Neutral Zone",
                selectOptions: ["Poor", "Decent", "Great"],
                height: 80,
                optionColor: context.colors.accent2,
                jsonKey: "isCenterDefending",
              ),
              Metric(
                checkboxTitle: "Alliance Zone",
                selectOptions: ["Poor", "Decent", "Great"],
                height: 80,
                optionColor: context.colors.accent2,
                jsonKey: "isAllianceDefending",
              ),
              Metric(
                checkboxTitle: "Stealing",
                selectOptions: ["Poor", "Decent", "Great"],
                height: 80,
                optionColor: context.colors.accent2,
                jsonKey: "isStealing",
              ),
            ],
          ),
        ),
      ),
      "Endgame": DataEntrySubPage(
        icon: CustomIcons.flag,
        content: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            spacing: margin,
            children: [
              RebuiltEndgameTagSelector(),
              TowerLocationSelector(
                margin: margin,
                jsonKey: "climb",
              ),
              NRGRating(
                  title: "Data Quality",
                  jsonKey: "dataQuality",
                  height: 90,
                  width: 400,
                  clearable: false),
              NRGCommentBox(
                title: "Comments",
                jsonKey: "comments",
                height: 90,
                margin: margin,
              ),
            ],
          ),
        ),
      )
    });
  }
}
