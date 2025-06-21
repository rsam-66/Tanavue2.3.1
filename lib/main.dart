import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import semua screen yang akan digunakan dalam rute navigasi
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/monitoring_screen.dart';
import 'screens/panen_screen.dart';
import 'screens/profile_page.dart'; // Nama file untuk ProfileSettingsScreen

void main() async {
  // Blok ini tidak berubah, sudah benar untuk inisialisasi Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tanavue',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),

      // --- PERUBAHAN UTAMA DI SINI ---

      // 1. Tentukan rute awal aplikasi.
      // Aplikasi akan dimulai dari '/login'.
      initialRoute: '/login',

      // 2. Hapus properti 'home'. 'initialRoute' dan 'routes' akan menggantikannya.

      // 3. Definisikan semua rute bernama (named routes) yang digunakan di aplikasi Anda.
      // Ini adalah "peta" yang memberi tahu Flutter screen mana yang harus ditampilkan
      // untuk setiap nama rute.
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/monitoring': (context) => const MonitoringDataScreen(),
        '/panen': (context) => const PanenScreen(),
        '/profile': (context) =>
            const ProfileSettingsScreen(), // Pastikan nama kelas benar
      },
    );
  }
}
