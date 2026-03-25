import "dart:collection";
import "dart:convert";

import "package:auto_size_text/auto_size_text.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
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
    this.subInfo = "",
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
              initialPath: auto["path"],
            ),
          ),
          Expanded(
              flex: 2,
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
                  color: Constants.pastelBrown,
                ),
              ),
              Text(
                "Frequency",
                textAlign: TextAlign.center,
                style: comfortaaBold(
                  17,
                  color: Constants.pastelBrown,
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
                      mapColor: Constants.pastelGray,
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
                      mapColor: Constants.pastelGray,
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

  // General
  String? _teamName;
  int _matches = 0;

  // Tags
  Map<String, List<String>> _tags = {};

  // Pit
  double _weight = 0;
  int _capacity = 0;
  String _shooterType = "";
  String _accessType = "";
  String _drivetrain = "";

  // Accuracy
  double _averageAccuracy = 0;

  double _averageDefendedAccuracy = 0;

  // Feeding
  double _feedingPercentage = 0;
  String _feedingMetric = "";

  double _shootingPercentage = 0;
  String _shootingMetric = "";
  List<MetricMatch> _shootingMatches = [];

  double _herdingPercentage = 0;
  String _herdingMetric = "";
  List<MetricMatch> _herdingMatches = [];

  // Defense
  double _defensePercentage = 0;
  String _defenseMetric = "";

  double _accessPercentage = 0;
  String _accessMetric = "";
  List<MetricMatch> _accessMatches = [];

  double _centerPercentage = 0;
  String _centerMetric = "";
  List<MetricMatch> _centerMatches = [];

  double _alliancePercentage = 0;
  String _allianceMetric = "";
  List<MetricMatch> _allianceMatches = [];

  double _stealingPercentage = 0;
  String _stealingMetric = "";
  List<MetricMatch> _stealingMatches = [];

  // Autos
  List<Map<String, dynamic>> _autos = [];

  // Endgame
  List<Climb> _climbs = [];
  List<Comment> _comments = [];

  // Mappings
  Map<String, double?> _accuracyMappings = {};
  Map<String, double?> _frequencyMappings = {};

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

  Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (e) {
        return null;
      }
    }
    return null;
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

  double _accuracyMetricToNormalized(double accuracy) {
    return (accuracy - 1) / 2;
  }

  double _accuracyMetricToPercentage(double accuracy) {
    return accuracy / 3;
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
    if (value > 0.34) {
      return "Great";
    } else if (value < -0.34) {
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

  Widget _getMatchesWidgetList(List<MetricMatch> matches) {
    return Wrap(
      spacing: _margin,
      runSpacing: _margin,
      children: matches
          .map(
            (match) => DefaultContainer(
              margin: _margin,
              color: match.metric == "Great"
                  ? Constants.pastelGreen
                  : (match.metric == "Decent"
                      ? Constants.pastelYellow
                      : Constants.pastelRed),
              child: Text(
                match.match,
                style: comfortaaBold(17, color: Constants.pastelBrown),
              ),
            ),
          )
          .toList(),
    );
  }

  String _doubleToPercentageString(double value) {
    return "${(value * 100).toStringAsFixed(2)}%";
  }

  int _matchToIdentifier(String shortenedMatch) {
    int value = 0;
    switch (shortenedMatch[0]) {
      case "Q":
        value += 1000;
        break;
      case "P":
        if (shortenedMatch == "Pit") break;
        value += 2000;
        break;
      case "F":
        value += 3000;
        break;
      default:
        break;
    }
    value += _toInt(shortenedMatch.substring(1)) ?? 0;
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

    // Tags
    _tags = {};

    // Pit
    _weight = 0;
    _capacity = 0;
    _shooterType = "";
    _accessType = "";
    _drivetrain = "";

    // Accuracy
    _averageAccuracy = 0;
    double totalAccuracy = 0;
    int accuracyMeasureCount = 0;

    _averageDefendedAccuracy = 0;
    double totalDefendedAccuracy = 0;
    int defendedAccuracyCount = 0;

    // Feeding
    _feedingPercentage = 0;
    _feedingMetric = "";
    int feedingCount = 0;
    double totalFeedingMetric = 0;

    _shootingPercentage = 0;
    _shootingMetric = "";
    _shootingMatches = [];
    double totalShootingMetric = 0;

    _herdingPercentage = 0;
    _herdingMetric = "";
    _herdingMatches = [];
    double totalHerdingMetric = 0;

    // Defense
    _defensePercentage = 0;
    _defenseMetric = "";
    int defenseCount = 0;
    double totalDefenseMetric = 0;

    _accessPercentage = 0;
    _accessMetric = "";
    _accessMatches = [];
    double totalAccessMetric = 0;

    _centerPercentage = 0;
    _centerMetric = "";
    _centerMatches = [];
    double totalCenterMetric = 0;

    _alliancePercentage = 0;
    _allianceMetric = "";
    _allianceMatches = [];
    double totalAllianceMetric = 0;

    _stealingPercentage = 0;
    _stealingMetric = "";
    _stealingMatches = [];
    double totalStealingMetric = 0;

    // Autos
    _autos = [];

    // Endgame
    _climbs = [];
    _comments = [];

    // Mappings
    _accuracyMappings = {};
    _frequencyMappings = {};

    List<String> scoringRegions = [
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
    Map<String, List<double>> accuracyPerRegion = {
      for (var e in scoringRegions) e: []
    };
    Map<String, int> frequencyPerRegion = {for (var e in scoringRegions) e: 0};
    _accuracyMappings = {};
    _frequencyMappings = {};

    if (!_teams.contains(team)) return false;

    _setTeamNameWithNumber(team);

    for (Map<String, dynamic> entry in _pitData) {
      int? curTeam = _toInt(entry["teamNumber"]);
      if (curTeam == null) continue;

      if (team == curTeam) {
        _capacity = _toInt(entry["fuelCapacity"]) ?? -1;
        _shooterType = _toString(entry["shooterType"]);
        _accessType =
            ["able", "preferred"].contains(_toString(entry["canGoTrench"]))
                ? "Trench"
                : "Bump";
        _drivetrain = _toString(entry["drivetrain"]);
        _weight = _toDouble(entry["weight"]) ?? 0;

        int i = 1;
        while (true) {
          if (!_isEmpty(entry["autoPath$i"]) &&
              entry["autoPath$i"] is Map<String, dynamic> &&
              !_isEmpty(entry["autoPath$i"]!["path"])) {
            _autos.add({
              "scouterName": "",
              "rating": _toDouble(entry["dataQuality"]) ?? 0,
              "match": "Pit",
              "attemptedClimb": entry["autoPath$i"]!["attemptedClimb"],
              "climbSuccessful": false,
              "path": _toList(entry["autoPath$i"]!["path"]),
            });
            i++;
          } else {
            break;
          }
        }
      }
    }

    for (Map<String, dynamic> entry in _atlasData) {
      int? curTeam = _toInt(entry["teamNumber"]);
      if (curTeam == null) continue;

      if (team == curTeam) {
        String shortenedMatch = _shortenMatch(
            _toString(entry["matchType"]), _toInt(entry["matchNumber"]) ?? 0);

        _matches++;

        // Tags
        if (entry["tags"] != null) {
          List<dynamic> curTags = _toList(entry["tags"])!;
          for (dynamic tag in curTags) {
            if (tag is! String) continue;

            if (!_tags.keys.contains(tag)) _tags[tag] = [];
            _tags[tag]!.add(shortenedMatch);
          }
        }

        // Comments
        if (!_isEmpty(entry["comments"])) {
          _comments.add(Comment(
            author: _toString(entry["scouterName"]),
            rating: _toDouble(entry["dataQuality"]) ?? 0,
            body: _toString(entry["comments"]),
            match: shortenedMatch,
          ));
        }

        // Auto
        if (!_isEmpty(entry["autoPath"]) &&
            entry["autoPath"] is Map<String, dynamic>) {
          _autos.add({
            "scouterName": _toString(entry["scouterName"]),
            "rating": _toDouble(entry["dataQuality"]) ?? 0,
            "match": shortenedMatch,
            "attemptedClimb": entry["autoPath"]!["attemptedClimb"],
            "climbSuccessful": entry["autoPath"]!["climbSuccessful"],
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

        // Climb
        if (!_isEmpty(entry["climb"]) &&
            entry["climb"] is Map<String, dynamic> &&
            entry["climb"]!["attempted"] == true) {
          _climbs.add(Climb(
              level: ClimbLevelExtension.getLevelFromName(
                  entry["climb"]!["level"]),
              time: _toDouble(entry["climb"]!["startTime"])));
        }

        // Accuracy & Frequency Maps
        if (!_isEmpty(entry["scoringLocations"]) &&
            entry["scoringLocations"] is Map<String, dynamic>) {
          for (String region in scoringRegions) {
            if (entry["scoringLocations"]![region] is! List<dynamic>) continue;
            for (dynamic item
                in _toList(entry["scoringLocations"]![region]) ?? []) {
              double? value = _toDouble(item);
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
        if (_toMap(entry["isHerding"])?["isChecked"] == true ||
            _toMap(entry["isFeeding"])?["isChecked"] == true) {
          feedingCount++;
        }

        temp = _toMap(entry["isHerding"]);
        if (temp?["isChecked"] == true) {
          _herdingMatches.add(MetricMatch(
              match: shortenedMatch, metric: _toString(temp?["selection"])));
          totalHerdingMetric += _metricToValue(_toString(temp?["selection"]));
        }

        temp = _toMap(entry["isFeeding"]);
        if (temp?["isChecked"] == true) {
          _shootingMatches.add(MetricMatch(
              match: shortenedMatch, metric: _toString(temp?["selection"])));
          totalShootingMetric += _metricToValue(_toString(temp?["selection"]));
        }

        totalFeedingMetric = totalHerdingMetric + totalShootingMetric;

        // Defense
        if (_toMap(entry["isAccessDefending"])?["isChecked"] == true ||
            _toMap(entry["isCenterDefending"])?["isChecked"] == true ||
            _toMap(entry["isAllianceDefending"])?["isChecked"] == true ||
            _toMap(entry["isStealing"])?["isChecked"] == true) {
          defenseCount++;
        }

        temp = _toMap(entry["isAccessDefending"]);
        if (temp?["isChecked"] == true) {
          _accessMatches.add(MetricMatch(
              match: shortenedMatch, metric: _toString(temp?["selection"])));
          totalAccessMetric += _metricToValue(_toString(temp?["selection"]));
        }

        temp = _toMap(entry["isCenterDefending"]);
        if (temp?["isChecked"] == true) {
          _centerMatches.add(MetricMatch(
              match: shortenedMatch, metric: _toString(temp?["selection"])));
          totalCenterMetric += _metricToValue(_toString(temp?["selection"]));
        }

        temp = _toMap(entry["isAllianceDefending"]);
        if (temp?["isChecked"] == true) {
          _allianceMatches.add(MetricMatch(
              match: shortenedMatch, metric: _toString(temp?["selection"])));
          totalAllianceMetric += _metricToValue(_toString(temp?["selection"]));
        }

        temp = _toMap(entry["isStealing"]);
        if (temp?["isChecked"] == true) {
          _stealingMatches.add(MetricMatch(
              match: shortenedMatch, metric: _toString(temp?["selection"])));
          totalStealingMetric += _metricToValue(_toString(temp?["selection"]));
        }

        totalDefenseMetric = totalAccessMetric +
            totalCenterMetric +
            totalAllianceMetric +
            totalStealingMetric;
      }
    }

    // Autos and Comments
    _autos.sort((a, b) => _compareMatches(b["match"] ?? "", a["match"] ?? ""));
    _comments.sort((a, b) => _compareMatches(b.match, a.match));

    // TODO: Holy copy paste code. I will make this better when I have time.

    // Accuracy & Defended accuracy
    _averageAccuracy =
        zeroSafeDivision(totalAccuracy, accuracyMeasureCount.toDouble());
    _averageDefendedAccuracy = zeroSafeDivision(
        totalDefendedAccuracy, defendedAccuracyCount.toDouble());

    // % Defense
    _defensePercentage =
        zeroSafeDivision(defenseCount.toDouble(), _matches.toDouble());
    _defenseMetric = defenseCount == 0
        ? "No Data"
        : _valueToMetric(
            zeroSafeDivision(totalDefenseMetric, defenseCount.toDouble()));

    _stealingPercentage = zeroSafeDivision(
        _stealingMatches.length.toDouble(), _matches.toDouble());
    _stealingMetric = _stealingMatches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalStealingMetric, _stealingMatches.length.toDouble()));

    _centerPercentage =
        zeroSafeDivision(_centerMatches.length.toDouble(), _matches.toDouble());
    _centerMetric = _centerMatches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalCenterMetric, _centerMatches.length.toDouble()));

    _alliancePercentage = zeroSafeDivision(
        _allianceMatches.length.toDouble(), _matches.toDouble());
    _allianceMetric = _allianceMatches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalAllianceMetric, _allianceMatches.length.toDouble()));

    _accessPercentage =
        zeroSafeDivision(_accessMatches.length.toDouble(), _matches.toDouble());
    _accessMetric = _accessMatches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalAccessMetric, _accessMatches.length.toDouble()));

    // % Feeding
    _feedingPercentage =
        zeroSafeDivision(feedingCount.toDouble(), _matches.toDouble());
    _feedingMetric = feedingCount == 0
        ? "No Data"
        : _valueToMetric(
            zeroSafeDivision(totalFeedingMetric, feedingCount.toDouble()));

    _shootingPercentage = zeroSafeDivision(
        _shootingMatches.length.toDouble(), _matches.toDouble());
    _shootingMetric = _shootingMatches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalShootingMetric, _shootingMatches.length.toDouble()));

    _herdingPercentage = zeroSafeDivision(
        _herdingMatches.length.toDouble(), _matches.toDouble());
    _herdingMetric = _herdingMatches.isEmpty
        ? "No Data"
        : _valueToMetric(zeroSafeDivision(
            totalHerdingMetric, _herdingMatches.length.toDouble()));

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
                      child: PopupInfoBox(
                        title: "Weight (lb)",
                        info: _weight.toStringAsFixed(1),
                        subInfo: "with bumpers",
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: _margin,
                          mainAxisSpacing: _margin,
                          childAspectRatio: 1.4,
                          children: [
                            InfoBox(info: _shooterType, title: "Shooter Type"),
                            InfoBox(info: "$_capacity", title: "Capacity"),
                            InfoBox(info: _accessType, title: "Neutral Access"),
                            InfoBox(info: _drivetrain, title: "Drivetrain"),
                            InfoBox(
                                info:
                                    _doubleToPercentageString(_averageAccuracy),
                                title: "Avg. Accuracy"),
                            InfoBox(
                                info: _doubleToPercentageString(
                                    _averageDefendedAccuracy),
                                title: "Defended Avg. Acc"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: PopupInfoBox(
                        title: "% Feeding",
                        info: _doubleToPercentageString(_feedingPercentage),
                        subInfo: _feedingMetric,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: _margin,
                          mainAxisSpacing: _margin,
                          childAspectRatio: 1.4,
                          children: [
                            PopupInfoBox(
                              info: _doubleToPercentageString(
                                  _shootingPercentage),
                              title: "Shooting",
                              subInfo: _shootingMetric,
                              child: _getMatchesWidgetList(_shootingMatches),
                            ),
                            PopupInfoBox(
                              info:
                                  _doubleToPercentageString(_herdingPercentage),
                              title: "Herding",
                              subInfo: _herdingMetric,
                              child: _getMatchesWidgetList(_herdingMatches),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: PopupInfoBox(
                        title: "% Defending",
                        info: _doubleToPercentageString(_defensePercentage),
                        subInfo: _defenseMetric,
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: _margin,
                          mainAxisSpacing: _margin,
                          childAspectRatio: 1.4,
                          children: [
                            PopupInfoBox(
                              info:
                                  _doubleToPercentageString(_accessPercentage),
                              title: "Trench / Bump",
                              subInfo: _accessMetric,
                              child: _getMatchesWidgetList(_accessMatches),
                            ),
                            PopupInfoBox(
                              info:
                                  _doubleToPercentageString(_centerPercentage),
                              title: "Neutral Zone",
                              subInfo: _centerMetric,
                              child: _getMatchesWidgetList(_centerMatches),
                            ),
                            PopupInfoBox(
                              info: _doubleToPercentageString(
                                  _alliancePercentage),
                              title: "Alliance Zone",
                              subInfo: _allianceMetric,
                              child: _getMatchesWidgetList(_allianceMatches),
                            ),
                            PopupInfoBox(
                              info: _doubleToPercentageString(
                                  _stealingPercentage),
                              title: "Stealing",
                              subInfo: _stealingMetric,
                              child: _getMatchesWidgetList(_stealingMatches),
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
