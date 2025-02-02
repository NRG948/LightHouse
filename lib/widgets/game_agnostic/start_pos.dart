import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/pages/data_entry.dart';

class NRGStartPos extends StatefulWidget {
  final double height;
  final double width;
  const NRGStartPos({super.key, required this.height, required this.width});

  @override
  State<NRGStartPos> createState() => _NRGStartPosState();
}

class _NRGStartPosState extends State<NRGStartPos> {

  @override
  void initState() {
    super.initState();
    DataEntry.exportData["startingPosition"] = "0";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(color: Constants.pastelWhite, borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: GestureDetector(
        onTap: () {showStartPos(context, 0.3*DataEntryState.deviceWidth, 0.55*DataEntryState.deviceHeight);},
        child: Column(
          children: [
            SizedBox(height: widget.height*0.05,),
             Container(
            width: 0.7 * widget.width,
            height: 0.25 * widget.height,
            decoration: BoxDecoration(color: Constants.pastelGray,borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: Center(child: AutoSizeText("STARTING POSITION",style: comfortaaBold(20),textAlign: TextAlign.center,)),
              ),
            SizedBox(height: widget.height*0.1,),
            StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: widget.height * 0.5,
                  width: widget.width * 0.75,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),border: Border.all(color: Constants.pastelReddishBrown,width: 2.0)),
                  child: Image(image: AssetImage("assets/images/startPosWhiteLabel.png"),color: Constants.pastelYellow,));
              }
            ),
            SizedBox(height: widget.height*0.05,),
          ],
        )),
    );
  }
}

void showStartPos(BuildContext context, double width, double height) {
  bool? isActive;
  double? x;
  double? y;
  showDialog(context: context, builder: (context) {
    return Center(
      child: StatefulBuilder(
        builder: (context, setState) {
          isActive ??= DataEntry.exportData["startingPosition"] != "0";
          x ??= isActive! ? double.parse(DataEntry.exportData["startingPosition"].split(",")[0]): null;
          y ??= isActive! ? double.parse(DataEntry.exportData["startingPosition"].split(",")[1]) : null;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(
                builder: (innerContext) {
                  return Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Constants.borderRadius),border: Border.all(color: Constants.pastelWhite,width: 2.0)),
                    child:Stack(
                          children:[ GestureDetector(
                            onTapDown: (TapDownDetails details) {
                                    final RenderBox renderBox = innerContext.findRenderObject() as RenderBox;
                                    final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
                                    setState(() {
                                      isActive = true;
                                      x = localPosition.dx / renderBox.size.width;
                                      y = localPosition.dy / renderBox.size.height;
                                      debugPrint("${x!.toStringAsFixed(2)},${y!.toStringAsFixed(2)}");
                                      DataEntry.exportData["startingPosition"] = "${x!.toStringAsFixed(2)},${y!.toStringAsFixed(2)}";
                                    });
                                    
                          },
                            child: Image(image: DataEntry.exportData["driverStation"].contains("Red") ? AssetImage("assets/images/startPosFSRed.png") : AssetImage("assets/images/startPosFSBlue.png"),fit: BoxFit.fill,)),
                          if (isActive!) Positioned(
                            left:x! * width - 15,
                            top:y! * height - 15,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(color: Constants.markerLightGray,borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                   decoration: BoxDecoration(color: Constants.markerDarkGray,borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ))
                        ])
                  );
                }
              ),
              GestureDetector(
          onTap: () {setState(() {
            DataEntry.exportData["startingPosition"] = "0";
            isActive = false;
          },);
            
          },
          child: Container(
            width: width,
            height: 0.1 * height,
            decoration: BoxDecoration(color: Constants.pastelRed, borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: Text("Reset",style: comfortaaBold(0.06*height),textAlign: TextAlign.center,),
          ),
        )
            ],
          );
        }
      ),
    );
  });
}