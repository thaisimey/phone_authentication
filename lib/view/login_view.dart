import 'package:authen_phone/view/home_view.dart';
import 'package:authen_phone/view_model/login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _codeController = TextEditingController() ;
  // bool isLoggedIn = false;
  String phoneNumber = "";

  FirebaseAuth _auth = FirebaseAuth.instance;

  _registerUser(String mobile, BuildContext context) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 50),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("verificationCompleted ${credential.smsCode} ${credential
              .token} ${credential.verificationId}");

          UserCredential result = await _auth.signInWithCredential(credential);

          print("${result.user.displayName}");

            print("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("verificationFailed ${e.message}");
        },
        codeSent: (String verificationId, int resendToken) {
          print("On code sent : $verificationId $resendToken");
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text("Enter SMS Code"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),

                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Done"),
                    textColor: Colors.white,
                    color: Colors.redAccent,
                    onPressed: () async {
                      String smsCode = '';
                       smsCode = _codeController.text.trim();

                       print("Sms code $smsCode");

                      AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                      UserCredential result = await _auth.signInWithCredential(credential);

                      User user = result.user;

                      print("user aaaaaaaaaaaaaaaa $user");

                      if(user != null){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HomeView(user)
                        ));
                      }else{
                        print("Error");
                      }

                    },
                  )
                ],
              )
          );



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
          child: Column(
            children: [
              TextField(
              ),
              RaisedButton(
                  color: Colors.orangeAccent,
                  child: Text("Send"),
                  onPressed: () {
                    _registerUser("+855123456789", context);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Provider.of<LoginViewModel>(context, listen: false).checkLogin(false);
                    });
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
    );


  }


}
