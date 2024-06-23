import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'role_selection_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 15), () {
      Get.off(() => RoleSelectionScreen());
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C853),
              Color(0xFF009688)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset('images/images/splash1.png'),
        ),
      ),
    );
  }
}
