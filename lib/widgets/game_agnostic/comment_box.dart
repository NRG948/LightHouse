import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({super.key});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.pastelWhite,
      child: Column(
        children: [
          Text(
            "USER PLACEHOLDER",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            "lorem ipsum",
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
