import 'package:flutter/material.dart';
import 'StudentProfiles.dart';
import 'utilClasses.dart';
import 'randomizing.dart';

class ClassActions extends StatelessWidget {
  ClassActions({Key key, @required this.uid, @required this.className}) : super(key: key);

  final String uid;
  final String className;

  final groupsController = TextEditingController();
  final rowsController = TextEditingController();

  static final String _name = "name";
  static final String _badPairs = "bad pairs";
  final List<Map<String, dynamic>> students = [
    {_name: "Karlie", _badPairs: []},
    {_name: "Haylie", _badPairs: ["Tanner"]},
    {_name: "Scott", _badPairs: []},
    {_name: "Paige", _badPairs: ["Tanner", "Penelope"]},
    {_name: "Brad", _badPairs: []},
    {_name: "Becky", _badPairs: ["Buck"]},
    {_name: "Kris", _badPairs: []},
    {_name: "Chelsea", _badPairs: []},
    {_name: "Tanner", _badPairs: ["Haylie", "Paige"]},
    {_name: "Baker", _badPairs: []},
    {_name: "Scarlet", _badPairs: []},
    {_name: "Penelope", _badPairs: ["Paige"]},
    {_name: "Buck", _badPairs: ["Becky"]},
    {_name: "Mayze", _badPairs: []},
    {_name: "Cheeto", _badPairs: []},
    {_name: "Chip", _badPairs: []},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          className,
          style: TextStyle(color: green4, fontFamily: "Times New Roman", fontSize: 32)
        ),
        iconTheme: IconThemeData(color: green4),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                buildCard(
                  "Random Student",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: green2,
                          title: Text(
                            randomStudent(students),
                            style: TextStyle(fontFamily: "Times New Roman", fontSize: 48),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    );
                  }
                ),
                buildCard(
                  "Pairs",
                  onTap: () {
                    List<Map<String, String>> pairs = randomPairs(students);
                    String title = "";
                    for (int i = 0; i < pairs.length; i++) {
                      if (List.from(pairs[i].values)[0] == null) {
                        title += "\nExtra: ";
                        title += List.from(pairs[i].keys)[0].toString();
                      } else {
                        title += List.from(pairs[i].keys)[0].toString();
                        title += " & ";
                        title += List.from(pairs[i].values)[0].toString();
                        title += "\n";
                      }
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: green2,
                          title: Text(
                            title.trim(),
                            style: TextStyle(fontFamily: "Times New Roman", fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    );
                  }),
                buildCard(
                  "Groups",
                  hasSize: true,
                  sizeController: groupsController,
                  onTap: () {
                    bool isNumber = int.tryParse(groupsController.text) != null;
                    String title = "";
                    if (isNumber) {
                      List<List<String>> groups = randomGroups(int.parse(groupsController.text), students);
                      for (int i = 0; i < groups.length; i++) {
                        if (i != 0 && groups[i].length < groups[i-1].length) {
                          title += "Extras: ";
                        }
                        title += groups[i].toString();
                        title += "\n\n";
                      }
                    } else {
                      title = "Please enter a number.";
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: green2,
                          title: Text(
                            title.trim().replaceAll("[", "").replaceAll("]", ""),
                            style: TextStyle(fontFamily: "Times New Roman", fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    );
                  }
                ),
                buildCard(
                  "Rows",
                  hasSize: true,
                  sizeController: rowsController,
                  onTap: () {
                    bool isNumber = int.tryParse(rowsController.text) != null;
                    String title = "";
                    if (isNumber) {
                      List<List<String>> rows = randomRows(int.parse(rowsController.text), students);
                      for (int i = 0; i < rows.length; i++) {
                        if (i != 0 && rows[i].length < rows[i-1].length) {
                          title += "Extras: ";
                        }
                        title += rows[i].toString();
                        title += "\n\n";
                      }
                    } else {
                      title = "Please enter a number.";
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: green2,
                          title: SingleChildScrollView(
                            child: Text(
                              title.trim().replaceAll("[", "").replaceAll("]", "").replaceAll(",", " |"),
                              style: TextStyle(fontFamily: "Times New Roman", fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    );
                  })
              ],
            ),
            GridView.count(
              crossAxisCount: 1,
              shrinkWrap: true,
              childAspectRatio: 2.0,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                buildCard(
                  "Student Profiles",
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) {
                          return StudentProfiles(uid: uid, className: className, students: students);
                        }
                      )
                    );
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


buildCard(String title, {bool hasSize = false, TextEditingController sizeController, @required Function onTap}) {
  Widget body;
  if (hasSize) {
    if (title == "Rows") {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: white2))
                ),
                child: TextFormField(
                  controller: sizeController,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: white2, fontFamily: "Times New Roman", fontSize: 24),
                  decoration: InputDecoration.collapsed(
                    hintText: "",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: TextStyle(color: white2, fontFamily: "Times New Roman", fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      );
    } else {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: white2, fontFamily: "Times New Roman", fontSize: 24),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "of size:",
                  style: TextStyle(color: white2, fontFamily: "Times New Roman", fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 40,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: white2))
                ),
                child: TextFormField(
                  controller: sizeController,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(color: white2, fontFamily: "Times New Roman", fontSize: 24),
                  decoration: InputDecoration.collapsed(
                    hintText: "",
                  ),
                ),
              ),
            ],
          )
        ],
      );
    }
  } else {
    body = Text(
      title,
      style: TextStyle(color: white2, fontFamily: "Times New Roman", fontSize: 24),
      textAlign: TextAlign.center,
    );
  }

  return InkWell(
    child: Card(
      color: green4,
      child: Center(
        child: body
      ),
    ),
    onTap: onTap,
  );
}