import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'database.dart';
import 'utilClasses.dart';

class StudentProfiles extends StatelessWidget {
  StudentProfiles({Key key, @required this.uid, @required this.className, @required this.classIndex}) : super(key: key);

  final String uid;
  final String className;
  final int classIndex;

  @override
  Widget build(BuildContext context) {
    final DatabaseService db = DatabaseService(uid: uid);
    return StreamProvider<QuerySnapshot>.value(
      value: db.classes,
      child: StudentProfilesContent(uid: uid, className: className, classIndex: classIndex)
    );
  }
}


class StudentProfilesContent extends StatefulWidget {
  StudentProfilesContent({Key key, @required this.uid, @required this.className, @required this.classIndex}) : super(key: key);

  final String uid;
  final String className;
  final int classIndex;

  @override
  _StudentProfilesContentState createState() => _StudentProfilesContentState(uid: uid, className: className, classIndex: classIndex);
}

class _StudentProfilesContentState extends State<StudentProfilesContent> {
  _StudentProfilesContentState({Key key, @required this.uid, @required this.className, @required this.classIndex}) : super();

  final String uid;
  final String className;
  final int classIndex;

  final snackKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    final DatabaseService db = DatabaseService(uid: uid);

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService(uid: uid).getStudents(classIndex),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List students = snapshot.data.documents;

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
                    students[index]["name"].toString(),
                    style: TextStyle(fontFamily: "Times New Roman", fontSize: 18),
                  ),
                  subtitle: Text(
                    "Bad Pairs: " + students[index]["badPairs"].toString().replaceAll("[", "").replaceAll("]", ""),
                    style: TextStyle(fontFamily: "Times New Roman", fontSize: 16),
                  ),
                  onTap: () async {
                    final newStudent = await showDialog(
                      context: context,
                      builder: (context) {
                        return StudentModal(students: students, index: index, snackKey: snackKey);
                      }
                    ) as Map<String, dynamic>;
                    if (newStudent != null) {
                      await db.updateStudents(classIndex, index, newStudent["name"], newStudent["badPairs"]);
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
                    await db.updateStudents(classIndex, students.length, newStudent["name"], newStudent["badPairs"]);
                  }
                }
              ),
          );
        } else {
          return Container(height: 10);
        }
      }
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

  Map<String, dynamic> newStudent = {
    "name": "",
    "badPairs": []
  };

  List<Widget> chipsList = [];
  chips(int index) {
    List badPairs;
    if (index == -1) {
      badPairs = newStudent["badPairs"];
    } else {
      badPairs = students[index]["badPairs"];
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
              newStudent["badPairs"].removeWhere((element) => element.toString() == name.toString());
            } else {
              students[index]["badPairs"].removeWhere((element) => element.toString() == name.toString());
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
        index == -1 ? "New Student" : students[index]["name"].toString(),
        style: TextStyle(fontFamily: "Times New Roman", fontSize: 24),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FilledInput(
              controller: editNameController,
              hintText: index == -1 ? "Name..." : "Change name...",
              smallText: true,
              autofocus: index == -1,
              textCapitalization: TextCapitalization.words,
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
                    textCapitalization: TextCapitalization.words,
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
                          newStudent["badPairs"].add(addBadPairController.text);
                        } else {
                          students[index]["badPairs"].add(addBadPairController.text);
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
                newStudent["name"] = editNameController.text;
                Navigator.pop(context, newStudent);
                snackKey.currentState.showSnackBar(SnackBar(
                  content: Text("New student created!", style: TextStyle(fontFamily: "Times New Roman")),
                  duration: Duration(seconds: 2),
                ));
              }
            } else {
              Map<String, dynamic> updatedStudent = {
                "name" : students[index]["name"],
                "badPairs" : students[index]["badPairs"]
              };
              if (editNameController.text != "") {
                updatedStudent["name"] = editNameController.text;
              }
              Navigator.pop(context, updatedStudent);
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