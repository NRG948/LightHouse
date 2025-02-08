import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";

// a stateless widget that allows users to modify application settings.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Creates a list of setting widgets based on configData keys.
    final List<Widget> settingsList = configData.keys.map<Widget>((setting) {
      return Container(
          height: 110, //sets the height of the setting container
          width: 400, // sets the width of the setting container
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          //margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              color: Constants.pastelRed,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            spacing: 8.0, // Space between child widgets.
            children: [
              // Displays the setting name with a custom style.
              Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child:
                      Text(setting.toSentenceCase, style: comfortaaBold(20))),
              // TextField for modifying the setting value.
              TextField(
                controller: TextEditingController(text: configData[setting]),
                onChanged: (text) {
                  configData[setting] = text;
                },
                decoration: InputDecoration(
                    labelText: "Enter Text",
                    labelStyle: comfortaaBold(20),
                    border: OutlineInputBorder()), // Adds a border around the text field.
              )
            ],
          ));
    }).toList();
    // Adds a button to save settings.
    settingsList.add(SaveSettingsButton());
    // Adds a button to reset configuration.
    settingsList.add(TextButton(
        onPressed: () {
          loadConfig(reset: true); //resets setting to default values
          Navigator.pushReplacementNamed(context, "/settings"); //reloads the setting page
        },
        child: Text("Reset Configuration")));
    final screenWidth = MediaQuery.of(context).size.width; //gets screen width
    final screenHeight = MediaQuery.of(context).size.height; //gets screen height
    return Scaffold(
        // App bar with back navigation and title.
        appBar: AppBar(
          iconTheme: IconThemeData(color: Constants.pastelWhite),
          backgroundColor: Constants.pastelRed,
          title: const Text(
            "Settings",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home-scouter"); // navigates back to home
              },
              icon: Icon(Icons.home)),
        ),
        // ✅ Background container with image.
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background-hires.png"),
                  fit: BoxFit.cover)), // covers the entire background
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView.builder(
                itemCount: settingsList.length, // Number of settings widgets.
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0),
                    child: settingsList[index], // Displays each setting widget.
                  );
                },
              ),
            ),
          ),
        ));
  }
}
// a stateful widget that saves the user's settings
class SaveSettingsButton extends StatefulWidget {
  const SaveSettingsButton({super.key});

  @override
  State<SaveSettingsButton> createState() => _SaveSettingsButtonState();
}

class _SaveSettingsButtonState extends State<SaveSettingsButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          if (!mounted) {
            return;
          } // Ensures widget is still part of the tree before proceeding.
          if (await saveConfig() == 0) { // Saves settings and checks if the operation was successful.
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("Successfully saved."), //confirmation message
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/home-scouter"); //navigates back to home
                          },
                          child: Text("OK"))
                    ],
                  );
                });
          }
        },
        child: Text("Save"));
  }
}
