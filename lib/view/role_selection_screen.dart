import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // Handle close action
          },
        ),
        title: Text('Enter Dorm', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'I want to login as',
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 45), // Added more space here
            GestureDetector(
              onTap: () {
                // Navigate to login screen with seeker role
                Get.to(() => LoginScreen(role: 'Seeker'));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Matching the background color
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(-4, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.transparent, // Make card background transparent
                  elevation: 0, // Remove default elevation
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset('images/images/seeker.png', height: 90, width: 98),
                        SizedBox(width: 5),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Dormitory Seeker',
                              style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 35),
            GestureDetector(
              onTap: () {
                // Navigate to login screen with owner role
                Get.to(() => LoginScreen(role: 'Owner'));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Matching the background col
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(-4, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.transparent, // Make card background transparent
                  elevation: 0, // Remove default elevation
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset('images/images/owner.png', height: 90, width: 98),
                        SizedBox(width: 5),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Dormitory Owner',
                              style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 55),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Need Help? ',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Click Here',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
