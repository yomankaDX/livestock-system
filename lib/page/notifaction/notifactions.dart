import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

         actions: [
          // Add a refresh icon button
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
        title: const Text(
          'Firebase Realtime Database',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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

          print(data);
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
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,

                height: 200,
                decoration: BoxDecoration(color: Colors.grey  ,
                
                borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  
              
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
                                'TLocation ' + data['Location'].toString(),
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


