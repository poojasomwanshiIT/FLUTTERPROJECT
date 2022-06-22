// import 'package:meta/meta.dart';
// import 'employee_entity.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// // class EmployeeModel {
// //   String? id;
// //   final String Name;
// //   final String email;
// //   final int mobile;
// //   final String gender;
// //   final DateTime DOB;
// //   final int experience;
// //   EmployeeModel({required this.Name, required this.email, required this.mobile, required this.gender, required this.DOB, required this.experience, String? id,} );
// //
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id':id,
// //       'Name': Name,
// //       'email': email,
// //       'mobile':mobile,
// //       'gender': gender,
// //       '_dateTime':DOB,
// //
// //       'experience':experience,
// //     };
// //   }
// //   EmployeeModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
// //       : id = doc.id,
// //         Name = doc.data()!["Name"],
// //       email = doc.data()!["email"],
// //         mobile = doc.data()!["mobile"],
// //         gender = doc.data()!["gender"],
// //         DOB = doc.data()!["DOB"],
// //         experience = doc.data()!["experience"],
// //
// //
// //         EmployeeModel copyWith({ String? id='';
// //         final String Name='';
// //         final String email='';
// //         final int mobile='';
// //         final String gender='';
// //         final DateTime DOB='';
// //         final int experience='';})
// //   {
// //
// //     return EmployeeModel(
// //       id: id ?? this.id,
// //       Name: Name ?? this.Name,
// //       email: email ?? this.email,
// //       mobile: mobile ?? this.mobile,
// //       gender: gender ?? this.gender,
// //       DOB: DOB ?? this.DOB,
// //       experience: experience ?? this.experience,
// //     );
// //   }
// //
// //
// //
// //
// @immutable
// class Employee {
//   final String id;
//   final String Name;
//   final String email;
//   final int mobile;
//   final String gender;
//   final DateTime DOB;
//   final int experience;
//
//   Employee({
//     required this.id,
//     required this.Name,
//     required this.email,
//     required this.mobile,
//     required this.gender,
//     required this.DOB,
//     required this.experience,
//   });
//
//   Employee copyWith({
//     String? email,
//     int? mobile,
//     String? gender,
//     DateTime? DOB,
//     int? experience,
//   }) {
//     return Employee(
//       id: id ?? this.id,
//       Name: Name ?? this.Name,
//       email: email ?? this.email,
//       mobile: mobile ?? this.mobile,
//       DOB: DOB ?? DateTime.now(),
//       gender: gender ?? this.gender,
//       experience: experience ?? this.experience,
//     );
//   }
//
//   @override
//   String toString() {
//     return 'Employee {id:$id, Name: $Name, email: $email, mobile:$mobile,gender: $gender, _dateTime:$DOB,experience: $experience, }';
//   }
//
//   EmployeeEntity toEntity() {
//     return EmployeeEntity(id, Name, email, mobile, gender, DOB, experience);
//   }
//
//   static Employee fromEntity(EmployeeEntity entity) {
//     return Employee(
//         email: entity.email,
//         id: entity.id,
//         mobile: entity.mobile,
//         Name: entity.Name,
//         DOB: entity.DOB,
//         gender: entity.gender,
//         experience: entity.experience);
//   }
// }
