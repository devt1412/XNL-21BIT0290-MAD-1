import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Initialize Firebase
final firebaseProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});
