import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:devbank/shared/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:devbank/shared/widgets/custombutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devbank/shared/widgets/customsnackbar.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isVerifying = false;
  bool _isEmailVerified = false;
  User? _user;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        _user = userCredential.user;

        showCustomSnackbar(
          context: context,
          text: "Account created! Please verify your email.",
          color: AppColors.primary100,
        );

        await _user!.sendEmailVerification();

        setState(() {});
      } catch (e) {
        showCustomSnackbar(
          context: context,
          text: "Sign up failed: $e",
          color: AppColors.warningColorDark,
        );
      }
    }
  }

  Future<void> _checkEmailVerified() async {
    if (_user == null) return;

    setState(() {
      _isVerifying = true;
    });

    await _user!.reload(); // Refresh user status
    await Future.delayed(
        const Duration(seconds: 2)); // Give Firebase some time to update

    bool isVerified = _auth.currentUser!.emailVerified;

    setState(() {
      _isVerifying = false;
      _isEmailVerified = isVerified;
    });

    if (_isEmailVerified) {
      showCustomSnackbar(
        context: context,
        text: "Email verified successfully! You can now log in.",
        color: AppColors.primary100,
      );
      Navigator.pushNamed(context, '/profile');
    } else {
      showCustomSnackbar(
        context: context,
        text: "Email is not verified yet. Please check again.",
        color: AppColors.warningColorDark,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary500, AppColors.primary100],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),

          // Content
          Column(
            children: [
              SizedBox(height: size.height * 0.25),
              Text(
                "Sign Up",
                style: GoogleFonts.lato(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Curved Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(27),
                      topRight: Radius.circular(27),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: AppColors.primary100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: AppColors.primary100, width: 2),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains("@")) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: AppColors.primary100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: AppColors.primary100, width: 2),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          // Confirm Password Field
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: AppColors.primary100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: AppColors.primary100, width: 2),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Signup Button
                          Center(
                            child: Custombutton(
                              text: "Sign Up",
                              type: ButtonType.filled,
                              onPressed: _signUp,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Email Verification Button
                          _user != null && !_isEmailVerified
                              ? Center(
                                  child: _isVerifying
                                      ? const CircularProgressIndicator()
                                      : TextButton(
                                          onPressed: _checkEmailVerified,
                                          child: const Text(
                                              "Check Email Verification"),
                                        ),
                                )
                              : const SizedBox(),

                          const SizedBox(height: 10),

                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child:
                                  const Text("Already have an account? Login"),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // OR Divider
                          Row(
                            children: [
                              const Expanded(child: Divider(thickness: 1)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text("OR",
                                    style: TextStyle(color: Colors.grey[600])),
                              ),
                              const Expanded(child: Divider(thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Google & Apple Sign-in Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset('assets/googlelogo.svg',
                                    height: 32, width: 32),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset('assets/applelogo.svg',
                                    height: 32, width: 32),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
