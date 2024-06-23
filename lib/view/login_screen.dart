import 'package:bn_diplomapp/global.dart';
import 'package:bn_diplomapp/view/signup_screen.dart';
import 'package:bn_diplomapp/view/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Text(
                    '${widget.role} Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildSocialLoginButton('Sign in with Facebook', Color(0xFF1877F2), Icons.facebook),
                  SizedBox(height: 10),
                  _buildSocialLoginButton('Sign in with Twitter', Color(0xFF1DA1F2), Icons.alternate_email),
                  SizedBox(height: 10),
                  _buildSocialLoginButton('Sign in with Google', Colors.white, Icons.g_translate, textColor: Colors.black),
                  SizedBox(height: 20),
                  Text('or', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 20),
                  _buildTextField(Icons.email, 'Email', _emailTextEditingController),
                  SizedBox(height: 10),
                  _buildTextField(Icons.lock, 'Password', _passwordTextEditingController, obscureText: true),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      Text('Remember Password'),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await userViewModel.login(
                          _emailTextEditingController.text.trim(),
                          _passwordTextEditingController.text.trim(),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Get.to(SignUpScreen());
                    },
                    child: Text('Sign up Now', style: TextStyle(color: Colors.green)),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(ForgetPasswordScreen());
                    },
                    child: Text('Forget Password?', style: TextStyle(color: Colors.green)),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(String text, Color color, IconData icon, {Color textColor = Colors.white}) {
    return ElevatedButton.icon(
      onPressed: () {
        // Social login logic
      },
      icon: Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hintText, TextEditingController controller, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
      ),
      validator: (value) {
        if (hintText == 'Email' && !value!.contains('@')) {
          return 'Please enter a valid email.';
        }
        if (hintText == 'Password' && value!.length < 6) {
          return 'Password must be at least 6 characters.';
        }
        return null;
      },
    );
  }
}
