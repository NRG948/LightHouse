import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/themes.dart';
import 'package:lighthouse/widgets/game_agnostic/default_container.dart';

class LeaderboardItem {
  String name;
  int rank;
  int value;

  LeaderboardItem(
      {required this.name, required this.rank, required this.value});
}

class Leaderboard extends StatefulWidget {
  final Map<String, int> statistics;
  final double margin;

  const Leaderboard(
      {super.key, required this.statistics, required this.margin});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  Map<String, int> get _statistics => widget.statistics;
  double get _margin => widget.margin;

  List<LeaderboardItem> _getItemsFromStatistic() {
    List<MapEntry<String, int>> sortedEntries = _statistics.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<LeaderboardItem> items = [];
    int? previousValue;
    int previousIdenticalCount = 0;
    for (int i = 0; i < sortedEntries.length; i++) {
      if (previousValue == sortedEntries[i].value) {
        previousIdenticalCount++;
      } else {
        previousIdenticalCount = 0;
      }
      items.add(LeaderboardItem(
          name: sortedEntries[i].key, rank: i + 1 - previousIdenticalCount, value: sortedEntries[i].value));
      previousValue = sortedEntries[i].value;
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      color: context.colors.container,
      margin: _margin,
      child: DefaultContainer(
        color: context.colors.accent2,
        margin: _margin / 2,
        child: SingleChildScrollView(
          child: Column(
              spacing: _margin / 2,
              children: _getItemsFromStatistic()
                  .map((item) =>
                      LeaderboardPosition(item: item, margin: _margin))
                  .toList()),
        ),
      ),
    );
  }
}

class LeaderboardPosition extends StatelessWidget {
  final LeaderboardItem item;
  final double margin;

  const LeaderboardPosition({
    super.key,
    required this.item,
    required this.margin,
  });

  Color _getColorFromRank(BuildContext context, int rank) {
    switch (rank) {
      case 1:
        return context.colors.accent1;
      case 2:
        return context.colors.accent2;
      case 3:
        return context.colors.accent3;
      default:
        return context.colors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      color: context.colors.container,
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: margin,
            children: [
              IntrinsicHeight(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: DefaultContainer(
                    color: _getColorFromRank(context, item.rank),
                    margin: margin / 2,
                    child: Text(
                      textAlign: TextAlign.center,
                      item.rank.toString(),
                      style: comfortaaBold(17, color: context.colors.container, customFontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
              Text(
                item.name,
                style: comfortaaBold(17, color: context.colors.containerText),
              ),
            ],
          ),
          Text(
            item.value.toString(),
            style: comfortaaBold(17, color: context.colors.containerText),
          ),
        ],
      ),
    );
  }
}
