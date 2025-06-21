import 'package:firebase_auth/firebase_auth.dart';

class SignInController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      print("🔐 Trying to sign in: $email");
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("✅ Login success: ${cred.user?.uid}");
      return cred.user;
    } on FirebaseAuthException catch (e) {
      print("❌ Login failed: ${e.code} - ${e.message}");
      if (e.code == 'user-not-found') {
        throw Exception(
            'Akun belum terdaftar. Silakan daftar terlebih dahulu.');
      }
      throw Exception(_getErrorMessage(e));
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
        return 'Password salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      default:
        return e.message ?? 'Terjadi kesalahan tidak diketahui.';
    }
  }
}
