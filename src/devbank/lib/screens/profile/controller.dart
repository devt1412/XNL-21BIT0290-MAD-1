import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<void>>(
  (ref) => ProfileController(),
);

class ProfileController extends StateNotifier<AsyncValue<void>> {
  ProfileController() : super(const AsyncData(null));

  Future<void> saveProfile(
      String username, String phoneNumber, String email, String uid) async {
    state = const AsyncLoading();
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(uid).set({
        'username': username,
        'phoneNumber': phoneNumber,
        'email': email,
      }, SetOptions(merge: true));

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
