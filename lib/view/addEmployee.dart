import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../ScreenHeader/Header.dart';
import '../bloc/employee_bloc.dart';
import '../model/emp_model.dart';
import 'home.dart';

enum gender { male, female }

class AddEmp extends StatefulWidget {
  Employees? emp;
  EmpBloc? userBloc;
   bool isEditon;
  AddEmp(  {Key? key,required this.isEditon,this.emp}) : super(key: key);


  CollectionReference users = FirebaseFirestore.instance.collection('Employees');

  @override
  _AddEmpState createState() => _AddEmpState();
}

class _AddEmpState extends State<AddEmp> {
  CollectionReference users = FirebaseFirestore.instance.collection('Employees');

  late String dateFormats;
String? buttonText="Add Employee";
  bool genderText=false;

  Employees? emp;
  EmpBloc? userBloc;
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final experienceController = TextEditingController();
  final dobController = TextEditingController();
  final datesformatController = TextEditingController();
  final empidController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? gender = 'male';
  bool _isLoading = false;
  @override
  void initState() {
    dobController.text = ""; //set the initial value of text field
    if(widget.isEditon){
      nameController.text = widget.emp?.Name?? '';
      emailController.text = widget.emp?.email?? '';
      mobileController.text=widget.emp?.mobile?? '';
      dobController.text=widget.emp?.DOB?? '';
      experienceController.text=widget.emp?.experience?? '';
     // genderController.text=widget.emp?.gender?? '';
      gender=widget.emp?.gender?? '';
      buttonText="Edit Employee";
      genderText=true;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    userBloc = context.read<EmpBloc>();
    userBloc?.fetchUser();
    return Scaffold(
      appBar: Header("Add Employees"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    left: 30.0, top: 10.0, right: 30.0),
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
                  return null;
                }
                  },

                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter employee name',
                    label: Text('Name'),
                    suffixIcon: Icon(
                      Icons.person,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),

                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0,),
                child: TextFormField(

                  controller: emailController,
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
                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)) {
                      //RegExp("([!#-'*+/-9=?A-Z^-~-]+(\.[!#-'*+/-9=?A-Z^-~-]+)*|\"\(\[\]!#-[^-~ \t]|(\\[\t -~]))+\")@([!#-'*+/-9=?A-Z^-~-]+(\.[!#-'*+/-9=?A-Z^-~-]+)*|\[[\t -Z^-~]*])")
                      return "Please enter a valid email address";
                    }
                  },
                  maxLength: 120,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 30.0, bottom: 10.0, right: 30.0),
                child: TextFormField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(5)),
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

                  },
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 30.0, top: 10.0, right: 30.0, bottom: 10.0),
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
                        //    print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        dateFormats = DateFormat('ddMMyyyy').format(pickedDate);
                        //print(dateFormats);
                        datesformatController.text = dateFormats;
                        //   print(formattedDate); //formatted date output using intl package =>  2021-03-16

                        setState(() {
                          dobController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    }),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 30.0, top: 5.0, right: 30.0, bottom: 15.0),
                child: TextFormField(
                  controller: experienceController,
                  decoration: const InputDecoration(
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(5)),
                    hintText: 'Enter your experience in years',
                    label: Text('Experience'),
                    suffixIcon: Icon(
                      Icons.work,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  validator: (value){
                  if(value != null && value.isEmpty ){
                    return "This field is required";
                  }return null;
                }, maxLength: 2,

                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              Visibility(

                visible: genderText,
                child: const Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10),
                  child: Text('Gender', style: TextStyle(color: Colors.black))),),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 50)),
                  Radio(
                    value: 'male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value! as String?;
                        //genderController.text = gender!;
                      });
                    },
                    activeColor: Colors.deepPurpleAccent,
                  ),
                  const Expanded(child: Text("Male")),
                  Radio(
                    value: 'female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value as String?;

                        //genderController.text = gender!;
                      });
                    },
                    activeColor: Colors.deepPurpleAccent,
                  ),
                  const Expanded(child: Text("Female")),
                ],
              ),
               const Padding(

                padding: EdgeInsets.only(bottom: 30),
              ),
              Align(
                child: Center(
                  child:_isLoading
                      ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        backgroundColor: Colors.white,
                      )): ElevatedButton(
                    onPressed: () async {
                      print(widget.isEditon);
                      final isValidForm=_formKey.currentState!.validate();
                      if(  dobController.text==''||
                          nameController.text=='' ||
                          experienceController.text==''||
                          emailController.text=='' ||
                          mobileController.text.isEmpty)
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return  AlertDialog(
                                title: Text(buttonText!+" "+'failed'),
                                titleTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontSize: 20),
                                content: const Text("Please fill all details"),
                              );
                            });
                      }
                      if (isValidForm && dobController.text!='' && buttonText=="Add Employee") {
                        _isLoading=true;
                        String mobiledigit = mobileController.text.toString();
                        String lastsixdigit = mobiledigit.length >= 6
                            ? mobiledigit.substring(mobiledigit.length - 6)
                            : "";
                        String dob = datesformatController.text.toString();
                        String uniqueId = lastsixdigit + dob;
                        // if(genderController.text!='female'){
                        //   setState(() {
                        //     genderController.text='male';
                        //   });
                        // }
                        String names=nameController.text.trim();
                        userBloc?.AddUser(
                            nameController.text.trim(),
                            emailController.text,
                            mobileController.text ,

                            dobController.text,
                            experienceController.text,
                            gender,
                            //genderController.text,
                            uniqueId,
                            ''
                        );
                        // await users.add({
                        //   'Name': nameController.text.trim(),
                        //   'email': emailController.text,
                        //   'mobile': mobileController.text,
                        //   'gender': genderController.text,
                        //   'DOB': dobController.text,
                        //   'experience': experienceController.text,
                        //   'empId': uniqueId,
                        //   'attendence':'',
                        // }).then((value) => print("user added"));
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                       //Navigator.of(context,rootNavigator: true).pop(context,);
                      }

                   if(isValidForm && buttonText=="Edit Employee"){

                        userBloc?.updateUser(
                          widget.emp?.docId,
                          widget.emp?.id,
                          nameController.text.trim(),
                          emailController.text,
                          mobileController.text,
                          dobController.text,
                          experienceController.text,
                          gender,

                          //genderController.text,
                        );
                        Navigator.of(context,rootNavigator: true).pop(context,);
                      }
                    },
                    child:  Text(buttonText!),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                      primary: Colors.deepPurpleAccent,
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }


}
