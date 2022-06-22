import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pagar_app_poc/bloc/employee_bloc.dart';
import 'package:pagar_app_poc/repository/base_repo.dart';
import 'package:pagar_app_poc/service/emp_service.dart';
import 'package:get_it/get_it.dart';


final factory=GetIt.instance;
Future<void> init() async{


  //repository
  factory.registerLazySingleton(() => BaseRepo());


  //service
  factory.registerLazySingleton(() => EmpService(firebaseFirestore: factory()));



  //bloc
//factory.registerLazySingleton(() => EmpBloc(factory()));
factory.registerLazySingleton(() => FirebaseFirestore);
}
