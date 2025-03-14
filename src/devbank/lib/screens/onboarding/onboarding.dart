import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controller.dart';
import 'model.dart';
import 'package:devbank/shared/widgets/custombutton.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:devbank/shared/theme/app_colors.dart';

class OnboardingScreen extends ConsumerWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      image: 'assets/devbanklogo.png',
      title: '',
      description: '',
    ),
    OnboardingPageModel(
      image: 'assets/onboarding1.png',
      title: 'Secure &\nEasy Banking',
      description:
          'Manage your accounts, track transactions,\nand make payments—all in one secure app.',
    ),
    OnboardingPageModel(
      image: 'assets/onboarding2.png',
      title: 'Instant Payments\n& Transfers',
      description:
          'Send money instantly, pay bills, and make\nsecure transactions with just a few taps.',
    ),
    OnboardingPageModel(
      image: 'assets/onboarding3.png',
      title: 'Real-Time Insights\n& Notifications',
      description:
          'Get real-time updates on your balance,\nspending trends, and important alerts.',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(onboardingControllerProvider);
    final pageController = PageController(initialPage: pageIndex);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                ref.read(onboardingControllerProvider.notifier).setPage(index);
              },
              itemBuilder: (context, index) {
                final page = pages[index];

                if (index == 0) {
                  return Container(
                    width: double.infinity,
                    // Background color
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2),
                        Image.asset(page.image, height: 146, width: 122),
                        const SizedBox(height: 30),
                        Text(
                          "Welcome to",
                          style: GoogleFonts.lato(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Dev Bank",
                          style: GoogleFonts.lato(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary100,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Your safest savings and transactions partner",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutral80,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(page.image, height: 250),
                    const SizedBox(height: 20),
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      page.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          color: AppColors.neutral80,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (pageIndex > 0)
            SmoothPageIndicator(
              controller: pageController,
              count: 4,
              effect: const WormEffect(),
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Custombutton(
              onPressed: () {
                if (pageIndex < pages.length - 1) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  ref.read(onboardingControllerProvider.notifier).nextPage();
                } else {
                  Navigator.pushNamed(context, '/signup');
                }
              },
              type: pageIndex == 0 ? ButtonType.filled : ButtonType.filled,
              text: pageIndex == 0
                  ? 'Get Started'
                  : (pageIndex == pages.length - 1 ? 'Sign up' : 'Continue'),
            ),
          ),
          if (pageIndex == 3)
            Custombutton(
              text: 'Login',
              type: ButtonType.hollow,
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
