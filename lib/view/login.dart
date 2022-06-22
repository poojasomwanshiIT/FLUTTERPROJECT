import 'package:firebase_auth/firebase_auth.dart';
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
  final _Key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: Header("Login"),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _Key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                      padding: EdgeInsets.only(top: 10.0, bottom: 40),
                      child: Center(
                        child: Text('Pagar Application ',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
                Visibility(
                  visible: !otpVisibility,
                  child: TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                      prefix: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text('+91'),
                      ),
                    ),
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

                Visibility(
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Image.asset(
                            'assets/images/security.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 30,
                          ),
                          child: Text(
                            "Verification Code",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "Enter 6 digit verification code sent on ",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "your mobile number ",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
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
                          onSubmit: (String verificationCode){
                            otpController.text = verificationCode;
                          }, // end onSubmit
                        ),

                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                      ],
                    ),
                  ),
                  visible: otpVisibility,
                ),
                const SizedBox(
                  height: 30,
                ),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.blue,
                        backgroundColor: Colors.white,
                      ))
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
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
                            setState(() {
                              _isLoading = false;
                            });
                            verifyOTP();
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
              ],
            ),
          ),
        ));
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+91" + phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
        setState(() {
          _isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        setState(() {
          _isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;

      },
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

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () {
        if (user != null) {
          Fluttertoast.showToast(
            msg: "You are logged in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false,
            );
        } else {
          Fluttertoast.showToast(
            msg: "your login is failed",
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
