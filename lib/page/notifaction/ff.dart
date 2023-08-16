import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class MyHomePage2 extends StatelessWidget {
  final reference = FirebaseDatabase.instance.reference().child('Sensors');
  final FlutterLocalNotificationsPlugin _localNotificationService =
      FlutterLocalNotificationsPlugin();

  MyHomePage2() {
    // Initialize the local notifications plugin
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
  }

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
      'New Data Added',
      message,
      platformChannelSpecifics,
      payload: 'data_added_payload',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Firebase Realtime Databasesss',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: reference.onChildAdded,
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

          final newData = snapshot.data!.snapshot.value;
          final validData = _parseSensorData(newData);

          if (validData == null) {
            // Invalid data, ignore
            return Container();
          }

          // Show local notification when new data is added
          _showDataAddedNotification(validData.toString());

          return ListTile(
            title: Text('New Data Added'),
            subtitle: Text(validData.toString()),
          );
        },
      ),
    );
  }

  Map<String, dynamic>? _parseSensorData(dynamic data) {
    if (data is Map &&
        data.containsKey('Magnitude') &&
        data.containsKey('Humidity') &&
        data.containsKey('Heartbeat') &&
        data.containsKey('Temperature') &&
        data.containsKey('Location')) {
      final magnitude = data['Magnitude'];
      final humidity = data['Humidity'];
      final heartbeat = data['Heartbeat'];
      final temperature = data['Temperature'];
      final location = data['Location'];

      if (magnitude is num &&
          humidity is num &&
          heartbeat is num &&
          temperature is num) {
        return {
          'Magnitude': magnitude,
          'Humidity': humidity,
          'Heartbeat': heartbeat,
          'Temperature': temperature,
          'Location': location,
        };
      }
    }
    return null;
  }
}
