import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class NRGEndgameTagSelector extends StatefulWidget {
  final List<String> possibleTags;

  /// Creates a generic tag selector widget, with [possibleTags] being
  ///  a list of all tags that a game needs, passed through some game-specific wrapper widget
  const NRGEndgameTagSelector({super.key, required this.possibleTags});

  @override
  State<StatefulWidget> createState() => NRGEndgameTagSelectorState();
}

class NRGEndgameTagSelectorState extends State<NRGEndgameTagSelector>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Constants.pastelWhite,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      child: Column(
        children: [
          Text(
            "Tags",
            style: comfortaaBold(20, color: Constants.black),
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: 100.0,
            ),
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Constants.coolGray,
              borderRadius: BorderRadius.circular(Constants.borderRadius),
            ),
          ),
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final Color color;
  final String name;

  const Tag({super.key, required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
