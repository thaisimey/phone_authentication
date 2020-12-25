import 'package:authen_phone/view/login_view.dart';
import 'package:authen_phone/view_model/login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {

  final User user;
  const HomeView(this.user);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {


  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(user.phoneNumber,style: TextStyle(color: Colors.red),),
            FlatButton(onPressed: () {
              _logout();
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoginView()));
            },
                color: Colors.red,
             child: Text("Sign out"))
          ],
        ),
      ),
    );
  }
}
