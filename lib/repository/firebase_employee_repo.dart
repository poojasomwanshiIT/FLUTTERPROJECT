// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pagar_app_poc/model/employees.dart';
// import 'employee_repo.dart';
// import 'package:pagar_app_poc/model/employee_entity.dart';
//
// class FirebaseEmployeeRepository implements EmployeeRepository {
//   final employeeCollection = FirebaseFirestore.instance.collection('employees');
//
//   FirebaseEmployeeRepository(Object object);
//
//   // @override
//   // Future<void> addNewTodo(Employee employee) {
//   //   return employeeCollection.add(employee.toEntity().toDocument());
//   // }
//
//   // @override
//   // Future<void> deleteEmployee(Employee employee) async {
//   //   return employeeCollection.doc(employee.id).delete();
//   // }
//   @override
//   Stream<List<Employee>> getEmployees() {
//     return employeeCollection.snapshots().map((snapshot) {
//       return snapshot.docs
//           .map((doc) => Employee.fromEntity(EmployeeEntity.fromSnapshot(doc)))
//           .toList();
//     });
//   }
//   // final FirebaseFirestore _firebaseFirestore;
//   //
//   // FirebaseEmployeeRepository({FirebaseFirestore? firebaseFirestore})
//   //     :_firebaseFirestore=firebaseFirestore ?? FirebaseFirestore.instance;
//   //
//   // @override
//   // Stream<List<Employee>> getEmployees() {
//   //   return employeeCollection.snapshots().map((snapshot) {
//   //     return snapshot.docs
//   //         .map((doc) => Employee.fromEntity(EmployeeEntity.fromSnapshot(doc)))
//   //         .toList();
//   //   });
//   // }
// // @override
// // Future<void> updateTodo(Employee update) {
// //   return employeeCollection
// //       .doc(update.id).update(update.toEntity().toDocument())
// //   ;
// // }
//
//
// }