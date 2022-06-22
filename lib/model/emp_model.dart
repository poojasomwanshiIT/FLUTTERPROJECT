 import 'dart:core';
 import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:equatable/equatable.dart';
 class Employees  {
   String? docId;

   final String id;
   final String Name;
   final String email;
   final String mobile;
   final String DOB;
   final String experience;
   final String gender;
   final String attendence;


    Employees(  {required this.id,   required this.Name, required this.email,required this.mobile, required this.DOB , required this.experience,required this.gender, this.docId,required this.attendence} );
   Map<String, dynamic> toMap() {
     return {
       'docId':docId,
       'id':id,
       'Name': Name,
       'email': email,
       'mobile': mobile,
       'DOB':DOB,
       'experience':experience,
       'gender':gender,
'attendence':attendence,
     };
   }
   // factory Employees.fromDocument(DocumentSnapshot snap) {
   //   Employees employees=Employees(
   //     id:  snap.id,
   //     Name:(snap.data as DocumentSnapshot)['Name']
   //     email: (snap.data as DocumentSnapshot)['email'],
   //     mobile: (snap.data as DocumentSnapshot)['mobile'],
   //     gender:  (snap.data as DocumentSnapshot)['gender'],
   //     DOB:(snap.data as DocumentSnapshot)['DOB'],
   //     experience: (snap.data as DocumentSnapshot)['experience'],
   //     // Name:snap.data()?['Name'], email: snap['email'], id: snap['id'], DOB: snap['DOB'], mobile:snap['mobile'], experience: snap['experience'], gender: snap['gender']
   //   );
   //   return employees;
   // }
   static Employees fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> emp) {
    // Map<String,dynamic> emp=snap.data as Map<String, dynamic>;
      Employees employees=Employees(
        docId:emp.id,
      id:  emp['empId'],
        Name:emp['Name'],
       email: emp['email'],
       mobile:emp['mobile'],
      gender: emp['gender'] ,
        DOB:emp['DOB'],
       experience: emp['experience'],
       attendence: emp['attendence'],
       // Name:snap.data()?['Name'], email: snap['email'], id: snap['id'], DOB: snap['DOB'], mobile:snap['mobile'], experience: snap['experience'], gender: snap['gender']
     );
      return employees;
    }

   @override
   // TODO: implement props
   List<Object?> get props => [
     Name,email,mobile,gender,DOB,experience
   ];


   Employees copyWith({
     String? id,
     String? Name,
     String? email,
     String? mobile,
     String? DOB,
String? experience,
     String? gender,


   }) {
     return Employees(
       id: id ?? this.id,

       Name: Name ?? this.Name,

       email: email ?? this.email,
         experience: experience ?? this.experience,
       mobile: mobile ?? this.mobile,

       gender: gender ?? this.gender,
         DOB: DOB ?? this.DOB, attendence: '',

     );
   }








 }

//
// class UserModel{
//   List<UserItem>? list;
//   UserModel({list}) {
//     this.list = list;
//   }
//   factory UserModel.fromJson(List<dynamic> json){
//     return UserModel(
//         list : json.map((e) => UserItem.fromJson(e)).toList()
//     );
//   }}
// class UserItem{
//   UserData? userData;
//   UserItem({userData}){
//     this.userData = userData;
//   }
//   factory UserItem.fromJson(Map<String,dynamic> json){
//     print("Jsonn"+json.toString());
//     return UserItem(
//         userData: UserData.fromJson(json)
//     );
//   }
// }
// class UserData{
//   late final String id;
//   final String Name;
//   final String email;
//   final int mobile;
//   final String gender;
//   final DateTime DOB;
//   final int experience;
//
//
//   UserData(this.id, this.Name, this.email, this.mobile, this.gender, this.DOB, this.experience, ){
//     this.id=id;
//     this.email=email;
//     this.first_name=first_name;
//     this.last_name=last_name;
//     this.full_name=full_name;
//     this.avatar=avatar;
//
//   }
//   factory UserData.fromJson(Map<String,dynamic> json){
//     return UserData(
//         id: json["id"],
//         email: json["email"],
//         first_name: json["first_name"],
//         last_name: json["last_name"],
//         avatar: json["avatar"],
//         full_name:json["first_name"]+" "+json["last_name"]
//
//     );
//   }
// }