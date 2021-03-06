import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagar_app_poc/ScreenHeader/Header.dart';
import 'package:pagar_app_poc/view/addEmployee.dart';
import '../bloc/employee_state.dart';
import 'package:flutter/foundation.dart';
import 'package:pagar_app_poc/bloc/employee_bloc.dart';
import 'package:pagar_app_poc/navigation/app_navigation.dart';
import '../bloc/employee_state.dart';
import 'employeeDetails.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  CollectionReference users =
      FirebaseFirestore.instance.collection('Employees');

  @override
  _HomeState createState() => _HomeState();
}

EmpBloc? userBloc;

class _HomeState extends State<Home> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('Employees');

  late var empattendenceController = TextEditingController();

  late final int index;

  //Create attendance list to hold attendance
  List<Map> empList = [];

  List<String> labels = ['Present', 'Absent', 'firstHalf', 'secondHalf'];

  bool isAttendencedone = false;
bool isEditon=true;
  String? colorText;
  Color _bgColor = Colors.blue;
  String? attId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = context.read<EmpBloc>();
    userBloc?.fetchUser();
    return Scaffold(
      appBar: Header("Home"),
      body: SafeArea(
          child: Container(
              color: Colors.white,
              child: BlocBuilder<EmpBloc, UserState>(
                  buildWhen: (previousState, state) {
                previousState != state && state is UserLoading;
                return true;
              }, builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }
                if (state is UserError) {
                  return Text(state.error);
                  //  print(state.error);
                } else {
                  if ((state as UserSuccess).list.isEmpty) {
                    return Column(children: [
                      Center(
                        child: Padding(padding: const EdgeInsets.only(top: 250),
                          child: Image.asset(
                            'assets/images/folder.png',
                            height: 100,
                            width: 100,
                          ),

                        )
                      )
                    ]);
                  } else {
                    return Center(
                      child: ListView.builder(
                        itemCount: state.list.length,
                        itemBuilder: (BuildContext context, int index) {
                          empList.add({'id': state.list[index].docId});

                          colorText = state.list[index].attendence;
                          userBloc?.attend(state.list, state.attendance);

                          if (state.list[index].attendence == '') {
                            isAttendencedone = true;
                          } else {
                            isAttendencedone = false;
                          }
                          return Card(
                              child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             EmployeeDetails(
                                    //                 (state.list[index]))));
                                    AppNavigator.push(
                                        context: context,
                                        routeName: AppNavigator.updateEmpsRoute,
                                        argument: {'flag':true,'data':(state).list[index]});
                                  },
                                  child: Column(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 10)),
                                      ListTile(
                                        title: Text(state.list[index].Name),
                                        subtitle: Text(state.list[index].email),
                                        trailing: Text(
                                          state.list[index].attendence,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: getTextclr(
                                                state.list[index].attendence),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Visibility(
                                            visible: isAttendencedone,
                                            child: InkWell(
                                              onTap: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: labels.map((s) {
                                                  return Column(
                                                    children: <Widget>[
                                                      Radio(
                                                        groupValue:
                                                            (state).attendance[
                                                                (state)
                                                                    .list[index]
                                                                    .docId!],
                                                        value: s,
                                                        onChanged:
                                                            (String? newValue) {
                                                          (state).attendance[
                                                                  (state)
                                                                      .list[index]
                                                                      .docId!] =
                                                              newValue!;
                                                          userBloc?.attend(
                                                              state.list,
                                                              state.attendance);
                                                        },
                                                      ),
                                                      Text(s,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                            )),
                                      ),
                                      const Padding(padding: EdgeInsets.only(top: 10))
                                    ],
                                  )));
                        },
                      ),
                    );
                  }
                }
              }))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => AddEmp()));
          AppNavigator.push(
            context: context,
            routeName: AppNavigator.addEmpRoute,
            argument: false,
          );
        },
        child: const Icon(Icons.add),
        //label: const Text('Add Employees'),
        backgroundColor: Colors.green,

        hoverColor: Colors.green,
      ),
      bottomNavigationBar: Material(
        color: Colors.blueAccent,
        child: InkWell(
          onTap: () async {
            print('called on tap');

            if ((userBloc?.state as UserSuccess).attendance.isEmpty) {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text("Failed"),
                      titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20),
                      content: Text("Please Select Employee's Attendence"),
                    );
                  });
            } else {
              (userBloc?.state as UserSuccess)
                  .attendance
                  .forEach((key, value) async {
                await userBloc?.updateAttendence(key, value);
              });
              AppNavigator.push(
                context: context,
                routeName: AppNavigator.homeRoute,
              );
              // (userBloc?.state as UserSuccess).attendance.forEach((key, value) async {
              //   await users.doc(key)
              //       .update({'attendence': value})
              //       .then((value) => print("User Updated"))
              //       .catchError((error) =>
              //       print("Failed to update user: $error"));
              // });
            }

          },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                'Mark Attendence',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                   color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getTextclr(dynamic clr) {
    if (colorText == 'Present') {
      return _bgColor = Colors.green;
    }
    if (colorText == 'Absent') {
      return _bgColor = Colors.red;
    }
    if (colorText == 'firstHalf') {
      return _bgColor = Colors.purple;
    }
    if (colorText == 'secondHalf') {
      return _bgColor = Colors.indigo;
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }


}

