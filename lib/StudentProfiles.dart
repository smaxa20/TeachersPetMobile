import 'package:flutter/material.dart';
import 'utilClasses.dart';

class StudentProfiles extends StatefulWidget {
  StudentProfiles({Key key, @required this.username, @required this.className, @required this.students}) : super(key: key);

  final String username;
  final String className;
  List<Map<String, dynamic>> students;

  @override
  _StudentProfilesState createState() => _StudentProfilesState(username: username, className: className, students: students);
}

class _StudentProfilesState extends State<StudentProfiles> {
  _StudentProfilesState({Key key, @required this.username, @required this.className, @required this.students}) : super();

  final String username;
  final String className;
  List<Map<String, dynamic>> students;

  final snackKey = GlobalKey<ScaffoldState>();

  String _name = "name";
  String _badPairs = "bad pairs";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: snackKey,
      backgroundColor: white1,
      appBar: AppBar(
        iconTheme: IconThemeData(color: green4),
        centerTitle: true,
        title: Text(
          className,
          style: TextStyle(color: green4, fontFamily: "Times New Roman", fontSize: 32)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              students[index][_name].toString(),
              style: TextStyle(fontFamily: "Times New Roman", fontSize: 18),
            ),
            subtitle: Text(
              "Bad Pairs: " + students[index][_badPairs].toString().replaceAll("[", "").replaceAll("]", ""),
              style: TextStyle(fontFamily: "Times New Roman", fontSize: 16),
            ),
            onTap: () async {
              final newStudents = await showDialog(
                context: context,
                builder: (context) {
                  return StudentModal(students: students, index: index, snackKey: snackKey);
                }
              ) as List<Map<String, dynamic>>;
              if (newStudents != null) {
                setState(() {
                  students = newStudents;
                });
              }
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: white2),
          backgroundColor: green4,
          onPressed: () async {
            final newStudent = await showDialog(
              context: context,
              builder: (context) {
                return StudentModal(students: students, index: -1, snackKey: snackKey);
              }
            ) as Map<String, dynamic>;
            if (newStudent != null) {
              setState(() {
                students.add(newStudent);
              });
            }
          }
        ),
    );
  }
}


class StudentModal extends StatefulWidget {
  StudentModal({
    Key key,
    @required this.students,
    @required this.index,
    @required this.snackKey
  }) : super(key: key);

  final students;
  final int index;
  final GlobalKey<ScaffoldState> snackKey;

  @override
  _StudentModalState createState() => _StudentModalState(students: students, index: index, snackKey: snackKey);
}

class _StudentModalState extends State<StudentModal> {
  _StudentModalState({
    Key key,
    @required this.students,
    @required this.index,
    @required this.snackKey,
  }) : super();

  final students;
  final int index;
  final GlobalKey<ScaffoldState> snackKey;

  final editNameController = TextEditingController();
  final addBadPairController = TextEditingController();

  static String _name = "name";
  static String _badPairs = "bad pairs";

  Map<String, dynamic> newStudent = {
    _name: "",
    _badPairs: []
  };

  List<Widget> chipsList = [];
  chips(int index) {
    List badPairs;
    if (index == -1) {
      badPairs = newStudent[_badPairs];
    } else {
      badPairs = students[index][_badPairs];
    }
    chipsList.clear();
    for (var name in badPairs) {
      chipsList.add(Chip(
        label: Text(
          name.toString(),
          style: TextStyle(fontFamily: "Times New Roman", fontSize: 14)
        ),
        deleteIcon: Icon(Icons.close),
        onDeleted: () {
          setState(() {
            if (index == -1) {
              newStudent[_badPairs].removeWhere((element) => element.toString() == name.toString());
            } else {
              students[index][_badPairs].removeWhere((element) => element.toString() == name.toString());
            }
            chipsList = chips(index);
          });
        },
      ));
    }
    return chipsList;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: green2,
      title: Text(
        index == -1 ? "New Student" : students[index][_name].toString(),
        style: TextStyle(fontFamily: "Times New Roman", fontSize: 24),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FilledInput(
              controller: editNameController,
              hintText: "Change name...",
              smallText: true,
            ),
            Container(height: 8, width: 0),
            Container(
              width: double.infinity,
              child: Text(
                "Bad Pairs:",
                style: TextStyle(fontFamily: "Times New Roman", fontSize: 18),
                textAlign: TextAlign.start
              )
            ),
            Container(
              width: double.infinity,
              child: Wrap(
                children: chips(index),
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.start,
              ),
            ),
            Container(height: 8, width: 0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: FilledInput(
                    controller: addBadPairController,
                    hintText: "Add bad pair...",
                    smallText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: FilledButton(
                    text: "Add",
                    color: green4,
                    textColor: white1,
                    smallText: true,
                    width: 52,
                    height: 48,
                    onPressed: () {
                      setState(() {
                        if (index == -1) {
                          newStudent[_badPairs].add(addBadPairController.text);
                        } else {
                          students[index][_badPairs].add(addBadPairController.text);
                        }
                        addBadPairController.text = "";
                      });
                    }
                  ),
                )
              ],
            ),
          ]
        )
      ),
      actions: <Widget>[
        FilledButton(
          text: "Confirm",
          color: green4,
          textColor: white1,
          smallText: true,
          onPressed: () {
            if (index == -1) {
              if (editNameController.text != "") {
                newStudent[_name] = editNameController.text;
                Navigator.pop(context, newStudent);
                snackKey.currentState.showSnackBar(SnackBar(
                  content: Text("New student created!", style: TextStyle(fontFamily: "Times New Roman")),
                  duration: Duration(seconds: 2),
                ));
              }
            } else {
              if (editNameController.text != "") {
                students[index][_name] = editNameController.text;
              }
              Navigator.pop(context, students);
              snackKey.currentState.showSnackBar(SnackBar(
                content: Text("Information updated!", style: TextStyle(fontFamily: "Times New Roman")),
                duration: Duration(seconds: 2),
              ));
            }
          }
        )
      ],
    );
  }
}