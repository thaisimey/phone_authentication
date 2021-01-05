import 'dart:async';

import 'package:authen_phone/repo/sign_in_phone.dart';
import 'package:authen_phone/view/home_view.dart';
import 'package:authen_phone/view_model/login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();

  final _text = TextEditingController();
  // bool isLoggedIn = false;
  String phoneNumber = "";

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isStart;
  bool isSendCode = false;
  Timer _timer;
  int _start = 30;
  bool _validate = false;
  String _verificationId;
  LogIn logIn = LogIn();


  void startTimer() {

    _timer = new Timer.periodic(
      Duration(seconds: 1), (Timer timer) {
        // print('time ${timer.tick}');
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isStart = false;
            _start = 30;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );

  }

  _registerUser(String mobile, BuildContext context) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(minutes: 1),
        verificationCompleted: (PhoneAuthCredential credential) async {

          UserCredential result = await _auth.signInWithCredential(credential);
          User user = result.user;

          if(user != null){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => HomeView(user)
            ));
          }else{
            print("Error");
          }

          print("verificationCompleted ${credential.smsCode} ${credential.token} ${credential.verificationId}");
          // UserCredential result = await _auth.signInWithCredential(credential);
          // print("resutl ${result.user.displayName}");
          // print("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");

        },
        verificationFailed: (FirebaseAuthException e) {
          print("verificationFailed ${e.message}");
        },

        codeSent: (String verificationId, int resendToken) {
          print("On code sent : $verificationId $resendToken");

          _verificationId = verificationId;
          // showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) => AlertDialog(
          //       title: Text("Enter SMS Code"),
          //       content: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: <Widget>[
          //           TextField(
          //             controller: _codeController,
          //
          //           ),
          //
          //         ],
          //       ),
          //       actions: <Widget>[
          //         FlatButton(
          //           child: Text("Done"),
          //           textColor: Colors.white,
          //           color: Colors.redAccent,
          //           onPressed: () async {
          //             try {
          //               String smsCode = '';
          //               smsCode = _codeController.text.trim();
          //
          //               print("Sms code $smsCode");
          //               AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
          //               UserCredential result = await _auth.signInWithCredential(credential);
          //               User user = result.user;
          //               print("user aaaaaaaaaaaaaaaa $user");
          //
          //               if(user != null){
          //                 Navigator.push(context, MaterialPageRoute(
          //                     builder: (context) => HomeView(user)
          //                 ));
          //               }else{
          //                 print("Error");
          //               }
          //             } catch(e) {
          //               print("error confirm code");
          //             }
          //           },
          //         )
          //       ],
          //     )
          // );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("codeAutoRetrievalTimeout $verificationId");
        },
      );

    } catch(e) {
      print("error ${e}");
    }
  }

  Future<User> inputData() {
    String uid;
    User user;
    try {
      user = _auth.currentUser;
      if(user != null) {
        uid = user.uid;
        print("UID ${uid}");
      }
    } catch(e) {
      print('error get current suer $e');
    }
    return Future.value(user);
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LoginViewModel>(context, listen: false).isLoggedIn;
    });


    if(_auth.currentUser != null) {
      phoneNumber = _auth.currentUser.phoneNumber;
    }

    isStart = false;

  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: inputData(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
    if (snapshot.hasData){
      User user = snapshot.data;
      return HomeView(user);
    } else {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _phoneController,
                ),
                RaisedButton(
                    color: Colors.orangeAccent,
                    child: Text("Send"),
                    onPressed: () {
                      // _registerUser("+85561281701", context);
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Provider.of<LoginViewModel>(context, listen: false).checkLogin(false);
                      });
                    }),
                // Padding(
                //   padding: const EdgeInsets.only(left:18.0,right: 18.0),
                //   child: TextField(
                //     controller: _text,
                //     decoration: InputDecoration(
                //         // labelText: "Verification code",
                //         prefixText: "+855 ",
                //       errorText: _validate ?  'Invalid Phone Number' : null,
                //       suffixIcon:
                //       (isStart == true && _validate == false)
                //           ? Align(alignment: Alignment.centerRight,child: Text("( $_start )"))
                //           : IconButton(icon: Icon(Icons.send),onPressed: (){
                //         setState(() {
                //           _text.text.isEmpty ? _validate = true : _validate = false;
                //           isStart = true;
                //         });
                //         if(isStart == true && _validate == false) {
                //           startTimer();
                //         }
                //
                //
                //       })
                //     ),
                //   ),
                // ),

                RaisedButton(
                    color: Colors.orangeAccent,
                    child: Text("Sign in"),
                    onPressed: () {
                    }),

                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        controller: _text,
                        decoration: InputDecoration(
                          labelText: 'verify code',
                          prefixIcon: Icon(Icons.sms),
                          errorText: _validate ?  'Invalid Phone Number' : null,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      FlatButton(
                        onPressed: () async {
                          setState(() {
                            _text.text.isEmpty ? _validate = true : _validate = false;
                            isStart = true;
                          });
                          if(isStart == true && _validate == false) {
                            startTimer();
                          }
                          setState(() {
                            isSendCode = true;
                          });

                          // _registerUser("+855${_text.text}", context);

                          logIn.verifyPhoneNumber("+855${_text.text}").then((value) => {
                            print("result phone authen ${value}")
                          });

                        },
                        textTheme: ButtonTextTheme.primary,
                        child: (isStart == true && _validate == false)
                          ? Text('( $_start )') : Text('send sms')
                      ),




                    ],
                  ),
                ),


                isSendCode ? TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                      labelText: "Code"
                  ),
                ) : SizedBox.shrink(),

                RaisedButton(
                    color: Colors.orangeAccent,
                    child: Text("Send"),
                    onPressed: () async {
                      String smsCode = '';
                      smsCode = _codeController.text.trim();

                      print("Sms code $smsCode");
                      AuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: smsCode);
                      UserCredential result = await _auth.signInWithCredential(credential);
                      User user = result.user;

                      if(user != null) {
                        Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomeView(user)));
                      } else {
                        print("error");
                      }


                    }),


              ],
            ),
          ),
        ),
      );
    }
      }
    );


  }


}
