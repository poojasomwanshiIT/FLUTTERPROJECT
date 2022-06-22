
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'employee_event.dart';
import 'employee_state.dart';
import 'package:pagar_app_poc/model/emp_model.dart';
import 'package:flutter/services.dart';
import 'package:pagar_app_poc/service/emp_service.dart';
/*enum UserEvent{
  LOADING,
  SUCCESS,
  ERROR
}*/



class EmpBloc extends Bloc<UserEvent,UserState>{
  final EmpService _service=EmpService.instance;
  StreamSubscription? _empSubscription;

EmpBloc():super(UserLoading()){
  on<UserLoadEvent>((event, emit) => emit(UserLoading()));
    on<UserSuccessEvent>((event, emit) => emit(UserSuccess(event.list)));
    on<UserErrorEvent>((event, emit) => emit(UserError(event.error)));
}


  fetchUser() async {
    add(UserLoadEvent());
    List<Employees> result = (await _service.retrieveUserData());
//     print("in bloc");
//     print(result);
//     print("in bloc");
// print(UserSuccess);
    add(UserSuccessEvent(result));
   // print(UserSuccessEvent(result));


  }
  updateUser(docId,id, Name, email, mobile, DOB, experience, gender)async{
    add(UserLoadEvent());
Future<dynamic> result = await _service.updateUser(docId,id, Name, email, mobile, DOB, experience, gender);
print(gender);
    print("BLOC");
    print(gender);

fetchUser();
  }
  updateAttendence(docId,attendence)async{
    add(UserLoadEvent());
    Future<dynamic> result = await _service.updateAttendence(docId,attendence);
    print(attendence);
    print("BLOC");
    print(attendence);

    fetchUser();
  }
 }
//  fetchEmp() async {
//     add(UserLoadEvent());
//     <Employees>> result = await _service.getAllEmployees().listen((employees) =>{
//       add(UserSuccessEvent(employees))
//
//        // result.fold(
//     //         (l) => add(UserErrorEvent(l)),
//     //         (employees) => add(UserSuccessEvent(employees))
//     // );
//
//
//
//     // result.fold(
//     //         (l) => add(UserErrorEvent(l)),
//     //         (employees) => add(UserSuccessEvent(employees))
//     // );});