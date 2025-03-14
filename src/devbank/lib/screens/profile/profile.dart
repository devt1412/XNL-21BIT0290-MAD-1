import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller.dart';
import 'package:devbank/shared/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:devbank/shared/widgets/custombutton.dart';
import 'package:devbank/shared/widgets/customsnackbar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? _user = FirebaseAuth.instance.currentUser;

  bool _isPhoneVerified = false;
  bool _isVerifying = false;

  void _verifyPhone() {
    setState(() {
      _isVerifying = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isVerifying = false;
        _isPhoneVerified = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
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
                "Profile",
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
                          // Username Field
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: "Username",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter a username";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Phone Number Field + Verify Button
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
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
                              suffix: _isVerifying
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: _isPhoneVerified
                                          ? null
                                          : _verifyPhone,
                                      child: Text(
                                        _isPhoneVerified
                                            ? "Verified"
                                            : "Verify Phone",
                                        style: TextStyle(
                                          color: _isPhoneVerified
                                              ? Colors.green
                                              : Colors.blue,
                                        ),
                                      ),
                                    ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 10) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Save Button
                          profileState.when(
                            data: (_) => Center(
                              child: Custombutton(
                                text: "Save",
                                type: ButtonType.filled,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (!_isPhoneVerified) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Please verify your phone number first"),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }

                                    ref
                                        .read(
                                            profileControllerProvider.notifier)
                                        .saveProfile(
                                          _usernameController.text,
                                          _phoneController.text,
                                          _user!.email!,
                                          _user!.uid,
                                        )
                                        .then((_) {
                                      showCustomSnackbar(
                                        context: context,
                                        text: "Profile saved successfully!",
                                        color: AppColors.primary100,
                                      );
                                      Navigator.pushNamed(context, '/home');
                                    });
                                  }
                                },
                              ),
                            ),
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                            error: (e, _) => Text(
                              e.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
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
