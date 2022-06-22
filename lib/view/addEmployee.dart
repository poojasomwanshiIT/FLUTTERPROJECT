import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../ScreenHeader/Header.dart';
import 'home.dart';

enum gender { male, female }

class AddEmp extends StatefulWidget {
  AddEmp({Key? key}) : super(key: key);

  CollectionReference users =
      FirebaseFirestore.instance.collection('Employees');

  @override
  _AddEmpState createState() => _AddEmpState();
}

class _AddEmpState extends State<AddEmp> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('Employees');

  late String dateFormats;


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

  @override
  Widget build(BuildContext context) {
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
                    left: 30.0, top: 10.0, right: 30.0, bottom: 10.0),
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
                    left: 30.0, top: 5.0, right: 30.0, bottom: 10.0),
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
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
                      return "Please enter a valid email address";
                    }
                  },
                  maxLength: 120,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 30.0, top: 5.0, right: 30.0),
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
                      Icons.account_circle_sharp,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  validator: (value){
                  if(value != null && value.isEmpty ){
                    return "This field is required";
                  }return null;
                }, maxLength: 2,

                  keyboardType: TextInputType.number,
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10),
                  child: Text('Gender', style: TextStyle(color: Colors.black))),
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
                        genderController.text = gender!;
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

                        genderController.text = gender!;
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
                  child: ElevatedButton(
                    onPressed: () async {
                      final isValidForm=_formKey.currentState!.validate();
                      if (isValidForm) {
                        String mobiledigit = mobileController.text.toString();
                        String lastsixdigit = mobiledigit.length >= 6
                            ? mobiledigit.substring(mobiledigit.length - 6)
                            : "";
                        String dob = datesformatController.text.toString();
                        String uniqueId = lastsixdigit + dob;
                        if(genderController.text!='female'){
                          setState(() {
                            genderController.text='male';
                          });
                        }
                        await users.add({
                          'Name': nameController.text,
                          'email': emailController.text,
                          'mobile': mobileController.text,
                          'gender': genderController.text,
                          'DOB': dobController.text,
                          'experience': experienceController.text,
                          'empId': uniqueId,
                          'attendence':'',
                        }).then((value) => print("user added"));

                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (context) => Home()));
                       Navigator.of(context,rootNavigator: true).pop(context,);
                      }
                    },
                    child: const Text("Add Employee"),
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

  @override
  void initState() {
    dobController.text = ""; //set the initial value of text field
    super.initState();
  }
}
