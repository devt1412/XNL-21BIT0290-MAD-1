import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'model.dart';
import 'firebase_providers.dart';

final signupControllerProvider =
    StateNotifierProvider<SignupController, AsyncValue<UserModel?>>((ref) {
  final auth = ref.watch(firebaseProvider);
  return SignupController(auth);
});

class SignupController extends StateNotifier<AsyncValue<UserModel?>> {
  final FirebaseAuth _auth;
  SignupController(this._auth) : super(const AsyncValue.data(null));

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel.fromFirebase(userCredential.user!);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
