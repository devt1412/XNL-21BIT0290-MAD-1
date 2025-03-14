import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<void>>(
  (ref) => LoginController(),
);

class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController() : super(const AsyncData(null));

  Future<bool> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncData(null);
      return true; // Login successful
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
      return false; // Login failed
    }
  }
}
