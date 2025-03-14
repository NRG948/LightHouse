import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

class NRGCommentBox extends StatefulWidget {
  final String title; // Title of the comment box
  final String jsonKey; // Key to store the comment box data in JSON
  final double height; // Height of the comment box
  final double width; // Width of the comment box

  const NRGCommentBox(
      {super.key,
      required this.title,
      required this.jsonKey,
      required this.height,
      required this.width});

  @override
  State<NRGCommentBox> createState() => _NRGCommentBoxState();
}

class _NRGCommentBoxState extends State<NRGCommentBox>
    with AutomaticKeepAliveClientMixin {
  CommentBoxSharedState state = CommentBoxSharedState();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    DataEntry.exportData[widget.jsonKey] = "";
    state.addListener(() => build(context));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return CommentBoxDialog(jsonKey: widget.jsonKey, state: state);
            });
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            color: Constants.pastelWhite),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              color: Constants.pastelYellow,
            ),
            child: DataEntry.exportData[widget.jsonKey] == "" ? Center(
                child: Text(
              "Comments",
              style: comfortaaBold(35, color: Colors.black),
            )) : Column(
              children: [
                Text("Comments",style: comfortaaBold(20,color: Colors.black),),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child: AutoSizeText(DataEntry.exportData[widget.jsonKey],maxLines: 2,minFontSize: 12,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommentBoxDialog extends StatefulWidget {
  final String jsonKey;
  final CommentBoxSharedState state;
  const CommentBoxDialog(
      {super.key, required this.jsonKey, required this.state});

  @override
  State<CommentBoxDialog> createState() => _CommentBoxDialogState();
}

class _CommentBoxDialogState extends State<CommentBoxDialog> {
  late double screenHeight;
  late double screenWidth;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();

    controller.text = DataEntry.exportData[widget.jsonKey];

    controller.addListener(() {
      widget.state.update();
      DataEntry.exportData[widget.jsonKey] = controller.text;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 25, right: 25, top: 50, bottom: 200),
      child: Center(
        child: Container(
          width: screenWidth * 0.9,
          height: screenHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              color: Constants.pastelWhite),
          child: Column(
            children: [
              Text(
                "COMMENTS",
                style: comfortaaBold(screenWidth * 0.1, color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Constants.pastelYellow,
                    filled: true,
                    labelStyle: comfortaaBold(screenWidth * 0.03),
                  ),
                  maxLines: 19,
                ),
              )
            ],
          ),
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
