import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class NRGStartPos extends StatefulWidget {
  final double height;
  final double width;
  const NRGStartPos({super.key, required this.height, required this.width});

  @override
  State<NRGStartPos> createState() => _NRGStartPosState();
}

class _NRGStartPosState extends State<NRGStartPos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(color: Constants.pastelWhite, borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: GestureDetector(
        
        child: Column(
          children: [
            SizedBox(height: widget.height*0.05,),
             Container(
            width: 0.7 * widget.width,
            height: 0.25 * widget.height,
            decoration: BoxDecoration(color: Constants.pastelGray,borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: AutoSizeText("STARTING POSITION",style: comfortaaBold(20),textAlign: TextAlign.center,),
              ),
            SizedBox(height: widget.height*0.1,),
            Container(
              height: widget.height * 0.5,
              width: widget.width * 0.75,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),border: Border.all(color: Constants.pastelReddishBrown,width: 2.0)),
              child: Image(image: AssetImage("assets/images/startPosWhiteLabel.png"),color: Constants.pastelYellow,)),
            SizedBox(height: widget.height*0.05,),
          ],
        )),
    );
  }
}