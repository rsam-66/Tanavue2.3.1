import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HydroDataScreen extends StatefulWidget {
  const HydroDataScreen({super.key});

  @override
  State<HydroDataScreen> createState() => _HydroDataScreenState();
}

class _HydroDataScreenState extends State<HydroDataScreen> {
  DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref("hidroponik/current");

  double? humidity, tempDHT, tempDS;
  String? error, timestamp;

  @override
  void initState() {
    super.initState();
    _listenToData();
  }

  void _listenToData() {
    _dbRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          humidity = data['humidity']?.toDouble();
          tempDHT = data['tempDHT']?.toDouble();
          tempDS = data['tempDS']?.toDouble();
          timestamp = data['timestamp']?.toString();
        });
      } else {
        setState(() {
          error = "No data found.";
        });
      }
    }, onError: (error) {
      setState(() {
        this.error = "Failed to fetch data: \$error";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monitoring Tanaman")),
      body: Center(
        child: error != null
            ? Text(error!)
            : humidity == null
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Humidity: $humidity%",
                          style: const TextStyle(fontSize: 20)),
                      Text("Temprature: $tempDHT°C",
                          style: const TextStyle(fontSize: 20)),
                      Text("Water Temprature: $tempDS°C",
                          style: const TextStyle(fontSize: 20)),
                      Text("Last Updated: $timestamp",
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
      ),
    );
  }
}
