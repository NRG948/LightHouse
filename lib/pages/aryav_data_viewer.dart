import "dart:collection";
import "dart:convert";

import "package:auto_size_text/auto_size_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/widgets/game_agnostic/default_container.dart";
import "package:lighthouse/widgets/game_agnostic/dropdown.dart";
import 'package:just_the_tooltip/just_the_tooltip.dart';
import "package:lighthouse/widgets/game_agnostic/star_display.dart";
import "package:lighthouse/widgets/rebuilt/rebuilt_auto_path_selector.dart";
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
            style: comfortaaBold(17, color: Constants.pastelBrown),
          ),
        ),
        backgroundColor: Constants.pastelWhite,
        triggerMode: TooltipTriggerMode.tap,
        borderRadius: BorderRadius.circular(_margin),
        child: DefaultContainer(
          color: Constants.pastelRedDark,
          child: Text("${matches.length} $name", style: comfortaaBold(13)),
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
          print(_isExpanded);
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
                            color: Constants.pastelBrown,
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

class InfoBox extends StatelessWidget {
  final String title;
  final String info;
  final String subInfo;
  final Function(TapUpDetails details)? onTap;

  const InfoBox({
    super.key,
    required this.title,
    required this.info,
    required this.subInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: onTap,
      child: DefaultContainer(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: AutoSizeText(
                  title,
                  style: comfortaaBold(10, color: Constants.pastelBrown),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: AutoSizeText(
                  info,
                  style: comfortaaBold(30, color: Constants.pastelBrown),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: AutoSizeText(
                  subInfo,
                  style: comfortaaBold(10, color: Constants.pastelBrown),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoPreview extends StatefulWidget {
  /// Auto information.
  ///
  /// Formatted as an array containing maps:
  /// ```dart
  /// {
  ///   "scouterName": String,
  ///   "rating": float,
  ///   "match": String,
  ///   "attemptedClimb": bool,
  ///   "climbSuccessful": bool,
  ///   "fuelScored": double,
  ///   "path": List<String>,
  /// }
  /// ```
  final List<Map<String, dynamic>> autoData;
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
  List<Map<String, dynamic>> get _autoData => widget.autoData;
  double get _margin => widget.margin;

  Widget _getAutoPreview(Map<String, dynamic> auto) {
    String scouterName = auto["scouterName"] ?? "Unknown";
    double rating = auto["rating"] ?? 0;
    String match = auto["match"] ?? "";
    bool attemptedClimb = auto["attemptedClimb"] ?? false;
    bool climbResult = auto["climbSuccessful"] ?? false;
    double estTotalFuelScored = auto["fuelScored"] ?? 0;

    return DefaultContainer(
      margin: _margin / 3,
      child: Row(
        spacing: _margin,
        children: [
          Expanded(
            child: RebuiltAutoPathSelector(
              margin: 0,
              viewOnly: true,
              initialPath: auto["path"],
            ),
          ),
          Expanded(
              child: Column(
            spacing: _margin,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StarDisplay(starRating: rating),
              AutoSizeText(
                "$scouterName  $match",
                textAlign: TextAlign.left,
                style: comfortaaBold(17, color: Constants.pastelBrown),
              ),
              AutoSizeText(
                "Fuel Scored: $estTotalFuelScored",
                style: comfortaaBold(17, color: Constants.pastelBrown),
              ),
              if (attemptedClimb)
                AutoSizeText(
                  "Climb Attempted: ${climbResult ? "Successful" : "Unsuccessful"}",
                  style: comfortaaBold(17, color: Constants.pastelBrown),
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
        color: Constants.pastelRed,
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

  const Comment({
    required this.rating,
    required this.author,
    required this.body,
    required this.match,
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
      color: Constants.pastelWhite,
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
                    color: Constants.pastelBrown,
                    customFontWeight: FontWeight.w900),
                maxLines: 1,
              ),
              StarDisplay(starRating: comment.rating),
            ],
          ),
          Text(
            comment.body,
            style: comfortaaBold(14, color: Constants.pastelBrown),
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
        color: Constants.pastelYellow,
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
                  style: comfortaaBold(10, color: Constants.pastelBrown),
                ),
                DefaultContainer(
                  color: Constants.pastelGrayDark,
                  child: AutoSizeText(
                    "${data.autoSuccessfulClimbs.toInt()} / ${data.autoClimbs.toInt()}",
                    style: comfortaaBold(18,
                        color: Constants.pastelWhite,
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
                  style: comfortaaBold(10, color: Constants.pastelBrown),
                ),
                DefaultContainer(
                  color: Constants.pastelGrayDark,
                  child: AutoSizeText(
                    "${data.endgameSucessfulClimbs.toInt()} / ${data.endgameClimbs.toInt()}",
                    style: comfortaaBold(18,
                        color: Constants.pastelWhite,
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
                  style: comfortaaBold(10, color: Constants.pastelBrown),
                ),
                Row(
                  spacing: margin / 2,
                  children: [
                    Expanded(
                      child: DefaultContainer(
                        margin: margin,
                        color: Constants.pastelGreen,
                        child: AutoSizeText(
                          "${data.level1.toInt()}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: comfortaaBold(
                            18,
                            color: Constants.pastelWhite,
                            customFontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DefaultContainer(
                        margin: margin,
                        color: Constants.pastelBlue,
                        child: AutoSizeText(
                          "${data.level2.toInt()}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: comfortaaBold(
                            18,
                            color: Constants.pastelWhite,
                            customFontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DefaultContainer(
                        margin: margin,
                        color: Constants.pastelRed,
                        child: AutoSizeText(
                          "${data.level3.toInt()}",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: comfortaaBold(
                            18,
                            color: Constants.pastelWhite,
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

class RobotStatistics {
  int teamNumber;

  double totalAccuracy;
  double accuracyCycles;

  int capacity;

  double totalTimeScoring;
  double matches;

  double totalCycles;
  double totalActiveShifts;

  double
      fuelPerShift; // capacity * (capacityFactor / totalCycles) * totalCycles / totalActiveShifts
  double totalCapacityFactor;

  double totalAutoCapacityFactor;

  RobotStatistics({
    required this.teamNumber,
    this.totalAccuracy = 0,
    this.accuracyCycles = 0,
    this.capacity = 0,
    this.totalTimeScoring = 0,
    this.matches = 0,
    this.totalCycles = 0,
    this.totalActiveShifts = 0,
    this.fuelPerShift = 0,
    this.totalCapacityFactor = 0,
    this.totalAutoCapacityFactor = 0,
  });
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

  Map<String, List<String>> _tags = {};

  double _fuelPerShift = -1;
  int _fuelPerShiftRank = -1;

  double _averageAccuracy = -1;
  int _averageAccuracyRank = -1;

  int _capacity = -1;
  int _capacityRank = -1;

  double _timeScoring = -1;
  int _timeScoringRank = -1;

  double _cyclesPerShift = -1;
  int _cyclesPerShiftRank = -1;

  double _feedingPercentage = -1;
  String _feedingMetric = "";
  List<MetricMatch> _feedingMatches = [];

  double _defensePercentage = -1;
  String _defenseMetric = "";
  List<MetricMatch> _defenseMatches = [];

  List<Map<String, dynamic>> _autos = [];

  List<Climb> _climbs = [];

  List<Comment> _comments = [];

  int? _toInt(dynamic value) {
    if (value == null) return null;

    String cleanValue = value.toString().replaceAll(RegExp(r'\s+'), '');

    if (cleanValue.isEmpty) return null;

    return double.tryParse(cleanValue)?.toInt();
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;

    String cleanValue = value.toString().replaceAll(' ', '');

    if (cleanValue.isEmpty) return null;

    bool isPercent = cleanValue.endsWith('%');

    if (isPercent) {
      cleanValue = cleanValue.replaceAll('%', '');
      double? parsed = double.tryParse(cleanValue);

      return (parsed != null) ? parsed / 100 : null;
    }

    return double.tryParse(cleanValue);
  }

  List<dynamic>? _toList(dynamic value) {
    if (value is List) return value;
    if (value is Iterable) return value.toList();
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) return decoded;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  String _toString(dynamic value) {
    if (value == null) return "";

    String result = value.toString();
    if (result.toLowerCase() == "null") return "";

    return result;
  }

  bool _isEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) return value.trim().isEmpty;
    if (value is Iterable) return value.isEmpty;
    if (value is Map) return value.isEmpty;

    return false;
  }

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

  double _accuracyMetricConverter(double accuracy) {
    return (accuracy + 1) / 6;
  }

  double zeroSafeDivision(double dividend, double divisor) {
    return divisor == 0 ? 0 : dividend / divisor;
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
      debugPrint(e.toString());
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

  bool _loadData(int team) {
    _atlasData = _getDataAsMapFromDatabase("Atlas");
    _pitData = _getDataAsMapFromDatabase("Pit");
    _teams = _getTeamsInDatabase();

    _tags = {};

    _fuelPerShift = -1;
    _fuelPerShiftRank = -1;

    _averageAccuracy = -1;
    _averageAccuracyRank = -1;

    _capacity = -1;
    _capacityRank = -1;

    _timeScoring = -1;
    _timeScoringRank = -1;

    _cyclesPerShift = -1;
    _cyclesPerShiftRank = -1;

    _feedingPercentage = -1;
    _feedingMetric = "";
    _feedingMatches = [];

    _defensePercentage = -1;
    _defenseMetric = "";
    _defenseMatches = [];

    _autos = [];

    _climbs = [];

    _comments = [];

    if (!_teams.contains(team)) return false;

    debugPrint(_atlasData.toString(), wrapWidth: 100);
    debugPrint(_pitData.toString());

    _setTeamNameWithNumber(team);

    Map<int, RobotStatistics> robotStats = {
      for (int t in _teams) t: RobotStatistics(teamNumber: t)
    };

    for (Map<String, dynamic> entry in _pitData) {
      int? curTeam = _toInt(entry["teamNumber"]);
      if (curTeam == null) continue;
      if (robotStats[curTeam] == null) continue;

      RobotStatistics curStats = robotStats[curTeam]!;

      curStats.capacity = _toInt(entry["fuelCapacity"]) ?? -1;
    }

    for (Map<String, dynamic> entry in _atlasData) {
      int? curTeam = _toInt(entry["teamNumber"]);
      if (curTeam == null) continue;
      if (robotStats[curTeam] == null) continue;

      RobotStatistics curStats = robotStats[curTeam]!;
      String shortenedMatch = _shortenMatch(
          _toString(entry["matchType"]), _toInt(entry["matchNumber"]) ?? 0);

      curStats.matches++;

      List<String> cycleShifts = [
        "autoCycles",
        "transitionOnshiftCycles",
        "firstOnshiftCycles",
        "secondOnshiftCycles",
      ];
      for (String cycleShift in cycleShifts) {
        if (_toList(entry[cycleShift]) == null) continue;

        List<dynamic> cycles = _toList(entry[cycleShift])!;

        curStats.accuracyCycles += cycles.length;
        curStats.totalAccuracy += cycles.fold(
            0.0,
            (sum, item) =>
                sum +
                (_accuracyMetricConverter(_toDouble(item['accuracy']) ?? -1)));
        curStats.totalTimeScoring += cycles.fold(0.0,
            (sum, item) => sum + (_toDouble(item['duration']) ?? 0) / 1000);

        if (cycleShift == cycleShifts[2] || cycleShift == cycleShifts[3]) {
          curStats.totalCapacityFactor += cycles.fold(
              0.0,
              (sum, item) =>
                  sum +
                  (_accuracyMetricConverter(_toDouble(item['accuracy']) ?? 3) *
                      (_toDouble(item['capacity']) ?? 1)));

          curStats.totalCycles += cycles.length;
          curStats.totalActiveShifts += 1;
        }

        if (cycleShift == cycleShifts[0]) {
          curStats.totalAutoCapacityFactor += cycles.fold(
              0.0,
              (sum, item) =>
                  sum +
                  (_accuracyMetricConverter(_toDouble(item['accuracy']) ?? 3) *
                      (_toDouble(item['capacity']) ?? 1)));
        }
      }

      if (team == curTeam) {
        // Tags
        if (entry["tags"] != null) {
          List<dynamic> curTags = _toList(entry["tags"])!;
          for (dynamic tag in curTags) {
            if (tag is! String) continue;

            if (!_tags.keys.contains(tag)) _tags[tag] = [];
            _tags[tag]!.add(shortenedMatch);
          }
        }

        List<String> defenseKeys = [
          "firstOffshiftIsDefending",
          "secondOffshiftIsDefending",
          "transitionOffshiftIsDefending",
          "firstOnshiftIsDefending",
          "secondOnshiftIsDefending",
          "transitionOnshiftIsDefending",
        ];

        for (String key in defenseKeys) {
          if (entry[key] == null || entry[key] is! Map<String, dynamic>) {
            debugPrint(":(");
            continue;
          }
          Map<String, dynamic> metric = entry[key];
          if (metric["isChecked"] == true) {
            _defenseMatches.add(MetricMatch(
                match: shortenedMatch, metric: metric["selection"]));
            break;
          }
        }

        List<String> feedingKeys = [
          "firstOffshiftIsFeeding",
          "secondOffshiftIsFeeding",
          "transitionOffshiftIsFeeding",
          "firstOnshiftIsFeeding",
          "secondOnshiftIsFeeding",
          "transitionOnshiftIsFeeding",
        ];

        for (String key in feedingKeys) {
          if (entry[key] == null || entry[key] is! Map<String, dynamic>) {
            continue;
          }
          Map<String, dynamic> metric = entry[key];
          if (metric["isChecked"] == true) {
            _feedingMatches.add(MetricMatch(
                match: shortenedMatch, metric: metric["selection"]));
            break;
          }
        }

        if (!_isEmpty(entry["comments"])) {
          _comments.add(Comment(
            author: _toString(entry["scouterName"]),
            rating: _toDouble(entry["dataQuality"]) ?? 0,
            body: _toString(entry["comments"]),
            match: shortenedMatch,
          ));
        }

        if (!_isEmpty(entry["autoPath"]) &&
            entry["autoPath"] is Map<String, dynamic>) {
          _autos.add({
            "scouterName": _toString(entry["scouterName"]),
            "rating": _toDouble(entry["dataQuality"]) ?? 0,
            "match": shortenedMatch,
            "attemptedClimb": entry["autoPath"]!["attemptedClimb"],
            "climbSuccessful": entry["autoPath"]!["climbSuccessful"],
            "fuelScored": curStats.totalAutoCapacityFactor * curStats.capacity,
            "path": _toList(entry["autoPath"]!["path"]),
          });

          if (entry["autoPath"]!["attemptedClimb"] == true) {
            _climbs.add(Climb(
                level: entry["autoPath"]!["climbSuccessful"] == true
                    ? ClimbLevel.l1
                    : ClimbLevel.none,
                isAutoClimb: true));
          }
        }

        if (!_isEmpty(entry["climb"]) &&
            entry["climb"] is Map<String, dynamic> &&
            entry["climb"]!["attempted"] == true) {
          _climbs.add(Climb(
              level: ClimbLevelExtension.getLevelFromName(
                  entry["climb"]!["level"]),
              time: _toDouble(entry["climb"]!["startTime"])));
        }
      }
    }

    RobotStatistics curStats = robotStats[team]!;

    // Fuel / Shift
    debugPrint(
        "${curStats.totalCapacityFactor}, ${curStats.capacity}, ${curStats.totalActiveShifts}");
    _fuelPerShift = curStats.totalCapacityFactor *
        curStats.capacity /
        curStats.totalActiveShifts;

    // Capacity
    _capacity = curStats.capacity;

    // Average Accuracy
    _averageAccuracy =
        zeroSafeDivision(curStats.totalAccuracy, curStats.accuracyCycles);

    // Time Scoring
    _timeScoring =
        zeroSafeDivision(curStats.totalTimeScoring, curStats.matches);

    // Cycles / Shift
    _cyclesPerShift =
        zeroSafeDivision(curStats.totalCycles, curStats.totalActiveShifts);

    // % Defense
    _defensePercentage =
        zeroSafeDivision(_defenseMatches.length.toDouble(), curStats.matches);

    // % Feeding
    _feedingPercentage =
        zeroSafeDivision(_feedingMatches.length.toDouble(), curStats.matches);

    // This won't run successfully on init
    setState(() {});

    return true;
  }

  @override
  void initState() {
    super.initState();
    // Get the team number after the first frame because it doesn't work on init.
    _loadData(_teams.firstOrNull ?? -1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _setTeamNameWithNumber(_teams.firstOrNull ?? -1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: configData["theme"] != null
          ? themeColorPalettes[configData["theme"] ?? "Dark"]![0]
          : Constants.pastelRed,
      appBar: AppBar(
        backgroundColor: themeColorPalettes[configData["theme"] ?? "Dark"]![0],
        title: const Text(
          "Aryav's Data Viewer",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: Constants.pastelWhite),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/home-data-viewer");
            },
            icon: Icon(
              Icons.home,
              color: Constants.pastelWhite,
            )),
      ),
      body: Container(
        padding: EdgeInsets.all(_margin),
        child: SingleChildScrollView(
          child: Column(
            spacing: _margin,
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  spacing: _margin,
                  children: [
                    Expanded(
                      flex: 4,
                      child: DefaultContainer(
                        expandVertical: true,
                        margin: _margin,
                        child: CustomDropdown(
                          options: _teams.map((x) => "$x").toList(),
                          color: Constants.pastelYellow,
                          initialValue: _teams.firstOrNull?.toString(),
                          onChanged: (value) {
                            _loadData(
                                _toInt(value) ?? _teams.firstOrNull ?? -1);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: DefaultContainer(
                        expandVertical: true,
                        margin: _margin,
                        child: Center(
                          child: AutoSizeText(
                            _teamName ?? "No team found",
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            style:
                                comfortaaBold(17, color: Constants.pastelBrown),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TagViewer(
                tags: _tags,
                margin: _margin,
                initialHeight: 90,
              ),
              SizedBox(
                height: 100,
                child: Row(
                  spacing: _margin,
                  children: [
                    Expanded(
                      child: InfoBox(
                        title: "Fuel / Shift",
                        info: _fuelPerShift.toStringAsFixed(2),
                        subInfo: "#$_fuelPerShiftRank",
                        onTap: (details) {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return GestureDetector(
                                  onTapUp: (details) {
                                    Navigator.of(context).pop();
                                  },
                                  child: Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: Center(
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            maxHeight: 200),
                                        child: Column(
                                          spacing: _margin,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                spacing: _margin,
                                                children: [
                                                  Expanded(
                                                    child: InfoBox(
                                                      title: "Avg. Accuracy",
                                                      info: _averageAccuracy
                                                          .toStringAsFixed(2),
                                                      subInfo:
                                                          "#$_averageAccuracyRank",
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InfoBox(
                                                      title: "Capacity",
                                                      info:
                                                          _capacity.toString(),
                                                      subInfo:
                                                          "#$_capacityRank",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                spacing: _margin,
                                                children: [
                                                  Expanded(
                                                    child: InfoBox(
                                                      title: "Time Scoring (s)",
                                                      info: _timeScoring
                                                          .toStringAsFixed(2),
                                                      subInfo:
                                                          "#$_timeScoringRank",
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InfoBox(
                                                      title: "Cycles / Shift",
                                                      info: _cyclesPerShift
                                                          .toStringAsFixed(2),
                                                      subInfo:
                                                          "#$_cyclesPerShiftRank",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                    Expanded(
                      child: InfoBox(
                        title: "% Feeding",
                        info: _feedingPercentage.toStringAsFixed(2),
                        subInfo: _feedingMetric,
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
                                    child: Wrap(
                                      spacing: _margin,
                                      runSpacing: _margin,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: InfoBox(
                        title: "% Defending",
                        info: _defensePercentage.toStringAsFixed(2),
                        subInfo: _defenseMetric,
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
                                    child: Wrap(
                                      spacing: _margin,
                                      runSpacing: _margin,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: AutoPreview(
                  margin: _margin,
                  autoData: _autos,
                ),
              ),
              SizedBox(
                height: 90,
                child: ClimbInfoBox(margin: _margin, climbs: _climbs),
              ),
              SizedBox(
                height: 200,
                child: CommentViewer(
                  comments: _comments,
                  margin: _margin,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
