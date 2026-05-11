import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User?> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email.trim(), password: password);

      if (fullName != null && fullName.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(fullName.trim());
        await credential.user?.reload();
      }

      await _db.collection('users').doc(credential.user!.uid).set({
        'fullName': fullName?.trim() ?? 'Unknown User',
        'email': email.trim(),
        'bio': 'Hi! I am a Computer Science and Engineering student at Sabancı University.', // Default bio
        'createdAt': FieldValue.serverTimestamp(),
      });

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw _friendlyMessage(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _friendlyMessage(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _friendlyMessage(e);
    }
  }

  String _friendlyMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email': return 'The email address is not valid.';
      case 'user-disabled': return 'This account has been disabled.';
      case 'user-not-found': return 'No account found with this email.';
      case 'wrong-password': return 'Incorrect password. Please try again.';
      case 'invalid-credential': return 'Invalid email or password.';
      case 'email-already-in-use': return 'An account already exists for this email.';
      case 'operation-not-allowed': return 'Email/password sign-in is not enabled.';
      case 'weak-password': return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed': return 'Network error. Please check your connection.';
      case 'too-many-requests': return 'Too many attempts. Please try again later.';
      default: return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}