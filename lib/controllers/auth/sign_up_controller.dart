import 'package:firebase_auth/firebase_auth.dart';

class SignUpController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      print("📝 Trying to sign up: $email");
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("✅ Sign up success: ${cred.user?.uid}");
      return cred.user;
    } on FirebaseAuthException catch (e) {
      print("❌ Sign up failed: ${e.code} - ${e.message}");
      throw Exception(_getErrorMessage(e));
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Password terlalu lemah (minimal 6 karakter).';
      default:
        return e.message ?? 'Terjadi kesalahan tidak diketahui.';
    }
  }
}
