import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/data_entry.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/pages/data_entry_sub_page.dart';

class DataEntryPage extends StatefulWidget {
  const DataEntryPage({super.key, required this.pages, required this.name});
  final Map<String, DataEntrySubPage> pages;
  final String name;

  @override
  State<DataEntryPage> createState() => DataEntryPageState();
}

class DataEntryPageState extends State<DataEntryPage> {
  Map<String, DataEntrySubPage> get _pages => widget.pages;
  String get _name => widget.name;
  int currentPage = 0;
  static late double deviceWidth;
  static late double deviceHeight;
  late PageController controller;
  double startDrag = 0.0;
  bool hasEventKeyWarningShown = false;

  @override
  void initState() {
    super.initState();
    DataEntry.exportData.clear();
    controller = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    deviceWidth = MediaQuery.sizeOf(context).width;
    deviceHeight = MediaQuery.sizeOf(context).height;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    DataEntry.activeConfig =
        (ModalRoute.of(context)?.settings.arguments as String?)!;

    if (!hasEventKeyWarningShown &&
        defaultConfig["eventKey"] == configData["eventKey"]) {
      hasEventKeyWarningShown = true;
      Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                    padding: EdgeInsets.all(Constants.borderRadius),
                    child: Text(
                        "You are using the default event key! Go to Settings to change your event key.")),
              );
            });
      });
    }

    return PopScope(
      canPop: false,
      child: GestureDetector(
        // Allows keyboard to be closed when anywhere else is clicked on screen
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            // Prevents background image from being resized when keyboard opens
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor:
                  themeColorPalettes[configData["theme"] ?? "Dark"]![0],
              title: FittedBox(
                child: AutoSizeText(
                  "$_name - ${createNavBar(_pages)[currentPage].label}",
                  style: TextStyle(
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.w900,
                      color: Constants.pastelWhite),
                  minFontSize: 4,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    showReturnDialog(context);
                  },
                  icon: Icon(Icons.home, color: Constants.pastelWhite)),
              actions: [
                if (configData["debugMode"] == "true")
                  IconButton(
                    icon: Icon(Icons.javascript, color: Constants.pastelWhite),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return Dialog(
                              child: Text(jsonEncode(configData)),
                            );
                          });
                    },
                  ),
                IconButton(
                    onPressed: () {
                      saveJson(context);
                    },
                    icon: Icon(
                      Icons.save,
                      color: Constants.pastelWhite,
                    ))
              ],
            ),
            bottomNavigationBar: buildBottomNavBar(_pages),
            body: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgrounds[configData["theme"]] ??
                          "assets/images/background-hires-dark.png"),
                      fit: BoxFit.fill)),
              child: NotificationListener<OverscrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.axis == Axis.vertical) {
                    return true;
                  }
                  debugPrint(notification.overscroll.toString());
                  if (notification.overscroll < -25) {
                    showReturnDialog(context);
                  }
                  if (notification.overscroll > 25) {
                    saveJson(context);
                  }
                  return true;
                },
                child: ScrollConfiguration(
                  behavior: ScrollBehavior().copyWith(overscroll: false),
                  child: PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    // Forces overscroll to trigger OverscrollNotification instead
                    // of allowing overscroll itself
                    // Forces overscroll to trigger OverscrollNotification instead
                    // of allowing overscroll itself
                    physics: ClampingScrollPhysics(),
                    children: _pages.values.toList(),
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                  ),
                ),
              ),
            )),
      ),
    );
  }

  ///returns a list of the BottomNavigationBarItems that each of the pages gives it.
  List<BottomNavigationBarItem> createNavBar(Map<String, DataEntrySubPage> pages) {
    List<BottomNavigationBarItem> items = List<BottomNavigationBarItem>.empty(growable: true);
    for (var entry in pages.entries) {
      String title = entry.key;
      Icon icon = Icon(entry.value.icon);
      items.add(BottomNavigationBarItem(icon: icon, label: title));
    }
    return items;
  }

  Widget? buildBottomNavBar(Map<String, DataEntrySubPage> pages) {
    if (pages.length < 2) {
      return null;
    }
    return Theme(
      data: ThemeData(splashFactory: NoSplash.splashFactory),
      child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              if (currentPage != index) {
                HapticFeedback.mediumImpact();
              }
              currentPage = index;

              controller.animateToPage(index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate);
            });
          },
          unselectedIconTheme:
              IconThemeData(color: Constants.pastelWhite, size: 25),
          unselectedItemColor: Constants.pastelWhite,
          selectedIconTheme:
              IconThemeData(color: Constants.pastelWhite, size: 35),
          selectedItemColor: Constants.pastelWhite,
          currentIndex: currentPage,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              themeColorPalettes[configData["theme"] ?? "Dark"]![1],
          items: createNavBar(pages)),
    );
  }
}
