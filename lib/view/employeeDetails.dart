import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pagar_app_poc/model/emp_model.dart';

import '../ScreenHeader/Header.dart';
import 'package:pagar_app_poc/bloc/employee_bloc.dart';

class EmployeeDetails extends StatefulWidget {
  Employees emp;
  EmpBloc? userBloc;

  EmployeeDetails(this.emp, {Key? key}) : super(key: key);

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

String? empDob;

class _EmployeeDetailsState extends State<EmployeeDetails> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final experienceController = TextEditingController();

  final genderController = TextEditingController();

  final empidController = TextEditingController();
  EmpBloc? userBloc;
@override
  void initState() {
    // TODO: implement initState
  nameController.text = widget.emp.Name;
  emailController.text = widget.emp.email;
  mobileController.text=widget.emp.mobile;
  dobController.text=widget.emp.DOB;
  experienceController.text=widget.emp.experience;
  genderController.text=widget.emp.gender;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    userBloc = context.read<EmpBloc>();
    userBloc?.fetchUser();
    final _formsKey = GlobalKey<FormState>();

    String? gender = genderController.text;
    return Scaffold(
      appBar: Header('Edit Employee '),
      body:SingleChildScrollView(
     child:   Form(
         autovalidateMode: AutovalidateMode.onUserInteraction,
         key: _formsKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                padding: const EdgeInsets.only(
                    left: 30.0, top: 10.0, right: 30.0, ),
                child: TextFormField(
                  maxLength: 120,
                  validator: (value){
                    if(value != null && value.isEmpty ){
                      return "This field is required";
                    }
                    if( value!.length< 3){
                      return "Enter min. 3 and max 120 characters";
                    }
                    else{

                    }

                  },

                  decoration: const InputDecoration(
                    hintText: 'Enter employee name',
                    label: Text('Name'),
                    suffixIcon: Icon(
                      Icons.person,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  controller: nameController,

                ),
              ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 30.0, right: 30.0,),
                  child: TextFormField(

                    decoration: const InputDecoration(
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(5)),
                      hintText: 'Enter your Email',
                      label: Text('Email'),
                      suffixIcon: Icon(
                        Icons.email_rounded,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    validator: (value){
                      if(value != null && value.isEmpty ){
                        return "This field is required";
                      }
                      if (!RegExp('[a-z0-9]+@[a-z]+\.[a-z]{2,3}').hasMatch(value!)) {
                        return "Please enter a valid email address";
                      }
                    },
                    maxLength: 120,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,

                  ),

                ),
                Container(
                  padding:
                  const EdgeInsets.only(left: 30.0, bottom:10.0, right: 30.0),
                  child: TextFormField(
                    decoration: const InputDecoration(

                      label: Text('Mobile'),
                      hintText: 'Enter mobile number',
                      suffixIcon: Icon(
                        Icons.phone_android_rounded,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    validator: (value){
                      if(value != null && value.isEmpty ){
                        return "This field is required";
                      }
                      if (value!.length<10 ) {
                        return "Please enter a 10 digit valid phone number";
                      }
                      if (value.length>10 ) {
                        return "Please enter a 10 digit valid phone number";
                      }
                      return null;

                    },                    controller: mobileController,

                    keyboardType: TextInputType.phone,
                    maxLength: 10,

                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 5.0, right: 30.0, bottom: 10.0),
                  child: TextField(
                      controller: dobController,
                      decoration: const InputDecoration(
                        label: Text('Date Of Birth'),
                        hintText: 'Enter your DOB',
                        suffixIcon: Icon(
                          Icons.date_range_rounded,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1970),
                            lastDate: DateTime.now());
                        if (pickedDate != null) {

                          String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                          print(formattedDate);


                          setState(() {
                            empDob=formattedDate;
                            dobController.text = formattedDate;
                            print(empDob);
                          });
                        } else {
                          print("Date is not selected");
                        }
                      }),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 30.0,  right: 30.0, bottom: 10.0,top: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(

                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(5)),
                      hintText: 'Enter your experience in years',
                      label: Text('Experience'),
                      suffixIcon: Icon(
                        Icons.account_circle_sharp,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    validator: (value){
                      if(value != null && value.isEmpty ){
                        return "This field is required";
                      }return null;
                    }, maxLength: 2,

                    controller: experienceController,

                    keyboardType: TextInputType.number,
inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 20),
               ),
                ElevatedButton(onPressed: ()async{
                  final isValidForm=_formsKey.currentState!.validate();

                  // print(widget.emp.docId,
                  // );
                  // print("onpress");
                  // setState(() {
                  //   dobController.text=empDob!;
                  // });
                  // print(widget.emp.docId,
                  // );
                  // print(widget.emp.docId,
                  // );
                  if(nameController.text=='' || experienceController.text==''|| emailController.text=='' || mobileController.text.isEmpty){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text("Edit Failed!"),
                            titleTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 15),
                            content: Text("Please enter valid details"),
                          );
                        });
                  }if(isValidForm){

                    userBloc?.updateUser(
                      widget.emp.docId,
                      widget.emp.id,
                      nameController.text.trim(),
                      emailController.text,
                      mobileController.text,
                      dobController.text,
                      experienceController.text,
                      genderController.text,
                    );
                    Navigator.of(context,rootNavigator: true).pop(context,);
                  }





                },
                  child: const Text("Edit"),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    primary: Colors.blueAccent,
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),


//...
                )

              ],
            )
        ),
      )

    );
  }
}
