import "dart:collection";
import "dart:convert";

import "package:auto_size_text/auto_size_text.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/data_parser.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/apis/statbotics_api.dart";
import "package:lighthouse/themes.dart";
import "package:lighthouse/widgets/game_agnostic/default_container.dart";
import "package:lighthouse/widgets/game_agnostic/dropdown.dart";
import 'package:just_the_tooltip/just_the_tooltip.dart';
import "package:lighthouse/widgets/game_agnostic/star_display.dart";
import "package:lighthouse/widgets/rebuilt/rebuilt_auto_path_selector.dart";
import "package:lighthouse/widgets/rebuilt/rebuilt_location_tracker.dart";
import "package:lighthouse/widgets/rebuilt/tower_location_selector.dart";

class TagViewer extends StatefulWidget {
  /// Map of tags to list of matches those tags appeared in.
  ///
  /// e.g. "beachedOnFuel" : ["Q4", "Q23", "P6", "F1"]
  final Map<String, List<String>> tags;

  /// Function to run when the widget is tapped on.
  final Function(bool isExpanded) onTap;

  final double margin;

  final double initialHeight;

  const TagViewer(
      {super.key,
      required this.tags,
      this.onTap = _noop,
      required this.margin,
      required this.initialHeight});

  static void _noop(bool isExpanded) {}

  @override
  State<TagViewer> createState() => _TagViewerState();
}

class _TagViewerState extends State<TagViewer> {
  Map<String, List<String>> get _tags => widget.tags;
  Function(bool isExpanded) get _onTap => widget.onTap;
  double get _margin => widget.margin;
  double get _initialHeight => widget.initialHeight;

  bool _isExpanded = false;

  List<Widget> _getTags() {
    final entries = _tags.entries.toList();
    entries.sort((a, b) => b.value.length.compareTo(a.value.length));

    return entries.map((entry) => _getTag(entry.key, entry.value)).toList();
  }

