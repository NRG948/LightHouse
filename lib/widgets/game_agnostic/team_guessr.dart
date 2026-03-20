import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/widgets/game_agnostic/default_container.dart';

class TeamGuessr extends StatefulWidget {
  const TeamGuessr({super.key});

  @override
  State<TeamGuessr> createState() => _TeamGuessrState();
}

class _TeamGuessrState extends State<TeamGuessr>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _controller = TextEditingController();
  final Map<String, int> _memo = {};

  Set<int> teams = {};
  int? _currentTeamNumber;
  String? _currentTeamName;
  bool _isCorrect = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _setTeamsInEvent();
    await _nextQuestion();
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _nextQuestion() async {
    if (teams.isEmpty) return;

    int newNum = _getRandomTeam();
    String? name = await _getTeamNameFromNumber(newNum);

    if (mounted) {
      setState(() {
        _currentTeamNumber = newNum;
        _currentTeamName = name;
        _isCorrect = false;
        _controller.clear();
      });
    }
  }

  void _handleCheck() {
    if (_currentTeamName == null || _controller.text.isEmpty) return;

    bool correct = _checkString(_controller.text, _currentTeamName!, 0.2);

    if (correct) {
      setState(() => _isCorrect = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _nextQuestion();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Try again!"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  int _getRandomTeam() {
    return teams.sample(1).first;
  }

  bool _checkString(String input, String key, double percentError) {
    input = _getCleanString(input);
    key = _getCleanString(key);
    
    _memo.clear();

    if (input == key) return true;

    int allowedErrors = (key.length * percentError).floor();
    int distance = _levenshtein(input, key, input.length, key.length);

    return distance <= allowedErrors;
  }

  int _levenshtein(String s1, String s2, int m, int n) {
    final String key = "$m-$n";
    if (_memo.containsKey(key)) return _memo[key]!;

    if (m == 0) return n;
    if (n == 0) return m;

    int res;
    if (s1[m - 1] == s2[n - 1]) {
      res = _levenshtein(s1, s2, m - 1, n - 1);
    } else {
      res = 1 +
          min(
            _levenshtein(s1, s2, m, n - 1),
            min(
              _levenshtein(s1, s2, m - 1, n),
              _levenshtein(s1, s2, m - 1, n - 1),
            ),
          );
    }

    _memo[key] = res;
    return res;
  }

  String _getCleanString(String word) {
    return word
        .toLowerCase()
        .replaceAll(RegExp(r'\(.*?\)|".*?"'), '')
        .replaceAll(RegExp(r'the', caseSensitive: false), '')
        .replaceAll(RegExp(r'[ \-]'), '')
        .replaceFirst(RegExp(r's$'), '');
  }

  Future<void> _setTeamsInEvent() async {
    try {
      String eventKey = configData["eventKey"] ?? "";
      String content = await loadTBAFile(eventKey, "matches");
      
      dynamic matchData = jsonDecode(content);

      if (configData["downloadTheBlueAllianceInfo"] == "true" && 
          matchData is List && 
          matchData.isNotEmpty) {
        
        Set<int> fetchedTeams = {};
        for (var match in matchData) {
          for (String alliance in ["red", "blue"]) {
            var teamKeys = match["alliances"][alliance]["team_keys"];
            for (String team in teamKeys) {
              fetchedTeams.add(int.parse(team.substring(3)));
            }
          }
        }
        teams = fetchedTeams;
      }
    } catch (e) {
      debugPrint("Error loading teams: $e");
    }
  }

  Future<String?> _getTeamNameFromNumber(int teamNumber) async {
    try {
      int rangeStart = (teamNumber ~/ 500) * 500;
      int rangeEnd = rangeStart + 500;
      String path = "assets/text/teams$rangeStart-$rangeEnd.txt";
      
      String content = await rootBundle.loadString(path);
      List<dynamic> teamPage = jsonDecode(content);

      for (var teamObject in teamPage) {
        if (teamObject["key"] == "frc$teamNumber") {
          return teamObject["nickname"];
        }
      }
    } catch (e) {
      debugPrint("Error finding team name: $e");
    }
    return "Unknown Team";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultContainer(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Team Number:",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              "$_currentTeamNumber",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _controller,
              enabled: !_isCorrect,
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "What's their name?",
                filled: true,
                suffixIcon: _isCorrect
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _handleCheck(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isCorrect ? null : _handleCheck,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(_isCorrect ? "Correct!" : "Check Answer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}