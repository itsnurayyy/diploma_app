import 'dart:io';
import 'package:bn_diplomapp/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'guest_home_screen.dart';
import 'login_screen.dart';  // Ensure this import is correct

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();
  TextEditingController _firstNameTextEditingController = TextEditingController();
  TextEditingController _lastNameTextEditingController = TextEditingController();
  TextEditingController _cityTextEditingController = TextEditingController();
  TextEditingController _countryTextEditingController = TextEditingController();
  TextEditingController _bioTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? imageFileOfUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 50),
              Image.asset('images/images/signup.png', height: 100, width: 100),  // Ensure you have the image in assets
              SizedBox(height: 20),
              Text(
                'Sign up Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildTextField('First Name', _firstNameTextEditingController),
              SizedBox(height: 10),
              _buildTextField('Last Name', _lastNameTextEditingController),
              SizedBox(height: 10),
              _buildTextField('City', _cityTextEditingController),
              SizedBox(height: 10),
              _buildTextField('Country', _countryTextEditingController),
              SizedBox(height: 10),
              _buildTextField('Bio', _bioTextEditingController),
              SizedBox(height: 10),
              _buildTextField('Email', _emailTextEditingController),
              SizedBox(height: 10),
              _buildTextField('Password', _passwordTextEditingController, obscureText: true),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 38.0),
                child: MaterialButton(
                  onPressed: () async {
                    var imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                    if (imageFile != null) {
                      imageFileOfUser = File(imageFile.path);

                      setState(() {
                        imageFileOfUser;
                      });
                    }
                  },
                  child: imageFileOfUser == null
                      ? const Icon(Icons.add_a_photo)
                      : CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: MediaQuery.of(context).size.width / 5.0,
                    child: CircleAvatar(
                      backgroundImage: FileImage(imageFileOfUser!),
                      radius: MediaQuery.of(context).size.width / 5.2,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 44.0, right: 80, left: 80),
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate() || imageFileOfUser == null) {
                      Get.snackbar("Field Missing", "Please choose an image and fill out the complete sign-up form.");
                      return;
                    }

                    if (_emailTextEditingController.text.isEmpty || _passwordTextEditingController.text.isEmpty) {
                      Get.snackbar("Field Missing", "Please fill out the complete sign-up form.");
                      return;
                    }

                    try {
                      await userViewModel.signUp(
                        _emailTextEditingController.text.trim(),
                        _passwordTextEditingController.text.trim(),
                        _firstNameTextEditingController.text.trim(),
                        _lastNameTextEditingController.text.trim(),
                        _cityTextEditingController.text.trim(),
                        _countryTextEditingController.text.trim(),
                        _bioTextEditingController.text.trim(),
                        imageFileOfUser,
                      );
                    } catch (e) {
                      Get.snackbar("Sign-Up Failed", e.toString());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('Sign up', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.to(LoginScreen(role: 'Dormitory Seeker'));
                },
                child: Text('Already have an account? Enter here', style: TextStyle(color: Colors.green)),
              ),
              Text(
                'By signing up, I agree to the Privacy Policy',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        }
        return null;
      },
    );
  }
}
