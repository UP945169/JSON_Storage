import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController keyInputController = new TextEditingController();
  TextEditingController valueInputController = new TextEditingController();

  // ignore: non_constant_identifier_names
  File? JsonFile;
  Directory? dir;
  String fileName = "JSONFile.json";
  bool fileExists = false;
  Map<String, dynamic>? fileContent;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directroy) {
      dir = directroy;
      JsonFile = new File(dir!.path + "/" + fileName);
      fileExists = JsonFile!.existsSync();
      if (fileExists)
        this.setState(() {
          fileContent = json.decode(JsonFile!.readAsStringSync());
        });
    });
  }

  @override
  void dispose() {
    keyInputController.dispose();
    valueInputController.dispose();
    super.dispose();
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("creating file");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String key, dynamic value) {
    print("Writng to File");
    Map<String, dynamic> content = {key: value};

    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContents =
          json.decode(JsonFile!.readAsStringSync());
      jsonFileContents.addAll(content);
      JsonFile!.writeAsStringSync(json.encode(jsonFileContents));
    } else {
      print("File doesn't exist");
      createFile(content, dir!, fileName);
    }
    this.setState(() {
      fileContent = json.decode(JsonFile!.readAsStringSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("JSON Storage")),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.all(10)),
            Text("File Content: "),
            Text(fileContent.toString()),
            Padding(padding: EdgeInsets.all(10)),
            Text("Add to JSON FILE"),
            TextField(
              controller: keyInputController,
            ),
            TextField(
              controller: valueInputController,
            ),
            Padding(padding: EdgeInsets.all(20)),
            ElevatedButton(
                child: Text("Add value to JSON FILE"),
                onPressed: () {
                  writeToFile(
                      keyInputController.text, valueInputController.text);
                })
          ],
        ),
      ),
    );
  }
}
