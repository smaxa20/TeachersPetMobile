// import 'package:flutter/material.dart';
import 'dart:math';


String _name = "name";
String _badPairs = "bad pairs";


String randomStudent(students) {
  Random randomizer = new Random();
  int index = randomizer.nextInt(students.length);
  return students[index][_name];
}

List<Map<String, String>> randomPairs(students) {
  List<Map<String, dynamic>> localStudents = [];
  for (var doc in students) {
    localStudents.add(doc.data);
  }
  String extra;
  List<Map<String, String>> pairs = [];

  Random randomizer = new Random();
  bool isEven = students.length % 2 == 0;

  if (!isEven) {
    int rand = randomizer.nextInt(localStudents.length);
    extra = localStudents[rand][_name];
    localStudents.removeAt(rand);
  }
  while (localStudents.isNotEmpty) {
    Map<String, dynamic> student1 = localStudents[randomizer.nextInt(localStudents.length)];
    Map<String, dynamic> student2 = localStudents[randomizer.nextInt(localStudents.length)];
    if (student1[_badPairs] == null) {
      student1[_badPairs] = [];
    }
    if (student2[_badPairs] == null) {
      student2[_badPairs] = [];
    }

    if (student1[_name] != student2[_name] && !student1[_badPairs].contains(student2) && !student2[_badPairs].contains(student1)) {
      pairs.add({student1[_name]: student2[_name]});
      int index = localStudents.indexWhere((e) => e[_name] == student1[_name]);
      localStudents.removeAt(index);
      index = localStudents.indexWhere((e) => e[_name] == student2[_name]);
      localStudents.removeAt(index);
    }
  }
  if (!isEven) {
    pairs.add({extra: null});
  }
  return pairs;
}

randomGroups(int studentsPerGroup, students) {
  List<Map<String, dynamic>> localStudents = [];
  for (var doc in students) {
    localStudents.add(doc.data);
  }
  List<List<String>> groups = [];
  Map<int, String> extras = {};

  Random randomizer = new Random();
  int numOfGroups = (localStudents.length / studentsPerGroup).floor();

  bool restart = true;
  int restartCount = 0;
  while (restart) {
    if (restartCount >= 100) {
      return "Error: Timeout - please try again";
    }
    restart = false;
    List<Map<String, dynamic>> localStudents = [];
    for (var doc in students) {
      localStudents.add(doc.data);
    }
    groups = [];
    extras = {};

    int tempStudentsLength = localStudents.length;
    while (tempStudentsLength % studentsPerGroup != 0) {
      int rand = randomizer.nextInt(localStudents.length);
      if (!extras.keys.contains(rand)) {
        extras[rand] = localStudents[rand][_name];
        tempStudentsLength--;
      }
    }
    bool badPairFlag = false;
    extras.forEach((key, __name) {
      extras.forEach((__key, name) {
        if (localStudents[key][_badPairs] == null) {
          localStudents[key][_badPairs] = [];
        }
        if (localStudents[key][_badPairs].contains(name)) {
          badPairFlag = true;
        }
      });
    });
    if (badPairFlag) {
      restartCount++;
      restart = true;
      continue;
    } else {
      localStudents.removeWhere((element) => extras.values.contains(element[_name]));
    }

    int softRestartCount = 0;
    while (groups.length < numOfGroups) {
      if (softRestartCount >= 100) {
        return "Error: Timeout - please try again";
      }

      Map<int, String> tempGroup = {};
      while (tempGroup.length < studentsPerGroup) {
        int rand = randomizer.nextInt(localStudents.length);
        tempGroup[rand] = localStudents[rand][_name];
      }
      bool badPairFlag = false;
      tempGroup.forEach((key, _name) {
        tempGroup.forEach((_key, name) {
          if (localStudents[key][_badPairs] == null) {
            localStudents[key][_badPairs] = [];
          }
          if (localStudents[key][_badPairs].contains(name)) {
            badPairFlag = true;
          }
        });
      });
      if (badPairFlag && localStudents.length == studentsPerGroup) {
        restartCount++;
        restart = true;
        break;
      } else if (badPairFlag) {
        softRestartCount++;
        continue;
      } else {
        groups.insert(0, List.from(tempGroup.values));
        localStudents.removeWhere((element) => tempGroup.values.contains(element[_name]));
      }
    }
  }
  if (extras.isNotEmpty) {
    groups.add(List.from(extras.values));
  }

  return groups;
}

