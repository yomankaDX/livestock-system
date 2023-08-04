import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:live_stock_tracking/page/notifaction/notifactions.dart';
import 'package:live_stock_tracking/page/page.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check login status from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}
class MyApp extends StatelessWidget {
    final bool isLoggedIn;

  const MyApp({super.key,required this.isLoggedIn});
 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ?MyHomePage(): LoginPage(),
    );
  }
}



//  Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings();
//     final MacOSInitializationSettings initializationSettingsMacOS =
//         MacOSInitializationSettings();
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//       macOS: initializationSettingsMacOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: (String? payload) async {
//         // Handle when a notification is tapped.
//       },
//     );
//   }

  