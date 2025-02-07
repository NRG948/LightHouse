import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class DataViewerAmongView extends StatelessWidget {
  const DataViewerAmongView({super.key});

  @override
  Widget build(BuildContext context) {
    final double scaleFactor;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
    return Scaffold(
      backgroundColor: Constants.pastelRed,
      
      appBar: AppBar(
        backgroundColor: Constants.pastelRed,
        title: const Text(
          "LightHouse",
          style: TextStyle(
              fontFamily: "Comfortaa",
              fontWeight: FontWeight.w900,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pushNamed(context, "/home-data-viewer");
        }, icon: Icon(Icons.home)),
       
      ),
      body: Container(
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background-hires.png"),
                  fit: BoxFit.cover)),
          child: Placeholder(),
      ));}
}
class AmongViewSharedState extends ChangeNotifier {
  late String activeEvent;
  late String activeLayout;
  late List<Map<String,dynamic>> data;
  void setActiveEvent(String event) {
    activeEvent = event;
    notifyListeners();
  }
  void setActiveLayout(String layout) {
    activeLayout = layout;
    notifyListeners();
  }
  void loadData() {
    
  }
  
}