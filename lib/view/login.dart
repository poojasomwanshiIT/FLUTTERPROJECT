import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:pagar_app_poc/navigation/app_navigation.dart';
import 'package:pagar_app_poc/image_resource/image_resource.dart';
import 'package:pagar_app_poc/ScreenHeader/Header.dart';

// import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'demo.dart';
import 'home.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";
  bool _isLoading = false;
  bool verified=false;
  final _Key = GlobalKey<FormState>();
  int? _resendToken;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //  backgroundColor:Colors.blueAccent ,
          // appBar: Header("Login"),
          body: SingleChildScrollView(
            child:Stack(
              children: [
                Visibility(
                  visible: !otpVisibility,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Column(
                        children: [
                          Visibility(
                              visible: !otpVisibility,
                              child: const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.0, bottom: 10, left: 20),
                                  child: Text('Login ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                          Visibility(
                            visible: !otpVisibility,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Center(
                                  child: Image.asset(ImageResource.user,
                                      height: 130, width: 130),
                                )),
                          ),
                          Visibility(
                            visible: !otpVisibility,
                            child: const Padding(
                                padding: EdgeInsets.only(top: 10.0, bottom: 10),
                                child: Center(
                                  child: Text('Pagar  ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold)),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.7,

                      left: 25,
                      right: 25),
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _Key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20,top: 10),
                            child: Visibility(
                              visible: !otpVisibility,
                              child: TextFormField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Phone Number',
                                  prefix: Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text('+91'),

                                  ),

                                  // prefixText: "+91",
                                ),
                                //autofocus: true,
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return "This field is required";
                                  }
                                  if (value!.length < 10) {
                                    return "Please enter a 10 digit valid phone number";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: otpVisibility,

                            child:   const SizedBox(
                              height: 80,
                            ),),
                          _isLoading
                              ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                backgroundColor: Colors.white,
                              ))
                              : ElevatedButton(
                            style: !otpVisibility? ElevatedButton.styleFrom(
                              //otpVisibility?  fixedSize: const Size(200, 50) :  fixedSize: const Size(200, 50),
                              fixedSize: const Size(120, 40),
                              primary: Colors.blueAccent,
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),

                            ):ElevatedButton.styleFrom(
                              //otpVisibility?  fixedSize: const Size(200, 50) :  fixedSize: const Size(200, 50),
                              fixedSize: const Size(200, 50),
                              primary: Colors.blueAccent,
                              textStyle: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              final isValidForm = _Key.currentState!.validate();

                              if (isValidForm) {
                                loginWithPhone();
                                setState(() {
                                  _isLoading = true;
                                });
                              }
                              if (otpVisibility) {
                                verifyOTP();
                                if (otpController.text != '') {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                }
                              }
                            },
                            child: Text(
                              otpVisibility ? "Verify" : "Login",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),

                            ),
                          ),
                          // const SizedBox(
                          //   child: Padding(padding: EdgeInsets.only(bottom: 10)),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  child: Visibility(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 5,top: 25),
                            child: Image.asset(
                              'assets/images/security.png',
                              height: 100,
                              width: 100,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 25,
                            ),
                            child: Text(
                              "Verification Code",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Enter 6 digit verification code sent on ",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10,),
                            child: Text(
                              "your mobile number ",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 30),
                          ),
                          OtpTextField(
                            numberOfFields: 6,
                            borderColor: Colors.black,
                            //set to true to show as box or false to show as dash
                            showFieldAsBox: true,
                            //runs when a code is typed in
                            onCodeChanged: (String code) {
                              setState(() {
                                otpController.text = code;
                              });
                              //handle validation or checks here
                            },
                            //runs when every textfield is filled
                            onSubmit: (String verificationCode) {
                              otpController.text = verificationCode;
                              if (otpController.text == '') {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }, // end onSubmit
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                          ),
                        ],
                      ),
                    ),
                    visible: otpVisibility,
                  ),
                ),
                Visibility(
                  visible: !otpVisibility,
                  child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 1.4, bottom: 10),
                      // child: Image.asset('assets/images/att.png',
                      child: ClipRRect(
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                          child: Image.asset('assets/images/att.png'),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 1.5,
                      height: 250),
                )
              ],
            ),
          ),



          ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+91" + phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('verifycalled');
        print("verify");
        // Sign the user in (or link) with the auto-generated credential
        //await auth.signInWithCredential(credential);

        // await auth.signInWithCredential(credential).then((value) {
        //   print("You are logged in successfully");
        // });
        setState(() {
          _isLoading = false;
          verified=true;
        });

      },
      verificationFailed: (FirebaseAuthException e) {
        print('failcalled');
        print("fail");
        print(e.message);
        setState(() {
          _isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        print('codesentcalled');
        print("codesent");
        otpVisibility = true;
        verificationID = verificationId;
      //  _resendToken = resendToken;
   //delay
   //      Timer(Duration(seconds: 2), ()=>{
   //        if(verified==false){
   //        otpVisibility = true,
   //        verificationID = verificationId,
   //        _resendToken = resendToken,
   //        }else{
   //          Navigator.pushAndRemoveUntil(
   //            context,
   //            MaterialPageRoute(builder: (context) => Home()),
   //                (Route<dynamic> route) => false,
   //          ),
   //      }
   //      });

        setState(() {
          _isLoading = false;
        });
      },
     // timeout: Duration(seconds: 80),
    //  forceResendingToken: _resendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _isLoading = false;
        });
      },
    );

    setState(() {
      _isLoading = false;
    });
  }
  // Future<void> _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }
  void verifyOTP() async {
    if (user != null){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false,
      );
    }
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);
print(otpController.text);
    if (otpController.text != '') {
      setState(() {
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          if (otpController.text != '') {
            setState(() {
              _isLoading = true;
            });
          }

          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () {
        if (user != null) {
          setState(() {
            _isLoading = true;
          });
          Fluttertoast.showToast(
            msg: "You are logged in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false,
          );
        } else if (otpController.text == '') {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Please enter otp",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          setState(() {
            _isLoading = false;
          });

          Fluttertoast.showToast(
            msg: "login failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
    );
  }
// void initState() {
//   super.initState();
//   checkPreviousSessionAndRedirect();
// }
}
// Material(
//     shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
//     elevation: 18.0,
//   color: Colors.indigo[900],
//     clipBehavior: Clip.antiAlias,
//     child:MaterialButton(
//     color: Colors.indigo[900],
//     minWidth: 200.0,
//     height: 35,
//     onPressed: () {
//       if (otpVisibility) {
//
//         verifyOTP();
//       } else {
//
//         loginWithPhone();
//         setState(() { _isLoading=true;
//         });
//       }
//     },
//     child: Text(
//       otpVisibility ? "Verify" : "Login",
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//       ),
//     ),
//   ),
// )
// _isLoading
// ? child: Center(
// child: CircularProgressIndicator(
// color: Colors.blue,
// backgroundColor: Colors.white,
// ),
// ),
// Visibility(
//   visible: !otpVisibility,
//   child: TextFormField(
//     controller: phoneController,
//     decoration: const InputDecoration(
//       border: OutlineInputBorder(),
//       hintText: 'Phone Number',
//       prefix: Padding(
//         padding: EdgeInsets.all(4),
//         child: Text('+91'),
//       ),
//     ),
//     maxLength: 10,
//     keyboardType: TextInputType.phone,
//     validator: (value) {
//       if (value != null && value.isEmpty) {
//         return "This field is required";
//       }
//       if (value!.length < 10) {
//         return "Please enter a 10 digit valid phone number";
//       }
//       return null;
//     },
//   ),
// ),        // Visibility(
//                         //   visible: !otpVisibility,
//                         //   child: Padding(
//                         //       padding: const EdgeInsets.only(top: 10.0),
//                         //       child: Center(
//                         //         child: Image.asset(ImageResource.user,
//                         //             height: 130, width: 130),
//                         //       )),
//                         // ),
//                         // Visibility(
//                         //   visible: !otpVisibility,
//                         //   child: const Padding(
//                         //       padding: EdgeInsets.only(top: 10.0, bottom: 40),
//                         //       child: Center(
//                         //         child: Text('Pagar Application ',
//                         //             style: TextStyle(
//                         //                 color: Colors.deepPurple,
//                         //                 fontSize: 25.0,
//                         //                 fontWeight: FontWeight.bold)),
//                         //       )),
//
//  // child:
//                 // Form(
//                 //   autovalidateMode: AutovalidateMode.onUserInteraction,
//                 //   key: _Key,
//                 //   child: Column(
//                 //     mainAxisAlignment: MainAxisAlignment.start,
//                 //     children: [
//                 //       Container(
//                 //
//                 //       ),
//                 //
//                 //       // Visibility(
//                 //       //   visible: !otpVisibility,
//                 //       //   child: Padding(
//                 //       //       padding: const EdgeInsets.only(top: 10.0),
//                 //       //       child: Center(
//                 //       //         child: Image.asset(ImageResource.user,
//                 //       //             height: 130, width: 130),
//                 //       //       )),
//                 //       // ),
//                 //       // Visibility(
//                 //       //   visible: !otpVisibility,
//                 //       //   child: const Padding(
//                 //       //       padding: EdgeInsets.only(top: 10.0, bottom: 40),
//                 //       //       child: Center(
//                 //       //         child: Text('Pagar Application ',
//                 //       //             style: TextStyle(
//                 //       //                 color: Colors.deepPurple,
//                 //       //                 fontSize: 25.0,
//                 //       //                 fontWeight: FontWeight.bold)),
//                 //       //       )),
//                 //       // ),
//                 //       Visibility(
//                 //         visible: !otpVisibility,
//                 //         child: TextFormField(
//                 //           controller: phoneController,
//                 //           decoration: const InputDecoration(
//                 //             hintText: 'Phone Number',
//                 //             prefix: Padding(
//                 //               padding: EdgeInsets.all(4),
//                 //               child: Text('+91'),
//                 //             ),
//                 //           ),
//                 //           maxLength: 10,
//                 //           keyboardType: TextInputType.phone,
//                 //           validator: (value) {
//                 //             if (value != null && value.isEmpty) {
//                 //               return "This field is required";
//                 //             }
//                 //             if (value!.length < 10) {
//                 //               return "Please enter a 10 digit valid phone number";
//                 //             }
//                 //             return null;
//                 //           },
//                 //         ),
//                 //       ),
//                 //
//                 //       Visibility(
//                 //         child: Center(
//                 //           child: Column(
//                 //             children: [
//                 //               Padding(
//                 //                 padding: EdgeInsets.only(left: 10, top: 20),
//                 //                 child: Image.asset(
//                 //                   'assets/images/security.png',
//                 //                   height: 100,
//                 //                   width: 100,
//                 //                 ),
//                 //               ),
//                 //               const Padding(
//                 //                 padding: EdgeInsets.only(
//                 //                   top: 30,
//                 //                 ),
//                 //                 child: Text(
//                 //                   "Verification Code",
//                 //                   style: TextStyle(
//                 //                       fontWeight: FontWeight.bold, fontSize: 22),
//                 //                 ),
//                 //               ),
//                 //               const Padding(
//                 //                 padding: EdgeInsets.only(top: 20),
//                 //                 child: Text(
//                 //                   "Enter 6 digit verification code sent on ",
//                 //                   style: TextStyle(fontSize: 16),
//                 //                 ),
//                 //               ),
//                 //               const Padding(
//                 //                 padding: EdgeInsets.only(top: 10),
//                 //                 child: Text(
//                 //                   "your mobile number ",
//                 //                   style: TextStyle(fontSize: 16),
//                 //                 ),
//                 //               ),
//                 //               const Padding(
//                 //                 padding: EdgeInsets.only(top: 20),
//                 //               ),
//                 //               OtpTextField(
//                 //                 numberOfFields: 6,
//                 //                 borderColor: Colors.black,
//                 //                 //set to true to show as box or false to show as dash
//                 //                 showFieldAsBox: true,
//                 //                 //runs when a code is typed in
//                 //                 onCodeChanged: (String code) {
//                 //                   setState(() {
//                 //                     otpController.text = code;
//                 //
//                 //                   });
//                 //                   //handle validation or checks here
//                 //                 },
//                 //                 //runs when every textfield is filled
//                 //                 onSubmit: (String verificationCode){
//                 //                   otpController.text = verificationCode;
//                 //                   if(otpController.text==''){
//                 //                     setState(() {
//                 //                       _isLoading = false;
//                 //                     });
//                 //                   }
//                 //                 }, // end onSubmit
//                 //               ),
//                 //
//                 //               const Padding(
//                 //                 padding: EdgeInsets.only(bottom: 20),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //         ),
//                 //         visible: otpVisibility,
//                 //       ),
//                 //       const SizedBox(
//                 //         height: 30,
//                 //       ),
//                 //       _isLoading
//                 //           ? const Center(
//                 //           child: CircularProgressIndicator(
//                 //             color: Colors.blue,
//                 //             backgroundColor: Colors.white,
//                 //           ))
//                 //           : ElevatedButton(
//                 //         style: ElevatedButton.styleFrom(
//                 //           fixedSize: const Size(200, 50),
//                 //           primary: Colors.blueAccent,
//                 //           textStyle: const TextStyle(
//                 //               fontSize: 20, fontWeight: FontWeight.bold),
//                 //         ),
//                 //         onPressed: () {
//                 //           final isValidForm = _Key.currentState!.validate();
//                 //
//                 //           if (isValidForm) {
//                 //             loginWithPhone();
//                 //             setState(() {
//                 //               _isLoading = true;
//                 //             });
//                 //           }
//                 //           if (otpVisibility) {
//                 //             verifyOTP();
//                 //             if(otpController.text!=''){
//                 //               setState(() {
//                 //                 _isLoading = true;
//                 //               });
//                 //             }
//                 //           }
//                 //         },
//                 //         child: Text(
//                 //           otpVisibility ? "Verify" : "Login",
//                 //           style: const TextStyle(
//                 //             color: Colors.white,
//                 //             fontSize: 20,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),),
// Container(
//   height: MediaQuery.of(context).size.height * 0.5,
//   width: MediaQuery.of(context).size.width,
//   margin: const EdgeInsets.all(10),
//   child:
//   Form(
//     autovalidateMode: AutovalidateMode.onUserInteraction,
//     key: _Key,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//
//         ),
//
//         Visibility(
//           visible: !otpVisibility,
//           child: Padding(
//               padding: const EdgeInsets.only(top: 10.0),
//               child: Center(
//                 child: Image.asset(ImageResource.user,
//                     height: 130, width: 130),
//               )),
//         ),
//         Visibility(
//           visible: !otpVisibility,
//           child: const Padding(
//               padding: EdgeInsets.only(top: 10.0, bottom: 40),
//               child: Center(
//                 child: Text('Pagar Application ',
//                     style: TextStyle(
//                         color: Colors.deepPurple,
//                         fontSize: 25.0,
//                         fontWeight: FontWeight.bold)),
//               )),
//         ),
//         Visibility(
//           visible: !otpVisibility,
//           child: TextFormField(
//             controller: phoneController,
//             decoration: const InputDecoration(
//               hintText: 'Phone Number',
//               prefix: Padding(
//                 padding: EdgeInsets.all(4),
//                 child: Text('+91'),
//               ),
//             ),
//             maxLength: 10,
//             keyboardType: TextInputType.phone,
//             validator: (value) {
//               if (value != null && value.isEmpty) {
//                 return "This field is required";
//               }
//               if (value!.length < 10) {
//                 return "Please enter a 10 digit valid phone number";
//               }
//               return null;
//             },
//           ),
//         ),
//
//         Visibility(
//           child: Center(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: 10, top: 20),
//                   child: Image.asset(
//                     'assets/images/security.png',
//                     height: 100,
//                     width: 100,
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(
//                     top: 30,
//                   ),
//                   child: Text(
//                     "Verification Code",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 22),
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(top: 20),
//                   child: Text(
//                     "Enter 6 digit verification code sent on ",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Text(
//                     "your mobile number ",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(top: 20),
//                 ),
//                 OtpTextField(
//                   numberOfFields: 6,
//                   borderColor: Colors.black,
//                   //set to true to show as box or false to show as dash
//                   showFieldAsBox: true,
//                   //runs when a code is typed in
//                   onCodeChanged: (String code) {
//                     setState(() {
//                       otpController.text = code;
//
//                     });
//                     //handle validation or checks here
//                   },
//                   //runs when every textfield is filled
//                   onSubmit: (String verificationCode){
//                     otpController.text = verificationCode;
//                     if(otpController.text==''){
//                       setState(() {
//                         _isLoading = false;
//                       });
//                     }
//                   }, // end onSubmit
//                 ),
//
//                 const Padding(
//                   padding: EdgeInsets.only(bottom: 20),
//                 ),
//               ],
//             ),
//           ),
//           visible: otpVisibility,
//         ),
//         const SizedBox(
//           height: 30,
//         ),
//         _isLoading
//             ? const Center(
//             child: CircularProgressIndicator(
//               color: Colors.blue,
//               backgroundColor: Colors.white,
//             ))
//             : ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             fixedSize: const Size(200, 50),
//             primary: Colors.blueAccent,
//             textStyle: const TextStyle(
//                 fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           onPressed: () {
//             final isValidForm = _Key.currentState!.validate();
//
//             if (isValidForm) {
//               loginWithPhone();
//               setState(() {
//                 _isLoading = true;
//               });
//             }
//             if (otpVisibility) {
//               verifyOTP();
//               if(otpController.text!=''){
//                 setState(() {
//                   _isLoading = true;
//                 });
//               }
//             }
//           },
//           child: Text(
//             otpVisibility ? "Verify" : "Login",
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// )