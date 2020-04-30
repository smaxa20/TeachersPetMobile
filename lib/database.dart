import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String uid;
  final CollectionReference collection = Firestore.instance.collection("teachers");

  DatabaseService({ this.uid });

  addUid(newuid) {
    this.uid = newuid;
  }

  // Future getClasses() async {
  //   return await collection.document(uid).collection("classes").getDocuments();
  // }

  Stream<QuerySnapshot> get classes {
    return collection.document(uid).collection("classes").snapshots();
  }
  
  Future updateClasses(String classNumber, String className) async {
    return await collection.document(uid).collection("classes").document(classNumber).setData({
      "name" : className
    }, merge: true);
  }

  Future addClass(String classNumber, String className) async {
    return await collection.document(uid).collection("classes").document(classNumber).setData({
      "name" : className
    }, merge: true);
  }

  Future getStudents(String className) async {
    return await collection.document(uid).collection("classes").document(className).collection("students").getDocuments();
  }

  Future updateStudents(String className, Map<String, dynamic> student) async {
    return await collection.document(uid).collection("classes").document(className).collection("students").document(student["name"]).setData(student, merge: true);
  }
}