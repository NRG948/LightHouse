import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";
import "package:lighthouse/widgets/box_for_settings.dart";
import "package:lighthouse/constants.dart";


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> settingsList = configData.keys.map<Widget>((setting) {
      return Container(
      height: 110,
      width: 400,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      //margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: BoxDecoration(color: Constants.pastelRed, borderRadius: BorderRadius.circular(8)),
      child: Column(
        spacing: 8.0,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(setting, style: Constants.comfortaaBold20pt)
          ),
          TextField(
            controller: TextEditingController(),
            decoration: InputDecoration(labelText: "Enter Text", labelStyle: Constants.comfortaaBold20pt, border: OutlineInputBorder()),
          ) 
        ],
      )
    );
    }).toList();
    settingsList.add(SaveSettingsButton());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.pastelRed,
        title: const Text("Settings", style: TextStyle(
           fontFamily: "Comfortaa",
           fontWeight: FontWeight.w900,
           color: Colors.white
        ),),
        centerTitle: true,
        leading: IconButton(onPressed: () {Navigator.pushNamed(context, "/home");}, icon: Icon(Icons.home)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: ListView.builder(
            itemCount: settingsList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top:10.0, left:10.0, right: 10.0),
                child: settingsList[index],
              );
            },
          ),
        ),
      )
    );
  }
}

class SaveSettingsButton extends StatelessWidget {
  const SaveSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () async {
      if (await saveConfig() == 0) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(content: Text("Successfully saved."),actions: [
            TextButton(onPressed: () {Navigator.pushNamed(context, "/home");}, child: Text("OK"))
          ],);
        });
      }
    }, child: Text("Save"));
  }
}
