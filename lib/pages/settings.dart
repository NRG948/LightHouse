import "package:flutter/material.dart";
import "package:lighthouse/constants.dart";
import "package:lighthouse/filemgr.dart";


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
            child: Text(setting.toSentenceCase, style: Constants.comfortaaBold20pt)
          ),
          TextField(
            controller: TextEditingController(text: configData[setting]),
            onChanged: (text) {
              configData[setting] = text;
            },
            decoration: InputDecoration(labelText: "Enter Text", labelStyle: Constants.comfortaaBold20pt, border: OutlineInputBorder()),
          ) 
        ],
      )
    );
    }).toList();
    settingsList.add(SaveSettingsButton());
    settingsList.add(TextButton(onPressed: () {
      loadConfig(reset:true);
      Navigator.pushReplacementNamed(context, "/settings");
    }, child: Text("Reset Configuration")));
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Constants.pastelWhite),
        backgroundColor: Constants.pastelRed,
        title: const Text("Settings", style: TextStyle(
           fontFamily: "Comfortaa",
           fontWeight: FontWeight.w900,
           color: Colors.white
        ),),
        centerTitle: true,
        leading: IconButton(onPressed: () {Navigator.pushNamed(context, "/home-scouter");}, icon: Icon(Icons.home)),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background-hires.png"),
                    fit: BoxFit.cover)),
        child: Center(
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
        ),
      )
    );
  }
}

class SaveSettingsButton extends StatefulWidget {
  const SaveSettingsButton({super.key});

  @override
  State<SaveSettingsButton> createState() => _SaveSettingsButtonState();
}

class _SaveSettingsButtonState extends State<SaveSettingsButton> {
  @override
  Widget build(BuildContext context) {
   
    return TextButton(onPressed: () async {
      if (!mounted) {return;}
      if (await saveConfig() == 0) {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(content: Text("Successfully saved."),actions: [
            TextButton(onPressed: () {Navigator.pushNamed(context, "/home-scouter");}, child: Text("OK"))
          ],);
        });
      }
    }, child: Text("Save"));
  }
}
