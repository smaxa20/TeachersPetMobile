import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String uid;
  final CollectionReference collection = Firestore.instance.collection("teachers");

  DatabaseService({ this.uid });

  addUid(newuid) {
    this.uid = newuid;
  }

  Stream<QuerySnapshot> get classes {
    return collection.document(uid).collection("classes").snapshots();
  }
  
  Future updateClasses(int classIndex, String className) async {
    return await collection.document(uid).collection("classes").document("Class$classIndex").setData({
      "name" : className
    }, merge: true);
  }

  Stream<QuerySnapshot> getStudents(int classIndex) {
    return collection.document(uid).collection("classes").document("Class$classIndex").collection("students").snapshots();
  }

  Future updateStudents(int classIndex, int studentIndex, String name, List badPairs) async {
    return await collection.document(uid).collection("classes").document("Class$classIndex").collection("students").document("Student$studentIndex").setData({
      "name" : name,
      "badPairs" : badPairs
    }, merge: true);
  }
}