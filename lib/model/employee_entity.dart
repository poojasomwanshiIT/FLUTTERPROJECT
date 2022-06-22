// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
//
// class EmployeeEntity extends Equatable {
//   final String id;
//   final String Name;
//   final String email;
//   final int mobile;
//   final String gender;
//   final DateTime DOB;
//   final int experience;
//
//
//
//
//   EmployeeEntity( this.id,   this.Name, this.email,this.mobile, this.gender,this.DOB , this.experience, );
//
//   Map<String, Object> toJson() {
//     return {
// 'id':id,
//       'Name': Name,
//       'email': email,
//       'mobile':mobile,
//       'gender': gender,
//       '_dateTime':DOB,
//
//       'experience':experience,
//
//     };
//   }
//
//   @override
//   String toString() {
//     return 'TodoEntity {id:$id, Name: $Name, email: $email, mobile:$mobile,gender: $gender, _dateTime:$DOB,experience: $experience, }';
//   }
//
//   static EmployeeEntity fromJson(Map<String, Object> json) {
//     return EmployeeEntity(
//       json['id'] as String,
//       json['Name'] as String,
//       json['email'] as String,
//       json['mobile'] as int,
//       json['gender'] as String,
//       json['DOB'] as DateTime,
//       json['experience'] as int,
//
//
//     );
//   }
//
//   static EmployeeEntity fromSnapshot(DocumentSnapshot snap) {
//     return EmployeeEntity(
//   snap.id,
//       (snap.data as DocumentSnapshot)['Name'],
//       (snap.data as DocumentSnapshot)['email'],
//       (snap.data as DocumentSnapshot)['mobile'],
//       (snap.data as DocumentSnapshot)['gender'],
//       (snap.data as DocumentSnapshot)['DOB'],
//       (snap.data as DocumentSnapshot)['experience'],
//     );
//   }
//
//   Map<String, Object> toDocument() {
//     return {
//       'Name': Name,
//       'email': email,
//       'mobile': mobile,
//       'gender':gender,
//       'DOB':DOB,
//       'experience':experience,
//     };
//   }
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => throw UnimplementedError();
// }