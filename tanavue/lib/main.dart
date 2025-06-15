import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Firebase config
import 'backend/server.dart'; // Local backend
import 'screens/home.dart'; // HydroDataScreen UI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Start local backend server
  final server = BackendServer();
  await server.startServer();

  // Launch app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanavue 2.1',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HydroDataScreen(),
    );
  }
}
