import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/filemgr.dart';

class NRGEndgameTagSelector extends StatefulWidget {
  final List<String> possibleTags;
  final String jsonKey = "tags";

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

  String get _jsonKey => widget.jsonKey;
  List<String> get _possibleTags => widget.possibleTags;

  List<String> selectedTags = List<String>.empty(growable: true);

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _serializeData();
  }

  void _serializeData() {
    DataEntry.exportData[_jsonKey] = selectedTags;
  }

  void showTagSelector(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Constants.pastelWhite,
                borderRadius: BorderRadius.circular(Constants.borderRadius),
              ),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                constraints: BoxConstraints(minHeight: 100),
                decoration: BoxDecoration(
                  color: Constants.coolGray,
                  borderRadius: BorderRadius.circular(Constants.borderRadius),
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: getPossibleTags(),
                  ),
                ),
              ),
            ),
          );
        }).then((dynamic result) {
      setState(() {});
    });
  }

  List<Tag> getTagsFromData() {
    List<Tag> tags = List.empty(growable: true);
    for (String name in selectedTags) {
      tags.add(Tag(color: Constants.pastelGreenSuperDark, name: name));
    }
    return tags;
  }

  List<SelectableTag> getPossibleTags() {
    List<SelectableTag> tags = List.empty(growable: true);
    for (String name in _possibleTags) {
      tags.add(SelectableTag(name: name, selectedTags: selectedTags,));
    }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Constants.pastelWhite,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              showTagSelector(context);
            },
            child: Container(
                width: double.infinity,
                height: 125.0, // change this based on how many tags there are
                constraints: BoxConstraints(
                  minHeight: 100.0,
                ),
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Constants.coolGray,
                  borderRadius: BorderRadius.circular(Constants.borderRadius),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: getTagsFromData(),
                    ),
                  ),
                )),
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
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      child: Text(
        name,
        style: comfortaaBold(15),
      ),
    );
  }
}

class SelectableTag extends StatefulWidget {
  final String name;
  final List<String> selectedTags;

  const SelectableTag({super.key, required this.name, required this.selectedTags});

  @override
  State<StatefulWidget> createState() => SelectableTagState();
}

class SelectableTagState extends State<SelectableTag> {
  Color color = Constants.darkModeDarkGray;
  String get _name => widget.name;
  List<String> get _selectedTags => widget.selectedTags;

  @override
  Widget build(BuildContext context) {
    if (_selectedTags.contains(_name)) {
      color = Constants.pastelGreenSuperDark;
    } else {
      color = Constants.darkModeDarkGray;
    }
    return GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          setState(() {
            if (_selectedTags.contains(_name)) {
              _selectedTags.remove(_name);
            } else {
              _selectedTags.add(_name);
            }
          });
        },
        child: Tag(color: color, name: _name));
  }
}
