import 'package:bn_diplomapp/global.dart';
import 'package:bn_diplomapp/model/app_constants.dart';
import 'package:bn_diplomapp/view/guest_home_screen.dart';
import 'package:bn_diplomapp/view/host_home_screen.dart';
import 'package:bn_diplomapp/view_model/user_view_model.dart'; // Import UserViewModel
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view_model/user_view_model.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _hostingTitle = 'Show my Host Dashboard';
  final UserViewModel userViewModel = UserViewModel(); // Initialize UserViewModel

  modifyHostingMode() async {
    if (AppConstants.currentUser.isHost!) {
      if (AppConstants.currentUser.isCurrentlyHosting!) {
        AppConstants.currentUser.isCurrentlyHosting = false;
        Get.to(const GuestHomeScreen());
      } else {
        AppConstants.currentUser.isCurrentlyHosting = true;
        Get.to(HostHomeScreen());
      }
    } else {
      await userViewModel.becomeHost(FirebaseAuth.instance.currentUser!.uid);
      AppConstants.currentUser.isCurrentlyHosting = true;
      Get.to(HostHomeScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    if (AppConstants.currentUser.isHost!) {
      if (AppConstants.currentUser.isCurrentlyHosting!) {
        _hostingTitle = 'Show my Guest Dashboard';
      } else {
        _hostingTitle = 'Show my Host Dashboard';
      }
    } else {
      _hostingTitle = 'Become a host';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Center(
                child: Column(
                  children: [
                    // Image
                    MaterialButton(
                      onPressed: () {},
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: MediaQuery.of(context).size.width / 4.5,
                        child: CircleAvatar(
                          backgroundImage: AppConstants.currentUser.displayImage,
                          radius: MediaQuery.of(context).size.width / 4.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Name and email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppConstants.currentUser.getFullNameOfUser() ?? 'User Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          AppConstants.currentUser.email ?? 'user@example.com',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Buttons
            ListView(
              shrinkWrap: true,
              children: [
                // Personal Information button
                _buildMenuButton(
                  context,
                  "Personal Information",
                  Icons.person_2,
                  onPressed: () {
                    // Navigate to personal information screen
                  },
                ),
                const SizedBox(height: 10),
                // Change Hosting button
                _buildMenuButton(
                  context,
                  _hostingTitle,
                  Icons.dashboard_outlined,
                  onPressed: () {
                    modifyHostingMode();
                  },
                ),
                const SizedBox(height: 10),
                // Molly help button
                _buildMenuButton(
                  context,
                  "Dorm help",
                  Icons.headset_mic_outlined,
                  onPressed: () {
                    // Navigate to help screen
                  },
                ),
                const SizedBox(height: 10),
                // Setting button
                _buildMenuButton(
                  context,
                  "Setting",
                  Icons.settings_outlined,
                  onPressed: () {
                    // Navigate to settings screen
                  },
                ),
                const SizedBox(height: 10),
                // Terms and conditions button
                _buildMenuButton(
                  context,
                  "Terms and condition",
                  Icons.description_outlined,
                  onPressed: () {
                    // Navigate to terms and conditions screen
                  },
                ),
                const SizedBox(height: 10),
                // Logout button
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: userViewModel.logout, // Added logout functionality
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 34,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Log out account",
                              style: TextStyle(
                                fontSize: 18.5,
                                fontWeight: FontWeight.normal,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context,
      String title,
      IconData icon, {
        Color color = Colors.white,
        Color textColor = Colors.black,
        required VoidCallback onPressed,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: MaterialButton(
        height: MediaQuery.of(context).size.height / 9.1,
        onPressed: onPressed,
        child: ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: textColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
