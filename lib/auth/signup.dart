import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  String errorMessage = '';

  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'nickname': _nicknameController.text,
          'room_number': _roomController.text,
          'age': _ageController.text,
          'sex': _sexController.text,
          'year': _yearController.text,
          'branch': _branchController.text,
        });
      }

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        errorMessage = 'Sign up failed: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(  // Makes the page scrollable if keyboard appears
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dynamic TextField with proper padding
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_passwordController, 'Password', obscureText: true),
              _buildTextField(_nicknameController, 'Nickname'),
              _buildTextField(_roomController, 'Room Number'),
              _buildTextField(_ageController, 'Age'),
              _buildTextField(_sexController, 'Sex'),
              _buildTextField(_yearController, 'Year'),
              _buildTextField(_branchController, 'Branch'),

              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(errorMessage, style: TextStyle(color: Colors.red)),
                ),

              // Adding space for the button
              SizedBox(height: screenHeight * 0.03),

              // Submit Button (Responsive)
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up', style: TextStyle(fontSize: screenWidth * 0.045)),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for building TextFields with padding
  Widget _buildTextField(TextEditingController controller, String labelText, {bool obscureText = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
