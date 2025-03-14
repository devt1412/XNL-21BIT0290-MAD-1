import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:devbank/shared/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:devbank/shared/widgets/custombutton.dart';
import 'package:devbank/shared/widgets/customsnackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                "Login",
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
                          // Email Field
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

                          const SizedBox(height: 20),

                          // Login Button
                          Center(
                            child: Custombutton(
                              text: "Login",
                              type: ButtonType.filled,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await ref
                                      .read(loginControllerProvider.notifier)
                                      .login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );

                                  if (success) {
                                    Navigator.pushNamed(context, '/home');
                                  } else {
                                    showCustomSnackbar(
                                      context: context,
                                      text: "Login failed. Please try again.",
                                      color: AppColors.warningColorDark,
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Signup Navigation Button
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child:
                                  const Text("Don't have an account? Sign up"),
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
                                onPressed: () {
                                  // TODO: Implement Google Sign-in
                                },
                                icon: SvgPicture.asset('assets/googlelogo.svg',
                                    height: 32, width: 32),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: () {
                                  // TODO: Implement Apple Sign-in
                                },
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
