import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:pagar_app_poc/model/emp_model.dart';

 class BaseRepo {
  final employeeCollection = FirebaseFirestore.instance.collection('Employees');
 String? documentId;
  CollectionReference updateEmp =
  FirebaseFirestore.instance.collection('Employees');
  // final docId = ;
  //  String empId=QueryDocumentSnapshot.;
  BaseRepo._privateConstructor();

  static final BaseRepo _instance =
  BaseRepo._privateConstructor();

  // we can use this constructor to pass values
  factory BaseRepo() {
    return _instance;
  }

  //OR if we do not need to pass values we can use this field
  static BaseRepo get instance {
    return _instance;
  }






// Future<List<List<Employees>>> getAllEmployees() {
//     return (employeeCollection.snapshots().map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Employees.fromSnapshot(doc))
//          .toList();
//     })).toList();
//   }

  Future<List<Employees>> retrieveUserData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await employeeCollection.get();
    return snapshot.docs
        .map((docSnapshot) => Employees.fromSnapshot(docSnapshot))
        .toList().cast<Employees>();
  }
Future<dynamic>updateUser(docId,id, Name, email, mobile,DOB,experience,gender)async{
     // print("repo");
     // print(gender);
  return employeeCollection
      .doc(docId.toString().trim())
      .update({
    'Name': Name,
    'email': email,
    'mobile': mobile,
    'DOB':DOB,
    'experience':experience,
    'gender':gender,

  });
      // .then((value) => print("User Updated"))
      // .catchError((error) => print("Failed to update user: $error"));
    // DocumentReference documentReference=employeeCollection.doc();
}
   Future<dynamic>addUser( Name, email, mobile,DOB,experience,gender,id,attendence)async{
     // print("repo");
     // print(gender);
     return employeeCollection.add({
       'Name':Name,
       'email': email,
       'mobile':mobile,
       'DOB': DOB,
       'experience': experience,
       'gender': gender,
       'empId':id ,
       'attendence':'',
     }).then((value) => print("user added"));
     // .then((value) => print("User Updated"))
     // .catchError((error) => print("Failed to update user: $error"));
     // DocumentReference documentReference=employeeCollection.doc();
   }
   Future<dynamic>updateAttendence(docId,attendence)async{
     print("repo");
     print(attendence);
     return employeeCollection
         .doc(docId.toString().trim())
         .update({
       'attendence':attendence,

     });
     // .then((value) => print("User Updated"))
     // .catchError((error) => print("Failed to update user: $error"));
     // DocumentReference documentReference=employeeCollection.doc();
   }
}
// static Future<void> updateItem({
// required String title,
// required String description,
// required String docId,
// }) async {
// DocumentReference documentReferencer =
// _mainCollection.doc(userUid).collection('items').doc(docId);
//
// Map<String, dynamic> data = <String, dynamic>{
//   "title": title,
//   "description": description,
// };
//
// await documentReferencer
//     .update(data)
// .whenComplete(() => print("Note item updated in the database"))
// .catchError((e) => print(e));
// }