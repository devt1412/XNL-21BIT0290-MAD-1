import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devbank/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devbank/shared/widgets/customsnackbar.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  HomeScreen({super.key});

  String username = "User";
  Future<String> getName() async {
    String? uid = user?.uid;
    if (uid == null) return "User";

    DocumentSnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    username = doc.data()?['username'] ?? "User";

    return doc.data()?['username'] ?? "User"; // Default to "User" if null
  }

  Future<List<Map<String, dynamic>>> getIncomingTransactions(
      String username) async {
    username = await getName();
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('transactions')
        .where('to', isEqualTo: username)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.neutral70,
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Payment',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: AppColors.primary500,
        unselectedItemColor: AppColors.neutral80,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary500, AppColors.primary100],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'Hi :)',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                showCustomSnackbar(
                  context: context,
                  text: "Logged out successfully.",
                  color: AppColors.primary100,
                );
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.pushNamed(context, '/login');
                });
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 2.0,
        iconTheme: const IconThemeData(color: AppColors.primary500),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.primary500),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        title:
            SvgPicture.asset('assets/devbanklogo.svg', height: 32, width: 32),
        backgroundColor: AppColors.neutral70,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Ensures left alignment
          children: [
            const SizedBox(height: 20),

            // Welcome Text - Left Aligned
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0), // Add margin
              child: FutureBuilder<String>(
                future: getName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Error fetching name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary500,
                      ),
                    );
                  } else {
                    username = snapshot.data!;
                    return Text(
                      'Welcome, ${snapshot.data}',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary100,
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // "Your Balance" Text - Left Aligned
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0), // Add margin
              child: Text(
                'Current Balance',
                textAlign: TextAlign.left,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral80,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Balance Container - Centered with Border
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary500, width: 4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(27),
                    topRight: Radius.circular(27),
                  ),
                ),
                child: Text(
                  '\$1000.00',
                  style: GoogleFonts.lato(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary100,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Incoming Transactions',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral80,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    child: Text('See all',
                        style: GoogleFonts.lato(
                            fontSize: 16, color: AppColors.primary500)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: getIncomingTransactions(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text(
                    'Error fetching transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary500,
                    ),
                  );
                } else {
                  List<Map<String, dynamic>> transactions = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: transactions.map((transaction) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.primary500,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(27),
                                topRight: Radius.circular(27),
                              ),
                            ),
                            color: AppColors.neutral70,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: 150,
                                height: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      '\$${transaction['amount']}',
                                      style: GoogleFonts.lato(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary100,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'From: ${transaction['from']}',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.neutral90,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Outgoing Transactions',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral80,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    child: Text('See all',
                        style: GoogleFonts.lato(
                            fontSize: 16, color: AppColors.primary500)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: getIncomingTransactions(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text(
                    'Error fetching transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary500,
                    ),
                  );
                } else {
                  List<Map<String, dynamic>> transactions = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: transactions.map((transaction) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.primary500,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(27),
                                topRight: Radius.circular(27),
                              ),
                            ),
                            color: AppColors.neutral70,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: 150,
                                height: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      '\$${transaction['amount']}',
                                      style: GoogleFonts.lato(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary100,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'From: ${transaction['from']}',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.neutral90,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
