import 'package:authen_phone/view/home_view.dart';
import 'package:authen_phone/view/login_view.dart';
import 'package:authen_phone/view/notification_view.dart';
import 'package:authen_phone/view/website_view.dart';
import 'package:authen_phone/view_model/login_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: LoginViewModel()),

    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static final navigationKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification();
  }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void notification() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        navigationKey.currentState.pushNamed("/notification_view");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        navigationKey.currentState.pushNamed("/home_login");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        navigationKey.currentState.pushNamed("/web_view");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NotificationView(),
      onGenerateRoute: routes,
      navigatorKey: navigationKey,
    );
  }

   Route routes(RouteSettings settings) {
    if(settings.name == "/notification_view") {
      return MaterialPageRoute(builder: (BuildContext context) {
        return NotificationView();
      });
    } else if(settings.name == "/home_login") {
      return MaterialPageRoute(builder: (BuildContext context) {
        return LoginView();
      });
    } else if(settings.name == "/web_view") {
      return MaterialPageRoute(builder: (BuildContext context) {
        return WebsiteView();
      });
    }

   }
}