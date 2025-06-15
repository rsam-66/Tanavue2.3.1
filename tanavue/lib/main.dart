import 'package:flutter/material.dart';
import 'backend/server.dart'; // import backend buatan sendiri

void main() async {
  // Inisialisasi binding Flutter agar bisa menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Jalankan server lokal backend
  final server = BackendServer();
  await server.startServer();

  // Jalankan UI aplikasi Flutter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanavue 2.1',
      home: Scaffold(
        appBar: AppBar(title: const Text('Monitoring Tanaman')),
        body: const Center(child: Text('Halo dari Tanavue!')),
      ),
    );
  }
}