  Widget _getTag(String name, List<String> matches) {
    return IgnorePointer(
      ignoring: !_isExpanded,
      child: JustTheTooltip(
        content: Padding(
          padding: EdgeInsets.all(_margin),
          child: Text(
            "$matches",
            style: comfortaaBold(17, color: context.colors.containerText),
          ),
        ),
        backgroundColor: context.colors.container,
        triggerMode: TooltipTriggerMode.tap,
        borderRadius: BorderRadius.circular(_margin),
        child: DefaultContainer(
          color: context.colors.accent1,
          child: Text("${matches.length} $name",
              style: comfortaaBold(13, color: context.colors.container)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        _onTap(_isExpanded);
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedSize(
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: DefaultContainer(
          expandHorizontal: true,
          margin: _margin,
          child: ClipRRect(
            child: SizedBox(
              width: double.infinity,
              height: _isExpanded ? null : _initialHeight,
              child: Wrap(
                spacing: _margin,
                runSpacing: _margin,
                alignment: WrapAlignment.center,
                children: [
                  ..._getTags(),
                  _isExpanded
                      ? Center(
                          child: Icon(
                            Icons.arrow_drop_up_rounded,
                            size: 25,
                            color: context.colors.containerText,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MiniInfoBox extends StatelessWidget {
  final String title;
  final String info;
  final double? margin;

  const MiniInfoBox(
      {super.key, required this.title, required this.info, this.margin});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      margin: margin,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: AutoSizeText(
                title,
                style: comfortaaBold(10, color: context.colors.containerText),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: AutoSizeText(
                info,
                style: comfortaaBold(12, color: context.colors.containerText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final String title;
  final String info;
  final String subInfo;
  final double? margin;
  final Function(TapUpDetails details)? onTap;

  const InfoBox({
    super.key,
    required this.title,
    required this.info,
    this.subInfo = "",
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: onTap,
      child: DefaultContainer(
        margin: margin,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: AutoSizeText(
                  title,
                  style: comfortaaBold(10, color: context.colors.containerText),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: AutoSizeText(
                  info,
                  style: comfortaaBold(30, color: context.colors.containerText),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: AutoSizeText(
                  subInfo,
                  style: comfortaaBold(10, color: context.colors.containerText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Auto {
  String scouterName;
  double rating;
  String match;
  bool attemptedClimb;
  bool climbSuccessful;
  List<dynamic> path;
  bool crossCenter;
  bool scorePreload;
  int amountScored;
  bool pit;

  Auto({
    required this.scouterName,
    required this.rating,
    required this.match,
    required this.attemptedClimb,
    required this.climbSuccessful,
    required this.path,
    required this.crossCenter,
    required this.scorePreload,
    required this.amountScored,
    required this.pit,
  });
}

class MetricData {
  double percentage = 0;
  String metric = "";
  List<MetricMatch> matches = [];
  double totalValue = 0;
}

class PitData {
  double weight = 0;
  int capacity = 0;
  String shooterType = "";
  String accessType = "";
  String drivetrain = "";
}

class TbaData {
  double? opr;
  double? total;
  double? auto;
  double? teleop;
  double? endgame;
}

class AutoPreview extends StatefulWidget {
  final List<Auto> autoData;
  final double margin;

  const AutoPreview({
    super.key,
    required this.autoData,
    required this.margin,
  });

  @override
  State<AutoPreview> createState() => _AutoPreviewState();
}

class _AutoPreviewState extends State<AutoPreview> {
  List<Auto> get _autoData => widget.autoData;
  double get _margin => widget.margin;

  Widget _getAutoPreview(Auto auto) {
    return DefaultContainer(
      margin: _margin / 3,
      child: Row(
        spacing: _margin,
        children: [
          Expanded(
            flex: 3,
            child: RebuiltAutoPathSelector(
              margin: 0,
              viewOnly: true,
              initialPath: auto.path,
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                spacing: _margin,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!auto.pit) StarDisplay(starRating: auto.rating),
                  AutoSizeText(
                    "${auto.scouterName} ${auto.match}",
                    textAlign: TextAlign.left,
                    style:
                        comfortaaBold(17, color: context.colors.containerText),
                  ),
                  if (auto.crossCenter)
                    AutoSizeText(
                      "Cross Center",
                      textAlign: TextAlign.left,
                      style: comfortaaBold(17,
                          color: context.colors.containerText),
                    ),
                  if (auto.scorePreload)
                    AutoSizeText(
                      "Scores Preload",
                      textAlign: TextAlign.left,
                      style: comfortaaBold(17,
                          color: context.colors.containerText),
                    ),
                  if (auto.pit)
                    AutoSizeText(
                      "Fuel Scored: ${auto.amountScored}",
                      textAlign: TextAlign.left,
                      style: comfortaaBold(17,
                          color: context.colors.containerText),
                    ),
                  if (auto.attemptedClimb)
                    AutoSizeText(
                      "Climb Attempted${auto.pit ? "" : ": ${auto.climbSuccessful ? "Successful" : "Unsuccessful"}"}",
                      style: comfortaaBold(17,
                          color: context.colors.containerText),
                    ),
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      margin: _margin,
      expandHorizontal: true,
      child: DefaultContainer(
        margin: _margin / 3,
        color: context.colors.accent1,
        child: SingleChildScrollView(
          child: Column(
            spacing: _margin,
            children: _autoData.map((auto) => _getAutoPreview(auto)).toList(),
          ),
        ),
      ),
    );
  }
}

class Climb {
  final bool isAutoClimb;
  final double? time;
  final ClimbLevel level;

  const Climb({this.isAutoClimb = false, this.time, required this.level});
}

class ClimbsInfoData {
  int autoClimbs;
  int autoSuccessfulClimbs;
  int endgameClimbs;
  int endgameSucessfulClimbs;
  double totalTime;
  double timedClimbs;
  int level1;
  int level2;
  int level3;

  ClimbsInfoData({
    this.autoClimbs = 0,
    this.autoSuccessfulClimbs = 0,
    this.endgameClimbs = 0,
    this.endgameSucessfulClimbs = 0,
    this.totalTime = 0,
    this.timedClimbs = 0,
    this.level1 = 0,
    this.level2 = 0,
    this.level3 = 0,
  });
}

class Comment {
  final double rating;
  final String author;
  final String body;
  final String match;
  final bool pit;

  const Comment({
    required this.rating,
    required this.author,
    required this.body,
    required this.match,
    required this.pit,
  });
}

class CommentViewer extends StatefulWidget {
  final List<Comment> comments;
  final double margin;

  const CommentViewer({
    super.key,
    required this.comments,
    required this.margin,
  });

  @override
  State<CommentViewer> createState() => _CommentViewerState();
}

class _CommentViewerState extends State<CommentViewer> {
  List<Comment> get _comments => widget.comments;
  double get _margin => widget.margin;

  Widget _getCommentBox(Comment comment) {
    return DefaultContainer(
      expandHorizontal: true,
      color: context.colors.container,
      margin: _margin,
      child: Column(
        spacing: _margin / 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: _margin,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${comment.author}  ${comment.match}",
                style: comfortaaBold(17,
                    color: context.colors.containerText,
                    customFontWeight: FontWeight.w900),
                maxLines: 1,
              ),
              if (!comment.pit) StarDisplay(starRating: comment.rating),
            ],
          ),
          Text(
            comment.body,
            style: comfortaaBold(14, color: context.colors.containerText),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      margin: _margin,
      expandHorizontal: true,
      child: DefaultContainer(
        margin: _margin / 2,
        color: context.colors.accent2,
        child: SingleChildScrollView(
          child: Column(
            spacing: _margin / 2,
            children:
                _comments.map((comment) => _getCommentBox(comment)).toList(),
          ),
        ),
      ),
    );
  }
}

class ClimbInfoBox extends StatelessWidget {
  final List<Climb> climbs;
  final double margin;

  const ClimbInfoBox({super.key, required this.climbs, required this.margin});

  ClimbsInfoData _getData(List<Climb> climbs) {
    ClimbsInfoData data = ClimbsInfoData();

    for (Climb climb in climbs) {
      if (climb.isAutoClimb) {
        data.autoClimbs++;
        if (climb.level != ClimbLevel.none) data.autoSuccessfulClimbs++;
      } else {
        data.endgameClimbs++;
        data.endgameSucessfulClimbs++;
        switch (climb.level) {
          case ClimbLevel.l1:
            data.level1++;
            break;
          case ClimbLevel.l2:
            data.level2++;
            break;
          case ClimbLevel.l3:
            data.level3++;
            break;
          default:
            data.endgameSucessfulClimbs--;
            break;
        }
        if (climb.time != null) {
          data.totalTime += climb.time!;
          data.timedClimbs++;
        }
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    ClimbsInfoData data = _getData(climbs);

    return DefaultContainer(
      child: Row(
        spacing: margin,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              spacing: margin / 2,
              children: [
                AutoSizeText(
                  "Auto Climb",
                  maxLines: 1,
                  style: comfortaaBold(10, color: context.colors.containerText),
                ),
                DefaultContainer(
                  color: context.colors.muted,
                  child: AutoSizeText(
                    "${data.autoSuccessfulClimbs.toInt()} / ${data.autoClimbs.toInt()}",
                    style: comfortaaBold(18,
                        color: context.colors.container,
                        customFontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              spacing: margin / 2,
              children: [
                AutoSizeText(
                  "Endgame Climb",
                  maxLines: 1,
                  style: comfortaaBold(10, color: context.colors.containerText),
                ),
                DefaultContainer(
                  color: context.colors.muted,
                  child: AutoSizeText(
                    "${data.endgameSucessfulClimbs.toInt()} / ${data.endgameClimbs.toInt()}",
                    style: comfortaaBold(18,
                        color: context.colors.container,
                        customFontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              spacing: margin / 2,
              children: [
                AutoSizeText(
                  "Average Time: ${data.timedClimbs == 0 ? "N/A" : (data.totalTime / data.timedClimbs).toStringAsFixed(2)}",
                  maxLines: 1,
                  style: comfortaaBold(10, color: context.colors.containerText),
                ),
                Row(
                  spacing: margin / 2,
                  children: [
                    Expanded(
                      child: DefaultContainer(
                        margin: margin,
                        color: context.colors.accent3,
                        child: AutoSizeText(
                          "${data.level1.toInt()}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: comfortaaBold(
                            18,
                            color: context.colors.container,
                            customFontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DefaultContainer(
                        margin: margin,
                        color: context.colors.accent4,
                        child: AutoSizeText(
                          "${data.level2.toInt()}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: comfortaaBold(
                            18,
                            color: context.colors.container,
                            customFontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DefaultContainer(
                        margin: margin,
                        color: context.colors.accent1,
                        child: AutoSizeText(
                          "${data.level3.toInt()}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: comfortaaBold(
                            18,
                            color: context.colors.container,
                            customFontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetricMatch {
  final String match;
  final String metric;

  const MetricMatch({required this.match, required this.metric});
}

class MetricResult {
  final List<MetricMatch> matches;
  final double totalMetric;
  final double percentage;
  final String metricString;

  MetricResult({
    required this.matches,
    required this.totalMetric,
    required this.percentage,
    required this.metricString,
  });
}

class ScoringLocationViewer extends StatefulWidget {
  final double margin;
  final Map<String, double?> accuracyColors;
  final Map<String, double?> frequencyColors;

  const ScoringLocationViewer(
      {super.key,
      required this.margin,
      required this.accuracyColors,
      required this.frequencyColors});

  @override
  State<ScoringLocationViewer> createState() => _ScoringLocationViewerState();
}

class _ScoringLocationViewerState extends State<ScoringLocationViewer> {
  double get _margin => widget.margin;
  Map<String, double?> get _accuracyColors => widget.accuracyColors;
  Map<String, double?> get _frequencyColors => widget.frequencyColors;

  Color _getColorFromValue(double? value) {
    Color noValueColor = Color.fromARGB(100, 191, 199, 200);
    Color badValueColor = Color.fromARGB(100, 233, 105, 98);
    Color midValueColor = Color.fromARGB(100, 242, 225, 74);
    Color goodValueColor = Color.fromARGB(100, 121, 234, 68);

    if (value == null) {
      return noValueColor;
    } else {
      double clampedValue = value.clamp(0.0, 1.0);
      if (clampedValue < 0.5) {
        return Color.lerp(badValueColor, midValueColor, clampedValue * 2) ??
            noValueColor;
      } else {
        return Color.lerp(
                midValueColor, goodValueColor, (clampedValue - 0.5) * 2) ??
            noValueColor;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      margin: _margin,
      child: Column(
        spacing: _margin / 2,
        children: [
          Row(
            spacing: _margin,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Accuracy",
                textAlign: TextAlign.center,
                style: comfortaaBold(
                  17,
                  color: context.colors.containerText,
                ),
              ),
              Text(
                "Frequency",
                textAlign: TextAlign.center,
                style: comfortaaBold(
                  17,
                  color: context.colors.containerText,
                ),
              ),
            ],
          ),
          Row(
            spacing: _margin,
            children: [
              Expanded(
                child: Column(
                  children: [
                    RebuiltLocationTracker(
                      viewOnly: true,
                      margin: 0,
                      mapColor: context.colors.muted,
                      assignedColors: _accuracyColors.map(
                        (key, value) => MapEntry(
                          key,
                          _getColorFromValue(value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    RebuiltLocationTracker(
                      viewOnly: true,
                      margin: 0,
                      mapColor: context.colors.muted,
                      assignedColors: _frequencyColors.map(
                        (key, value) => MapEntry(
                          key,
                          _getColorFromValue(value),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PopupInfoBox extends StatefulWidget {
  final String title;
  final String info;
  final String subInfo;
  final Widget? child;

  const PopupInfoBox({
    super.key,
    required this.info,
    this.child,
    this.subInfo = "",
    required this.title,
  });

  @override
  State<PopupInfoBox> createState() => _PopupInfoBoxState();
}

class _PopupInfoBoxState extends State<PopupInfoBox> {
  String get _title => widget.title;
  String get _info => widget.info;
  String get _subInfo => widget.subInfo;
  Widget? get _child => widget.child;

  @override
  Widget build(BuildContext context) {
    return InfoBox(
      title: _title,
      info: _info,
      subInfo: _subInfo,
      onTap: (details) {
        showDialog(
          context: context,
          builder: (context) {
            return GestureDetector(
              onTapUp: (details) {
                Navigator.of(context).pop();
              },
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: _child,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class TeamSelectorCard extends StatelessWidget {
  final Set<int> teams;
  final String? teamName;
  final double margin;
  final void Function(int) onTeamChanged;

  const TeamSelectorCard({
    super.key,
    required this.teams,
    required this.teamName,
    required this.margin,
    required this.onTeamChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        spacing: margin,
        children: [
          Expanded(
            flex: 4,
            child: DefaultContainer(
              expandVertical: true,
              margin: margin,
              child: CustomDropdown(
                options: teams.map((x) => "$x").toList(),
                color: context.colors.accent2,
                onChanged: (value) {
                  onTeamChanged(
                      DataParser.toInt(value) ?? teams.firstOrNull ?? -1);
                },
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: DefaultContainer(
              expandVertical: true,
              margin: margin,
              child: Center(
                child: AutoSizeText(
                  teamName ?? "No team found",
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: comfortaaBold(17, color: context.colors.containerText),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsBar extends StatelessWidget {
  final TbaData epaData;
  final double margin;

  const StatsBar({
    super.key,
    required this.epaData,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        spacing: margin,
        children: [
          Expanded(
            child: MiniInfoBox(
              title: "OPR",
              info: epaData.opr?.toStringAsFixed(2) ?? "...",
            ),
          ),
          Expanded(
            flex: 5,
            child: DefaultContainer(
              margin: margin,
              child: Row(
                children: [
                  Expanded(
                    child: MiniInfoBox(
                      margin: 0,
                      title: "EPA",
                      info: epaData.total?.toStringAsFixed(2) ?? "loading",
                    ),
                  ),
                  Expanded(
                    child: MiniInfoBox(
                      margin: 0,
                      title: "Auto",
                      info: epaData.auto?.toStringAsFixed(2) ?? "...",
                    ),
                  ),
                  Expanded(
                    child: MiniInfoBox(
                      margin: 0,
                      title: "Teleop",
                      info: epaData.teleop?.toStringAsFixed(2) ?? "...",
                    ),
                  ),
                  Expanded(
                    child: MiniInfoBox(
                      margin: 0,
                      title: "Endgame",
                      info: epaData.endgame?.toStringAsFixed(2) ?? "...",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MatchChipsFactory {
  static Widget build(
      List<MetricMatch> matches, double margin, LightHouseColorScheme colors) {
    return Wrap(
      spacing: margin,
      runSpacing: margin,
      children: matches
          .map(
            (match) => DefaultContainer(
              margin: margin,
              color: match.metric == "Great"
                  ? colors.good
                  : (match.metric == "Decent" ? colors.neutral : colors.bad),
              child: Text(
                match.match,
                style: comfortaaBold(17, color: colors.containerText),
              ),
            ),
          )
          .toList(),
    );
  }
}

class MetricWidgetFactory {
  static String percentageString(double value) {
    return "${(value * 100).toStringAsFixed(2)}%";
  }

  static Widget buildInfoGrid(
      List<Widget> children, double spacing, double aspectRatio) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: aspectRatio,
      children: children,
    );
  }
}

class AryavDataViewer extends StatefulWidget {
  const AryavDataViewer({super.key});

  @override
  State<AryavDataViewer> createState() => _AryavDataViewerState();
}

class _AryavDataViewerState extends State<AryavDataViewer> {
  final double _margin = 10;
  Set<int> _teams = {};
  List<Map<String, dynamic>> _atlasData = [];
  List<Map<String, dynamic>> _pitData = [];

  String? _teamName;
  int _matches = 0;

  Map<String, List<String>> _tags = {};

  PitData _pitDataGrouped = PitData();

  double _averageAccuracy = 0;
  double _averageDefendedAccuracy = 0;

  MetricData _feeding = MetricData();
  MetricData _shooting = MetricData();
  MetricData _herding = MetricData();

  MetricData _defense = MetricData();
  MetricData _access = MetricData();
  MetricData _center = MetricData();
  MetricData _alliance = MetricData();
  MetricData _stealing = MetricData();
  MetricData _counter = MetricData();

  List<Auto> _autos = [];

  List<Climb> _climbs = [];
  List<Comment> _comments = [];

  Map<String, double?> _accuracyMappings = {};
  Map<String, double?> _frequencyMappings = {};

  TbaData _tbaData = TbaData();

  // Constants
  static const List<String> _scoringRegions = [
    "depot_corner",
    "depot_trench",
    "depot_wall",
    "depot_bump",
    "tower",
    "hub",
    "outpost_wall",
    "outpost_bump",
    "outpost_corner",
    "outpost_trench",
  ];

  static const double _greatThreshold = 0.34;
  static const double _normalizedOffset = 1.0;
  static const double _normalizedScale = 2.0;
  static const double _percentageDivisor = 3.0;

  static const int _qualifierOffset = 1000;
  static const int _playoffOffset = 2000;
  static const int _finalOffset = 3000;

  String _shortenMatch(String matchType, int matchNumber) {
    if (matchType.isEmpty) {
      return "$matchNumber";
    }
    return "${matchType[0]}$matchNumber";
  }

  Set<int> _getTeamsInDatabase() {
    SplayTreeSet<int> teams = SplayTreeSet();

    for (Map<String, dynamic> matchData in _atlasData) {
      teams.add(matchData["teamNumber"]);
    }

    for (Map<String, dynamic> matchData in _pitData) {
      teams.add(matchData["teamNumber"]);
    }

    return teams.toSet();
  }

  double _accuracyMetricToNormalized(double accuracy) {
    return (accuracy - _normalizedOffset) / _normalizedScale;
  }

  double _accuracyMetricToPercentage(double accuracy) {
    return accuracy / _percentageDivisor;
  }

  double zeroSafeDivision(double dividend, double divisor) {
    return divisor == 0 ? 0 : dividend / divisor;
  }

  double _metricToValue(String metric) {
    switch (metric) {
      case "Great":
        return 1;
      case "Decent":
        return 0;
      case "Poor":
        return -1;
      default:
        return 0;
    }
  }

  String _valueToMetric(double value) {
    if (value > _greatThreshold) {
      return "Great";
    } else if (value < -_greatThreshold) {
      return "Poor";
    } else {
      return "Decent";
    }
  }

  // ignore: unused_element
  List<Map<String, dynamic>> _getDataAsMapFromSavedMatches(String layout) {
    assert(configData["eventKey"] != null);
    List<String> dataFilePaths =
        getFilesInLayout(configData["eventKey"]!, layout);
    return dataFilePaths
        .map<Map<String, dynamic>>((String path) =>
            loadFileIntoSavedData(configData["eventKey"]!, layout, path))
        .toList();
  }

  // ignore: unused_element
  List<Map<String, dynamic>> _getDataAsMapFromDatabase(String layout) {
    assert(configData["eventKey"] != null);
    String file = loadDatabaseFile(configData["eventKey"]!, layout);
    if (file == "") return [];
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        jsonDecode(loadDatabaseFile(configData["eventKey"]!, layout))
            .map((item) => Map<String, dynamic>.from(item)));
    return data;
  }

  Future<void> _setTeamNameWithNumber(int teamNumber) async {
    dynamic teamPage;
    try {
      teamPage = jsonDecode(await rootBundle.loadString(
          "assets/text/teams${(teamNumber ~/ 500) * 500}-${(teamNumber ~/ 500) * 500 + 500}.txt"));
    } catch (e) {
      return;
    }

    for (dynamic teamObject in teamPage) {
      if (teamObject["key"] == "frc$teamNumber") {
        setState(() {
          _teamName = teamObject["nickname"];
        });
      }
    }
  }

  Future<void> _setOprWithTeamNumber(int teamNumber) async {
    String content = await loadTBAFile(configData["eventKey"]!, "event_oprs");
    dynamic matchData;

    try {
      matchData = Map<String, dynamic>.from(jsonDecode(content));

      if ((DataParser.toBool(configData["downloadTheBlueAllianceInfo"]) ??
              false) &&
          matchData != []) {
        debugPrint(matchData.toString());
        setState(() {
          _tbaData.opr = matchData["oprs"]["frc$teamNumber"];
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _setEpasWithTeamNumber(int teamNumber) async {
    Map<String, double> data = await StatboticsApi.getTeamEPAFromEvent(
        teamNumber, configData["eventKey"]!);
    setState(() {
      _tbaData.total = data["total_points"] ?? 0;
      _tbaData.auto = data["auto_points"] ?? 0;
      _tbaData.teleop = data["teleop_points"] ?? 0;
      _tbaData.endgame = data["endgame_points"] ?? 0;
    });
  }

  Widget _getMatchesWidgetList(List<MetricMatch> matches) {
    return MatchChipsFactory.build(matches, _margin, context.colors);
  }

  int _matchToIdentifier(String shortenedMatch) {
    int value = 0;
    switch (shortenedMatch[0]) {
      case "Q":
        value += _qualifierOffset;
        break;
      case "P":
        if (shortenedMatch == "Pit") break;
        value += _playoffOffset;
        break;
      case "F":
        value += _finalOffset;
        break;
      default:
        break;
    }
    value += DataParser.toInt(shortenedMatch.substring(1)) ?? 0;
    return value;
  }

  int _compareMatches(String a, String b) {
    return _matchToIdentifier(a).compareTo(_matchToIdentifier(b));
  }

  bool _loadData(int team) {
    _atlasData = _getDataAsMapFromDatabase("Atlas");
    _pitData = _getDataAsMapFromDatabase("Pit");
    _teams = _getTeamsInDatabase();

    _matches = 0;

    _tags = {};

    _pitDataGrouped = PitData();

    _averageAccuracy = 0;
    double totalAccuracy = 0;
    int accuracyMeasureCount = 0;

    _averageDefendedAccuracy = 0;
    double totalDefendedAccuracy = 0;
    int defendedAccuracyCount = 0;

    _feeding = MetricData();
    int feedingCount = 0;
    double totalFeedingMetric = 0;

    _shooting = MetricData();
    double totalShootingMetric = 0;

    _herding = MetricData();
    double totalHerdingMetric = 0;

    _defense = MetricData();
    int defenseCount = 0;
    double totalDefenseMetric = 0;

    _access = MetricData();
    double totalAccessMetric = 0;

    _center = MetricData();
    double totalCenterMetric = 0;

    _alliance = MetricData();
    double totalAllianceMetric = 0;

    _stealing = MetricData();
    double totalStealingMetric = 0;

    _counter = MetricData();
    double totalCounterMetric = 0;

    _autos = [];

    _climbs = [];
    _comments = [];

    _accuracyMappings = {};
    _frequencyMappings = {};

    _tbaData = TbaData();

    Map<String, List<double>> accuracyPerRegion = {
      for (var e in _scoringRegions) e: []
    };
    Map<String, int> frequencyPerRegion = {for (var e in _scoringRegions) e: 0};

    if (!_teams.contains(team)) return false;

    _setTeamNameWithNumber(team);
    _setOprWithTeamNumber(team);
    _setEpasWithTeamNumber(team);

    for (Map<String, dynamic> entry in _pitData) {
      int? curTeam = DataParser.toInt(entry["teamNumber"]);
      if (curTeam == null) continue;

      if (team == curTeam) {
        _pitDataGrouped.capacity =
            DataParser.toInt(entry["fuelCapacity"]) ?? -1;
        _pitDataGrouped.shooterType = DataParser.asString(entry["shooterType"]);
        _pitDataGrouped.accessType = ["able", "preferred"]
                .contains(DataParser.asString(entry["canGoTrench"]))
            ? "Trench"
            : "Bump";
        _pitDataGrouped.drivetrain = DataParser.asString(entry["drivetrain"]);
        _pitDataGrouped.weight = DataParser.toDouble(entry["weight"]) ?? 0;

        // Pit Autos
        int i = 1;
        while (true) {
          if (!DataParser.isEmpty(entry["autoPath$i"]) &&
              entry["autoPath$i"] is Map<String, dynamic> &&
              !DataParser.isEmpty(entry["autoPath$i"]!["path"])) {
            _autos.add(Auto(
                scouterName: DataParser.asString(entry["scouterName"]),
                rating: 0,
                match: "Pit",
                attemptedClimb:
                    DataParser.toBool(entry["autoPath$i"]!["attemptedClimb"]) ??
                        false,
                climbSuccessful: false,
                path: DataParser.toList(entry["autoPath$i"]!["path"]) ?? [],
                crossCenter:
                    DataParser.toBool(entry["autoCrossedMidline$i"]) ?? false,
                scorePreload:
                    DataParser.toBool(entry["autoPath$i"]!["shotPreload"]) ??
                        false,
                amountScored: DataParser.toInt(entry["autoFuelScored$i"]) ?? 0,
                pit: true));
            i++;
          } else {
            break;
          }
        }

        // Pit Comments
        if (!DataParser.isEmpty(entry["comments"])) {
          _comments.add(Comment(
            author: DataParser.asString(entry["scouterName"]),
            rating: 0,
            body: DataParser.asString(entry["comments"]),
            match: "Pit",
            pit: true,
          ));
        }
      }
    }

    for (Map<String, dynamic> entry in _atlasData) {
      int? curTeam = DataParser.toInt(entry["teamNumber"]);
      if (curTeam == null) continue;

      if (team == curTeam) {
        String shortenedMatch = _shortenMatch(
            DataParser.asString(entry["matchType"]),
            DataParser.toInt(entry["matchNumber"]) ?? 0);

        _matches++;

        // Tags
        if (entry["tags"] != null) {
          List<dynamic> curTags = DataParser.toList(entry["tags"])!;
          for (dynamic tag in curTags) {
            if (tag is! String) continue;

            if (!_tags.keys.contains(tag)) _tags[tag] = [];
            _tags[tag]!.add(shortenedMatch);
          }
        }

        // Comments
        if (!DataParser.isEmpty(entry["comments"])) {
          _comments.add(Comment(
            author: DataParser.asString(entry["scouterName"]),
            rating: DataParser.toDouble(entry["dataQuality"]) ?? 0,
            body: DataParser.asString(entry["comments"]),
            match: shortenedMatch,
            pit: false,
          ));
        }

        // Auto
        if (!DataParser.isEmpty(entry["autoPath"]) &&
            entry["autoPath"] is Map<String, dynamic>) {
          _autos.add(Auto(
              scouterName: DataParser.asString(entry["scouterName"]),
              rating: DataParser.toDouble(entry["dataQuality"]) ?? 0,
              match: shortenedMatch,
              attemptedClimb:
                  DataParser.toBool(entry["autoPath"]!["attemptedClimb"]) ??
                      false,
              climbSuccessful:
                  DataParser.toBool(entry["autoPath"]!["climbSuccessful"]) ??
                      false,
              path: DataParser.toList(entry["autoPath"]!["path"]) ?? [],
              crossCenter:
                  DataParser.toBool(entry["autoCrossedMidline"]) ?? false,
              scorePreload:
                  DataParser.toBool(entry["autoPath"]!["shotPreload"]) ?? false,
              amountScored: 0,
              pit: false));

          if (entry["autoPath"]!["attemptedClimb"] == true) {
            _climbs.add(Climb(
                level: entry["autoPath"]!["climbSuccessful"] == true
                    ? ClimbLevel.l1
                    : ClimbLevel.none,
                isAutoClimb: true));
          }
        }

        // Climb
        if (!DataParser.isEmpty(entry["climb"]) &&
            entry["climb"] is Map<String, dynamic> &&
            entry["climb"]!["attempted"] == true) {
          _climbs.add(Climb(
              level: ClimbLevelExtension.getLevelFromName(
                  entry["climb"]!["level"]),
              time: DataParser.toDouble(entry["climb"]!["startTime"])));
        }

        // Accuracy & Frequency Maps
        if (!DataParser.isEmpty(entry["scoringLocations"]) &&
            entry["scoringLocations"] is Map<String, dynamic>) {
          for (String region in _scoringRegions) {
            if (entry["scoringLocations"]![region] is! List<dynamic>) continue;
            for (dynamic item
                in DataParser.toList(entry["scoringLocations"]![region]) ??
                    []) {
              double? value = DataParser.toDouble(item);
              if (value != null) {
                accuracyPerRegion[region]!
                    .add(_accuracyMetricToNormalized(value));

                accuracyMeasureCount++;
                totalAccuracy += _accuracyMetricToPercentage(value);
                if (entry["isBeingDefended"] == true) {
                  defendedAccuracyCount++;
                  totalDefendedAccuracy += _accuracyMetricToPercentage(value);
                }
              }
              frequencyPerRegion[region] = frequencyPerRegion[region]! + 1;
            }
          }
        }

        Map<String, dynamic>? temp;

        // Feeding
        if (DataParser.toMap(entry["isHerding"])?["isChecked"] == true ||
            DataParser.toMap(entry["isFeeding"])?["isChecked"] == true) {
          feedingCount++;
        }

        temp = DataParser.toMap(entry["isHerding"]);
        if (temp?["isChecked"] == true) {
          _herding.matches.add(MetricMatch(
              match: shortenedMatch,
              metric: DataParser.asString(temp?["selection"])));
          totalHerdingMetric +=
              _metricToValue(DataParser.asString(temp?["selection"]));
        }

        temp = DataParser.toMap(entry["isFeeding"]);
        if (temp?["isChecked"] == true) {
          _shooting.matches.add(MetricMatch(
              match: shortenedMatch,
              metric: DataParser.asString(temp?["selection"])));
          totalShootingMetric +=
              _metricToValue(DataParser.asString(temp?["selection"]));
        }

        totalFeedingMetric = totalHerdingMetric + totalShootingMetric;

        // Defense
        if (DataParser.toMap(
                    entry["isAccessDefending"])?["isChecked"] ==
                true ||
            DataParser.toMap(entry["isCenterDefending"])?["isChecked"] ==
                true ||
            DataParser.toMap(entry["isAllianceDefending"])?["isChecked"] ==
                true ||
            DataParser.toMap(entry["isStealing"])?["isChecked"] == true ||
            DataParser.toMap(entry["isCounterDefending"])?["isChecked"] ==
                true) {
          defenseCount++;
        }

        temp = DataParser.toMap(entry["isAccessDefending"]);
        if (temp?["isChecked"] == true) {
          _access.matches.add(MetricMatch(
              match: shortenedMatch,
              metric: DataParser.asString(temp?["selection"])));
          totalAccessMetric +=
              _metricToValue(DataParser.asString(temp?["selection"]));
        }

        temp = DataParser.toMap(entry["isCenterDefending"]);
        if (temp?["isChecked"] == true) {
          _center.matches.add(MetricMatch(
              match: shortenedMatch,
              metric: DataParser.asString(temp?["selection"])));
          totalCenterMetric +=
              _metricToValue(DataParser.asString(temp?["selection"]));
        }

        temp = DataParser.toMap(entry["isAllianceDefending"]);
        if (temp?["isChecked"] == true) {
          _alliance.matches.add(MetricMatch(
              match: shortenedMatch,
              metric: DataParser.asString(temp?["selection"])));
          totalAllianceMetric +=
              _metricToValue(DataParser.asString(temp?["selection"]));
        }

        temp = DataParser.toMap(entry["isStealing"]);
        if (temp?["isChecked"] == true) {
          _stealing.matches.add(MetricMatch(
              match: shortenedMatch,
              metric: DataParser.asString(temp?["selection"])));
          totalStealingMetric +=
              _metricToValue(DataParser.asString(temp?["selection"]));
        }

        temp = DataParser.toMap(entry["isCounterDefending"]);
        if (temp?["isChecked"] == true) {
          _counter.matches.add(MetricMatch(
              match: shortenedMatch,
              metric: DataParser.asString(temp?["selection"])));
          totalCounterMetric +=
              _metricToValue(DataParser.asString(temp?["selection"]));
        }

        totalDefenseMetric = totalAccessMetric +
            totalCenterMetric +
            totalAllianceMetric +
            totalStealingMetric +
            totalCounterMetric;
      }
    }

    // Autos and Comments
    _autos.sort((a, b) => _compareMatches(b.match, a.match));
    _comments.sort((a, b) => _compareMatches(b.match, a.match));

    // TODO: Holy copy paste code. I will make this better when I have time.

    // Accuracy & Defended accuracy
    _averageAccuracy =
        zeroSafeDivision(totalAccuracy, accuracyMeasureCount.toDouble());
    _averageDefendedAccuracy = zeroSafeDivision(
        totalDefendedAccuracy, defendedAccuracyCount.toDouble());

    // % Defense
    _defense.percentage =
        zeroSafeDivision(defenseCount.toDouble(), _matches.toDouble());
    _defense.metric = defenseCount == 0
        ? "No Data"
        : _valueToMetric(
            zeroSafeDivision(totalDefenseMetric, defenseCount.toDouble()));

    _stealing.percentage = zeroSafeDivision(
        _stealing.matches.length.toDouble(), _matches.toDouble());
    _stealing.metric = _stealing.matches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalStealingMetric, _stealing.matches.length.toDouble()));

    _center.percentage = zeroSafeDivision(
        _center.matches.length.toDouble(), _matches.toDouble());
    _center.metric = _center.matches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalCenterMetric, _center.matches.length.toDouble()));

    _alliance.percentage = zeroSafeDivision(
        _alliance.matches.length.toDouble(), _matches.toDouble());
    _alliance.metric = _alliance.matches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalAllianceMetric, _alliance.matches.length.toDouble()));

    _access.percentage = zeroSafeDivision(
        _access.matches.length.toDouble(), _matches.toDouble());
    _access.metric = _access.matches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalAccessMetric, _access.matches.length.toDouble()));

    _counter.percentage = zeroSafeDivision(
        _counter.matches.length.toDouble(), _matches.toDouble());
    _counter.metric = _counter.matches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalCounterMetric, _counter.matches.length.toDouble()));

    // % Feeding
    _feeding.percentage =
        zeroSafeDivision(feedingCount.toDouble(), _matches.toDouble());
    _feeding.metric = feedingCount == 0
        ? "No Data"
        : _valueToMetric(
            zeroSafeDivision(totalFeedingMetric, feedingCount.toDouble()));

    _shooting.percentage = zeroSafeDivision(
        _shooting.matches.length.toDouble(), _matches.toDouble());
    _shooting.metric = _shooting.matches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalShootingMetric, _shooting.matches.length.toDouble()));

    _herding.percentage = zeroSafeDivision(
        _herding.matches.length.toDouble(), _matches.toDouble());
    _herding.metric = _herding.matches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalHerdingMetric, _herding.matches.length.toDouble()));

    // Accuracy & Frequency Maps
    _accuracyMappings = accuracyPerRegion.map(
        (key, value) => MapEntry(key, value.isEmpty ? null : value.average));
    _frequencyMappings = frequencyPerRegion.map((key, value) => MapEntry(
        key, value <= 0 ? null : value / frequencyPerRegion.values.max));

    setState(() {});

    return true;
  }

  @override
  void initState() {
    super.initState();
    _loadData(_teams.firstOrNull ?? -1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.colors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: context.colors.backgroundPrimary,
        title: Text(
          "Aryav's Data Viewer",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: context.colors.titleText),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamed(context, "/home-data-viewer");
            },
            icon: Icon(
              Icons.home,
              color: context.colors.titleText,
            )),
      ),
      body: Container(
        padding: EdgeInsets.all(_margin),
        decoration: context.backgroundDecoration,
        child: SingleChildScrollView(
          child: Column(
            spacing: _margin,
            children: [
              TeamSelectorCard(
                teams: _teams,
                teamName: _teamName,
                margin: _margin,
                onTeamChanged: _loadData,
              ),
              TagViewer(
                tags: _tags,
                margin: _margin,
                initialHeight: 90,
              ),
              StatsBar(
                epaData: _tbaData,
                margin: _margin,
              ),
              SizedBox(
                height: 100,
                child: Row(
                  spacing: _margin,
                  children: [
                    Expanded(
                      child: PopupInfoBox(
                        title: "Weight (lb)",
                        info: _pitDataGrouped.weight.toStringAsFixed(1),
                        subInfo: "with bumpers",
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: _margin,
                          mainAxisSpacing: _margin,
                          childAspectRatio: 1.4,
                          children: [
                            InfoBox(
                                info: _pitDataGrouped.shooterType,
                                title: "Shooter Type"),
                            InfoBox(
                                info: "${_pitDataGrouped.capacity}",
                                title: "Capacity"),
                            InfoBox(
                                info: _pitDataGrouped.accessType,
                                title: "Neutral Access"),
                            InfoBox(
                                info: _pitDataGrouped.drivetrain,
                                title: "Drivetrain"),
                            InfoBox(
                                info: MetricWidgetFactory.percentageString(
                                    _averageAccuracy),
                                title: "Avg. Accuracy"),
                            InfoBox(
                                info: MetricWidgetFactory.percentageString(
                                    _averageDefendedAccuracy),
                                title: "Defended Avg. Acc"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: PopupInfoBox(
                        title: "% Feeding",
                        info: MetricWidgetFactory.percentageString(
                            _feeding.percentage),
                        subInfo: _feeding.metric,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: _margin,
                          mainAxisSpacing: _margin,
                          childAspectRatio: 1.4,
                          children: [
                            PopupInfoBox(
                              info: MetricWidgetFactory.percentageString(
                                  _shooting.percentage),
                              title: "Shooting",
                              subInfo: _shooting.metric,
                              child: _getMatchesWidgetList(_shooting.matches),
                            ),
                            PopupInfoBox(
                              info: MetricWidgetFactory.percentageString(
                                  _herding.percentage),
                              title: "Herding",
                              subInfo: _herding.metric,
                              child: _getMatchesWidgetList(_herding.matches),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: PopupInfoBox(
                        title: "% Defending",
                        info: MetricWidgetFactory.percentageString(
                            _defense.percentage),
                        subInfo: _defense.metric,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: _margin,
                          mainAxisSpacing: _margin,
                          childAspectRatio: 1.4,
                          children: [
                            PopupInfoBox(
                              info: MetricWidgetFactory.percentageString(
                                  _access.percentage),
                              title: "Trench / Bump",
                              subInfo: _access.metric,
                              child: _getMatchesWidgetList(_access.matches),
                            ),
                            PopupInfoBox(
                              info: MetricWidgetFactory.percentageString(
                                  _center.percentage),
                              title: "Neutral Zone",
                              subInfo: _center.metric,
                              child: _getMatchesWidgetList(_center.matches),
                            ),
                            PopupInfoBox(
                              info: MetricWidgetFactory.percentageString(
                                  _alliance.percentage),
                              title: "Alliance Zone",
                              subInfo: _alliance.metric,
                              child: _getMatchesWidgetList(_alliance.matches),
                            ),
                            PopupInfoBox(
                              info: MetricWidgetFactory.percentageString(
                                  _stealing.percentage),
                              title: "Stealing",
                              subInfo: _stealing.metric,
                              child: _getMatchesWidgetList(_stealing.matches),
                            ),
                            PopupInfoBox(
                              info: MetricWidgetFactory.percentageString(
                                  _counter.percentage),
                              title: "Counter Defense",
                              subInfo: _counter.metric,
                              child: _getMatchesWidgetList(_counter.matches),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 250,
                child: AutoPreview(
                  margin: _margin,
                  autoData: _autos,
                ),
              ),
              SizedBox(
                height: 200,
                child: CommentViewer(
                  comments: _comments,
                  margin: _margin,
                ),
              ),
              ScoringLocationViewer(
                margin: _margin,
                accuracyColors: _accuracyMappings,
                frequencyColors: _frequencyMappings,
              ),
              SizedBox(
                height: 90,
                child: ClimbInfoBox(margin: _margin, climbs: _climbs),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
