// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pagar_app_poc/ScreenHeader/Header.dart';
// import 'package:pagar_app_poc/view/addEmployee.dart';
// import '../bloc/employee_state.dart';
// import 'package:flutter/foundation.dart';
// import 'package:pagar_app_poc/bloc/employee_bloc.dart';
// import 'package:pagar_app_poc/navigation/app_navigation.dart';
// import '../bloc/employee_state.dart';
// import 'employeeDetails.dart';
//
// class Home extends StatefulWidget {
//   Home({Key? key}) : super(key: key);
//   CollectionReference users =
//   FirebaseFirestore.instance.collection('Employees');
//
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// enum empattendence { present, absent, firstHalf, secondHalf }
//
// EmpBloc? userBloc;
//
// class _HomeState extends State<Home> {
//   CollectionReference users =
//   FirebaseFirestore.instance.collection('Employees');
//   final empattendenceController = TextEditingController();
//
//   List<dynamic> tempList = [];
//   List<Map> studentList=[];
//   //Create attendance list to hold attendance
//   Map<String,String> attendance={};
//   List<String> labels=['Present','Absent','firstHalf','secondHalf'];
//   bool isAttendencedone=false;
//   empattendence? _empattendence = empattendence.present;
//
// //list var
//
//   @override
//   void initState() {
//     //refresh the page here
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     userBloc = context.read<EmpBloc>();
//     userBloc?.fetchUser();
//     return Scaffold(
//       appBar: Header("Home"),
//       body: SafeArea(
//           child: Container(
//               color: Colors.white,
//               child: BlocBuilder<EmpBloc, UserState>(builder: (context, state) {
//                 if (state is UserLoading) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.blue,
//                     ),
//                   );
//                 }
//
//                 if (state is UserSuccess) {
//                   if (state.list.isEmpty) {
//                     return Column(children: [
//                       Center(
//                         child: Image.asset(
//                           'assets/images/folder.png',
//                           height: 100,
//                           width: 100,
//                         ),
//                       )
//                     ]);
//                   } else {
//                     return Center(
//                       child: ListView.builder(
//                         itemCount: state.list.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           if(state.list[index].attendence==''){
//                             isAttendencedone=true;
//                           }else{
//                             isAttendencedone=false;
//
//                           }
//                           return Card(
//                               child: GestureDetector(
//                                   onTap: () {
//                                     print("list");
//                                     print(state.list[index]);
//                                     print("list");
//
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 EmployeeDetails(
//                                                     (state.list[index]))));
//                                   },
//                                   child: Column(
//                                     children: [
//                                       ListTile(
//                                         title: Text(state.list[index].Name),
//                                         subtitle: Text(state.list[index].email),
//                                         trailing: Text(state.list[index].attendence),
//                                       ),
//
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Visibility(
//                                           visible: isAttendencedone,
//                                           child: Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                             children: labels.map((s){
//                                               return Column(
//                                                 children: <Widget>[
//                                                   Radio(
//                                                     groupValue: attendance[state.list[index].docId],
//                                                     value: s,
//                                                     onChanged: (String? newValue) {
//                                                       setState((){
//                                                         attendance[state.list[index].docId!]=newValue!;
//                                                         print(attendance);
//                                                       });
//                                                     },
//                                                   ),
//                                                   Text(s,style:TextStyle(color:Colors.black))
//                                                 ],
//                                               );
//                                             }).toList(),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                               )
//                           );
//                         },
//                       ),
//                     );
//                   }
//                 } else {
//                   return Text("something went wrong");
//                 }
//               }
//               )
//           )
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => AddEmp()));
//         },
//         child: Icon(Icons.add),
//         //label: const Text('Add Employees'),
//         backgroundColor: Colors.green,
//
//         hoverColor: Colors.green,
//       ),
//
//       bottomNavigationBar: Material(
//         color:  Colors.blueAccent,
//         child: InkWell(
//           onTap: () async{
//             print('called on tap');
//
//             print(attendance);
//
//
//             attendance.forEach((key, value) async{
//               await users.doc(key)
//                   .update({'attendence': value})
//                   .then((value) => print("User Updated"))
//                   .catchError((error) => print("Failed to update user: $error"));
//             });
//           },
//           child: const SizedBox(
//             height: kToolbarHeight,
//             width: double.infinity,
//             child: Center(
//               child: Text(
//                 'Mark Attendence',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
// // Future<void> updateUser() {
// //   return users
// //       .doc()
// //       .update({'company': 'Stokes and Sons'})
// //       .then((value) => print("User Updated"))
// //       .catchError((error) => print("Failed to update user: $error"));
// // }
// }
// // Row(
// //   mainAxisAlignment:
// //       MainAxisAlignment.spaceAround,
// //   children: [
// //     Expanded(
// //       child: Row(
// //         children: [
// //           Radio<empattendence>(
// //               value:
// //                   empattendence.present,
// //               groupValue: _empattendence,
// //               onChanged:
// //                   (empattendence? value) {
// //                 setState(() {
// //                   //map<id,atte>
// //                   _empattendence = value;
// //                   print(tempList.toString());
// //
// //                   if (tempList.contains(
// //                       state.list[index].docId)) {
// //                     print("alrady exist");
// //                   } else {
// //                     tempList.add({'id': state.list[index].docId, 'attendence': _empattendence});}
// //                 });
// //                 print(tempList);
// //               }),
// //           const Expanded(
// //             child: Text('Present'),
// //           )
// //         ],
// //       ),
// //       flex: 1,
// //     ),
// //     Expanded(
// //       child: Row(
// //         children: [
// //           Radio<empattendence>(
// //               value: empattendence.absent,
// //               groupValue: _empattendence,
// //               onChanged:
// //                   (empattendence? value) {
// //                 setState(() {_empattendence = value;
// //                   print(tempList.toString());
// //
// //                   if (tempList.contains(
// //                       state.list[index].docId)) {
// //                     print("alrady exist");
// //                   } else {
// //                     tempList.add({'id': state.list[index].docId, 'attendence': _empattendence
// //                     });
// //                   }
// //                 });
// //               }),
// //           const Expanded(
// //               child: Text('absent'))
// //         ],
// //       ),
// //       flex: 1,
// //     ),
// //   ],
// // ),
// // Row(
// //   mainAxisAlignment:
// //       MainAxisAlignment.spaceAround,
// //   children: [
// //     Expanded(
// //       child: Row(
// //         children: [
// //           Radio<empattendence>(
// //               value: empattendence.firstHalf,
// //               groupValue: _empattendence,
// //               onChanged:
// //                   (empattendence? value) {
// //                 setState(() {_empattendence = value;
// //
// //                   print(tempList.toString());
// //
// //                   if (tempList.contains(state.list[index].docId)) {
// //                     print("alrady exist");
// //                   } else {
// //                     tempList.add({'id': state.list[index].docId, 'attendence': _empattendence
// //                     });
// //                   }
// //                 });
// //               }),
// //           const Expanded(
// //             child: Text('firstHalf'),
// //           )
// //         ],
// //       ),
// //       flex: 1,
// //     ),
// //     Expanded(
// //       child: Row(
// //         children: [
// //           Radio<empattendence>(
// //               value: empattendence
// //                   .secondHalf,
// //               groupValue: _empattendence,
// //               onChanged:
// //                   (empattendence? value) {
// //                 setState(() {_empattendence = value;
// //                   if (tempList.contains(state.list[index].docId)) {
// //                     print("alrady exist");
// //                   } else {
// //                     tempList.add({'id': state.list[index].docId,
// //                       'attendence': _empattendence
// //                     });
// //                   }
// //                 });
// //               }),
// //           const Expanded(
// //               child: Text('secondHalf'))
// //         ],
// //       ),
// //       flex: 1,
// //     ),
// //   ],
// // ),