// labels.map((s) {
// return Column(
//
// children:<Widget> [
// Radio(
// groupValue: attendance[state.list[index].docId],
// value: s,
// onChanged:(String? newValue) {
// print("onchange");
// print(newValue);
//
// //  print(empattendenceController.text);
// //    empattendenceController.text=newValue!;
// // attendance[state.list[index].docId!]=newValue!;
// setState(() {
// attendance[state.list[index].docId!]=newValue!;
// print(attendance);
// });
// },                    activeColor: Colors.deepPurpleAccent,
//
// ),
// Text(s,
// style: const TextStyle(
// color: Colors.black))
// ],
// ); }).toList(),

// ElevatedButton(onPressed: (){
//
// attendance.forEach((key, value) async{
// await userBloc?.updateAttendence(key, value);
// });
// }, child: const Text("updateattendence")),

// Row(
//   mainAxisAlignment:
//       MainAxisAlignment.spaceAround,
//   children: [
//     Expanded(
//       child: Row(
//         children: [
//           Radio<empattendence>(
//               value:
//                   empattendence.present,
//               groupValue: _empattendence,
//               onChanged:
//                   (empattendence? value) {
//                 setState(() {
//                   //map<id,atte>
//                   _empattendence = value;
//                   print(tempList.toString());
//
//                   if (tempList.contains(
//                       state.list[index].docId)) {
//                     print("alrady exist");
//                   } else {
//                     tempList.add({'id': state.list[index].docId, 'attendence': _empattendence});}
//                 });
//                 print(tempList);
//               }),
//           const Expanded(
//             child: Text('Present'),
//           )
//         ],
//       ),
//       flex: 1,
//     ),
//     Expanded(
//       child: Row(
//         children: [
//           Radio<empattendence>(
//               value: empattendence.absent,
//               groupValue: _empattendence,
//               onChanged:
//                   (empattendence? value) {
//                 setState(() {_empattendence = value;
//                   print(tempList.toString());
//
//                   if (tempList.contains(
//                       state.list[index].docId)) {
//                     print("alrady exist");
//                   } else {
//                     tempList.add({'id': state.list[index].docId, 'attendence': _empattendence
//                     });
//                   }
//                 });
//               }),
//           const Expanded(
//               child: Text('absent'))
//         ],
//       ),
//       flex: 1,
//     ),
//   ],
// ),
// Row(
//   mainAxisAlignment:
//       MainAxisAlignment.spaceAround,
//   children: [
//     Expanded(
//       child: Row(
//         children: [
//           Radio<empattendence>(
//               value: empattendence.firstHalf,
//               groupValue: _empattendence,
//               onChanged:
//                   (empattendence? value) {
//                 setState(() {_empattendence = value;
//
//                   print(tempList.toString());
//
//                   if (tempList.contains(state.list[index].docId)) {
//                     print("alrady exist");
//                   } else {
//                     tempList.add({'id': state.list[index].docId, 'attendence': _empattendence
//                     });
//                   }
//                 });
//               }),
//           const Expanded(
//             child: Text('firstHalf'),
//           )
//         ],
//       ),
//       flex: 1,
//     ),
//     Expanded(
//       child: Row(
//         children: [
//           Radio<empattendence>(
//               value: empattendence
//                   .secondHalf,
//               groupValue: _empattendence,
//               onChanged:
//                   (empattendence? value) {
//                 setState(() {_empattendence = value;
//                   if (tempList.contains(state.list[index].docId)) {
//                     print("alrady exist");
//                   } else {
//                     tempList.add({'id': state.list[index].docId,
//                       'attendence': _empattendence
//                     });
//                   }
//                 });
//               }),
//           const Expanded(
//               child: Text('secondHalf'))
//         ],
//       ),
//       flex: 1,
//     ),
//   ],
// ),
