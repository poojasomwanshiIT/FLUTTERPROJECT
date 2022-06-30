import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:pagar_app_poc/model/emp_model.dart';

import '../bloc/employee_event.dart';
import '../repository/base_repo.dart';

class EmpService  {
  final employeeCollection = FirebaseFirestore.instance.collection('Employees');
 final BaseRepo _baseRepo=BaseRepo.instance;
  late final FirebaseFirestore _firebaseFirestore;
  EmpService({FirebaseFirestore? firebaseFirestore}): _firebaseFirestore=firebaseFirestore ?? FirebaseFirestore.instance;

  EmpService._privateConstructor();

  static final EmpService _instance = EmpService._privateConstructor();

  static EmpService get instance {
    return _instance;
  }


  @override
  Future<List<Employees>> retrieveUserData() {
 // List<Employees> result =_baseRepo.retrieveUserData();
 //    print("in service");
 //    print(_baseRepo.retrieveUserData);
 //    print("in service");

    return _baseRepo.retrieveUserData();
  }
  Future updateUser(docId,id, Name, email, mobile,DOB,experience,gender) {
    // List<Employees> result =_baseRepo.retrieveUserData();
    // print("in service");
    // print(_baseRepo.updateUser);
    // print("in service");
    // print(gender);
    return _baseRepo.updateUser(docId,id, Name, email, mobile,DOB,experience,gender);
  }
  Future addUser( Name, email, mobile,DOB,experience,gender,id,attendence) {

    return _baseRepo.addUser( Name, email, mobile,DOB,experience,gender,id,attendence);
  }

  Future updateAttendence(docId,attendence) {
    // List<Employees> result =_baseRepo.retrieveUserData();
    // print("in service");
    // print(_baseRepo.updateUser);
    print("in service");
    print(attendence);
    return _baseRepo.updateAttendence(docId,attendence);
  }
}





//@override
// Stream<List<Employees>> getAllEmployees() {
//   // TODO: implement getAllEmployees
//  return employeeCollection.snapshots().map((snapshot) {
//    return snapshot.docs.map((doc) => Employees.fromSnapshot(doc)).toList();
//  });
// }
//.............................//
//   Future<Either<dynamic,  List<List<Employees>>>> getAllEmployees() async{
//
//     List<List<Employees>>  result=(await _baseRepo.getAllEmployees()) ;
// //print(result);
//   return Right(result);
//     // return Right(employeeCollection.snapshots().map((snapshot) {
//     //   return snapshot.docs
//     //       .map((doc) => Employees.fromSnapshot(doc))
//     //       .toList();
//     // }));
//   }
