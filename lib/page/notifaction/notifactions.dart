import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:live_stock_tracking/page/page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notifactionModel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final reference = FirebaseDatabase.instance.reference().child('Sensors');


    Future<void> _refreshData() async {
    setState(() {});
  }
  List sensorDataList = [];
  final FlutterLocalNotificationsPlugin _localNotificationService =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    _localNotificationService.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        
        // Handle notification taps when the app is in the foreground
        // Implement your navigation logic here if needed
      },
    );

    requestNotificationPermission();
  }


  Future<void> requestNotificationPermission() async {
    final settings = await _localNotificationService.getNotificationAppLaunchDetails();
    if (settings?.didNotificationLaunchApp ?? false) {
      // The app was opened from a notification, handle as needed
    }

    var settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var settingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: settingsAndroid,
      iOS: settingsIOS,
    );
    await _localNotificationService.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        // Handle notification taps when the app is in the foreground
        // Implement your navigation logic here if needed
      },
    );

    final bool? alreadyGranted = await _localNotificationService
        .getNotificationAppLaunchDetails()
        .then((details) => details?.didNotificationLaunchApp);
    if (alreadyGranted != null && !alreadyGranted) {
      await _localNotificationService
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await _localNotificationService
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            AndroidNotificationChannel(
              'channel_id',
              'channel_name',
             
              importance: Importance.max,
             
            ),
          );
    }
  }
  // ...



  Future<void> _showDataAddedNotification(String message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotificationService.show(
      0,
      'New Messeage LiveStock Tracker',
      message,
      platformChannelSpecifics,
      payload: 'data_added_payload',
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 65, 20, 244),

         actions: [
          // Add a refresh icon button
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),

          IconButton(onPressed: () async {
             SharedPreferences prefs = await SharedPreferences.getInstance();
             await prefs.clear();
           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
          }, icon: Icon(Icons.logout))
        ],
        title: Row(
          children: [
            const Text(
              'Live Stock Tracker Messages',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              
            ),
            SizedBox(width: 5,),
            Icon(Icons.notifications_active),
          ],
        ),

      ),
      body: StreamBuilder(
        stream: reference.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return Text('No data available.');
          }

          dynamic data = snapshot.data!.snapshot.value;

          // print(data);
          if (data is List) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
              
                // Create your list item widget using the data.
                return ListTile(
                  title: Text(data[index]['your_field']),
                );
              },
            );
          } else if (data is Map) {

             _showDataAddedNotification(data.toString());
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,

                height: 240,
                decoration: BoxDecoration(color: Color.fromARGB(255, 242, 2, 210)  ,
                
                borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.message,color: Colors.white,),
                      ],
                    ),
                  ),
                  
              
                    SizedBox(
                              height: 6,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Magnitude: ' + data['Magnitude'].toString(),
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Humidity: ' + data['Humidity'].toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ),
                           
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(' Heartbeat: ' + data['Heartbeat'].toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ),

                             Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Temperature: ' + data['Temperature'].toString(),
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w500)),
                        ),
              


                InkWell(
                  onTap: (){

                    _openGoogleMaps(data['Location']);
                  },
                  child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                'Location ' + data['Location'].toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 2, 18, 236), fontWeight: FontWeight.w500)),
                          ),
                ),
              
                       
                ],
                        ),
              ),
            );
          }

          return Text('Invalid data type.');
        },
      ),
    );
  }

 void _openGoogleMaps(String longitude) async {
  final String url = "$longitude";
try{
   if (await canLaunch(url)) {
    await launch(url);
  } else {
  
  }


}catch(e){

  print(e);
}

 
}

}


