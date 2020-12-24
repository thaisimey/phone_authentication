import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  _registerUser(String mobile, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 15),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("verificationCompleted ${credential.smsCode} ${credential
              .token} ${credential.verificationId}");
            await _auth.signInWithCredential(credential);
            print("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("verificationFailed ${e.message}");
        },
        codeSent: (String verificationId, int resendToken) {
          print("On code sent : $verificationId $resendToken");

        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("codeAutoRetrievalTimeout $verificationId");
        },
      );
    } catch(e) {
      print("error ${e}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
            ),
            RaisedButton(
                color: Colors.orangeAccent,
                child: Text("Send"),
                onPressed: () {
                  _registerUser("+855123456789", context);
                }),
            TextField(
              decoration: InputDecoration(
                labelText: "Verification code"
              ),
            ),
            RaisedButton(
                color: Colors.orangeAccent,
                child: Text("Sign in"),
                onPressed: () {
                }),
          ],
        ),
      ),
    );

  }


}
