
import 'package:equatable/equatable.dart';
import 'package:pagar_app_poc/model/emp_model.dart';
abstract class UserState {
  const UserState();

  @override
  List<Object?> get props => [];
}
class UserLoading extends UserState{

}
class UserSuccess extends UserState{
  List<Employees> list;
  Map<String, String> attendance;

  UserSuccess(this.list,this.attendance);
  // late List<Employees> employees;
  // UserSuccess(List<Employees> employees );
  @override
  // TODO: implement props
  List<Object?> get props => [list,attendance];

}
class UserError extends UserState{
  late dynamic error;
  UserError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
// class ChangeAttendenceSuccess extends UserState{
//   Map<String, String>? attendance;
//   ChangeAttendenceSuccess(this.attendance);
// }