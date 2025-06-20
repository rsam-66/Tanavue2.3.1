import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class ProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create user profile in Firestore after signUp
  Future<void> createUserProfile(String uid, String email, String name) async {
    UserModel user = UserModel(uid: uid, email: email, name: name);
    await _db.collection('users').doc(uid).set(user.toMap());
  }

  // Get current user profile
  Future<UserModel?> getProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _db.collection('users').doc(user.uid).get();
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<String?> updateProfile(String name) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'User not found';

      await _db.collection('users').doc(user.uid).update({'name': name});
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
