import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign In (Login)
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
      throw Exception(_getErrorMessage(e));
    }
  }

  /// Sign Up (Register)
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

  /// Logout
  Future<void> signOut() async {
    print("🚪 Signing out user: ${_auth.currentUser?.email}");
    await _auth.signOut();
    print("✅ Sign out success");
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Error message helper
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
      case 'wrong-password':
        return 'Password salah.';
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
