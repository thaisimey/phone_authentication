import 'dart:async';

import 'package:authen_phone/model/phone_authen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LogIn {
  // static String _verificationId;

  // static void SignInWithPhone(String _smsController) async {
  //   try {
  //
  //     final AuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId,
  //       smsCode: _smsController,
  //     );
  //
  //     final User user = (await _auth.signInWithCredential(credential)).user;
  //
  //     print("Successfully signed in UID: ${user.uid}");
  //
  //   } catch (e) {
  //     print("Failed to sign in: ${e}");
  //   }
  // }

  Future<bool> verifyPhoneNumber(
      String _phoneNumberController) async {
    PhoneAuthentication phoneAuthentication;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController,
        timeout: const Duration(seconds: 30),
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential result = await _auth.signInWithCredential(credential);
          User user = result.user;

          print(
              "verificationCompleted ${credential.smsCode} ${credential.token} ${credential.verificationId}");
          // UserCredential result = await _auth.signInWithCredential(credential);
          // print("resutl ${result.user.displayName}");
          // print("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
          return user;
        },
        verificationFailed: (FirebaseAuthException e) {
          phoneAuthentication =
              new PhoneAuthentication(success: false, verificationId: "");
          print("verificationFailed ${e.message}");
          return null;
        },
        codeSent: (String verificationId, int resendToken) {
          print("On code sent : $verificationId $resendToken");

          phoneAuthentication = new PhoneAuthentication(
              success: true, verificationId: verificationId);
          print(
              "onCodeSent : ${phoneAuthentication.success} ${phoneAuthentication.verificationId}");
          return phoneAuthentication;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          phoneAuthentication = new PhoneAuthentication(
              success: false, verificationId: verificationId);
          print("codeAutoRetrievalTimeout $verificationId");
          return phoneAuthentication;
        },
      );
    } catch (e) {
      print("Failed to Verify Phone Number: ${e}");
      return null;
    }
    return null;
  }
}