randomRows(int numOfRows, students) {
  List<Map<String, dynamic>> localStudents = [];
  for (var doc in students) {
    localStudents.add(doc.data);
  }
  List<List<String>> rows = [];
  Map<int, String> extras = {};

  Random randomizer = new Random();
  int studentsPerRow = (localStudents.length / numOfRows).floor();

  bool restart = true;
  int restartCount = 0;
  while (restart) {
    if (restartCount >= 100) {
      return "Error: Timeout - please try again";
    }
    restart = false;
    List<Map<String, dynamic>> localStudents = [];
    for (var doc in students) {
      localStudents.add(doc.data);
    }
    rows = [];
    extras = {};

    int tempStudentsLength = localStudents.length;
    while (tempStudentsLength % studentsPerRow != 0) {
      int rand = randomizer.nextInt(localStudents.length);
      if (!extras.keys.contains(rand)) {
        extras[rand] = localStudents[rand][_name];
        tempStudentsLength--;
      }
    }
    bool badPairFlag = false;
    List<int> extrasKeys = List.from(extras.keys);
    List<String> extrasVals = List.from(extras.values);
    for (int i = 1; i < extras.length; i++) {
      if (localStudents[extrasKeys[i]][_badPairs] == null) {
        localStudents[extrasKeys[i]][_badPairs] = [];
      }
      if (localStudents[extrasKeys[i]][_badPairs].contains(extrasVals[i-1])) {
        badPairFlag = true;
        break;
      }
    }
    if (badPairFlag) {
      restartCount++;
      restart = true;
      continue;
    } else {
      localStudents.removeWhere((element) => extrasVals.contains(element[_name]));
    }

    int softRestartCount = 0;
    while (rows.length < numOfRows) {
      if (softRestartCount >= 100) {
        return "Error: Timeout - please try again";
      }

      Map<int, String> tempRow = {};
      while (tempRow.length < studentsPerRow) {
        int rand = randomizer.nextInt(localStudents.length);
        tempRow[rand] = localStudents[rand][_name];
      }
      bool badPairFlag = false;
      List<int> tempRowKeys = List.from(tempRow.keys);
      List<String> tempRowVals = List.from(tempRow.values);
      for (int i = 1; i < tempRow.length; i++) {
        if (localStudents[tempRowKeys[i]][_badPairs] == null) {
          localStudents[tempRowKeys[i]][_badPairs] = [];
        }
        if (localStudents[tempRowKeys[i]][_badPairs].contains(tempRowVals[i-1])) {
          badPairFlag = true;
          break;
        }
      }
      if (rows.isNotEmpty && rows[0].isNotEmpty) {
        for (int i = 0; i < rows[0].length; i++) {
          if (localStudents[tempRowKeys[i]][_badPairs] == null) {
            localStudents[tempRowKeys[i]][_badPairs] = [];
          }
          if (localStudents[tempRowKeys[i]][_badPairs].contains(rows[0][i])) {
            badPairFlag = true;
            break;
          }
        }
      }
      if (badPairFlag && localStudents.length == studentsPerRow) {
        restartCount++;
        restart = true;
        break;
      } else if (badPairFlag) {
        softRestartCount++;
        continue;
      } else {
        rows.insert(0, List.from(tempRowVals));
        localStudents.removeWhere((element) => tempRowVals.contains(element[_name]));
      }
    }
  }
  if (extras.isNotEmpty) {
    rows.add(List.from(extras.values));
  }

  return rows;
}