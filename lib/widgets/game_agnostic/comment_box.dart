import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';

class NRGCommentBox extends StatefulWidget {
  final String title;
  final String jsonKey;
  final double height;
  final double? width;
  final double? margin;

  const NRGCommentBox({
    super.key,
    required this.title,
    required this.jsonKey,
    required this.height,
    this.margin,
    this.width,
  });

  @override
  State<NRGCommentBox> createState() => _NRGCommentBoxState();
}

class _NRGCommentBoxState extends State<NRGCommentBox>
    with AutomaticKeepAliveClientMixin {
  String get _title => widget.title;
  String get _jsonKey => widget.jsonKey;
  double get _height => widget.height;
  double? get _width => widget.width;
  double get _margin => widget.margin ?? 10;

  static const double _collapsedTitleFontSize = 35.0;
  static const double _expandedTitleFontSize = 20.0;
  static const double _minCommentFontSize = 12.0;

  String _storedText = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    DataEntry.exportData[_jsonKey] = "";
  }

  bool get _hasText => DataEntry.exportData[_jsonKey]?.isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: _openDialog,
      child: Container(
        height: _height,
        width: _width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_margin),
          color: Constants.pastelWhite,
        ),
        child: Padding(
          padding: EdgeInsets.all(_margin),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_margin),
              color: Constants.pastelYellow,
            ),
            child: _hasText ? _buildExpanded() : _buildCollapsed(),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsed() {
    return Center(
      child: Text(
        _title,
        style: comfortaaBold(
          _collapsedTitleFontSize,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildExpanded() {
    return Column(
      children: [
        Text(
          _title,
          style: comfortaaBold(
            _expandedTitleFontSize,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _margin,
            ),
            child: SingleChildScrollView(
              child: AutoSizeText(
                _storedText,
                minFontSize: _minCommentFontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (_) => CommentBoxDialog(
        margin: _margin,
        jsonKey: _jsonKey,
        onTextUpdate: (text) {
          setState(() {
            _storedText = text;
          });
        },
      ),
    );
  }
}

class CommentBoxDialog extends StatefulWidget {
  final String jsonKey;
  final Function(String text) onTextUpdate;
  final double margin;

  const CommentBoxDialog({
    super.key,
    required this.jsonKey,
    this.onTextUpdate = _noop,
    required this.margin,
  });

  static void _noop(String text) {}

  @override
  State<CommentBoxDialog> createState() => _CommentBoxDialogState();
}

class _CommentBoxDialogState extends State<CommentBoxDialog> {
  static const double _dialogWidthFactor = 0.9;
  static const double _dialogHeightFactor = 0.5;
  static const double _dialogTitleFontFactor = 0.1;
  static const double _dialogLabelFontFactor = 0.03;
  static const double _maxLinesHeightFactor = 0.014;

  late final TextEditingController _controller;

  String get _jsonKey => widget.jsonKey;
  double get _margin => widget.margin;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: DataEntry.exportData[_jsonKey],
    );

    _controller.addListener(() {
      final text = _controller.text;
      widget.onTextUpdate(text);
      DataEntry.exportData[_jsonKey] = text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final dialogWidth = screenSize.width * _dialogWidthFactor;
    final dialogHeight = screenSize.height * _dialogHeightFactor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_margin),
          color: Constants.pastelWhite,
        ),
        child: Column(
          children: [
            Text(
              "COMMENTS",
              style: comfortaaBold(
                screenSize.width * _dialogTitleFontFactor,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(_margin),
              child: TextField(
                controller: _controller,
                maxLines:
                    (screenSize.height * _maxLinesHeightFactor).truncate(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Constants.pastelYellow,
                  filled: true,
                  labelStyle: comfortaaBold(
                    screenSize.width * _dialogLabelFontFactor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentBoxSharedState extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}
