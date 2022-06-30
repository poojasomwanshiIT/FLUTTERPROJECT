
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pagar_app_poc/model/emp_model.dart';
abstract class UserEvent  {
const UserEvent();
@override
List<Object?> get props => [];
}
class UserLoadEvent extends UserEvent{

}

class UserSuccessEvent extends UserEvent {
  List<Employees> list;
  Map<String, String> attendance;

  UserSuccessEvent(this.list,this.attendance);

  // late QuerySnapshot<Map<String, Employees>> list;
  // UserSuccessEvent(this.list);
  @override
  // TODO: implement props
  List<Object?> get props => [list,attendance];
}
class UserErrorEvent extends UserEvent{
  dynamic error;
  UserErrorEvent(this.error);

}
class ChangeAttendenceEvent extends UserEvent{

   Map<String, String> attendance;
    ChangeAttendenceEvent(this.attendance);

}
