//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transaction_management_ui/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final Dio dio = Get.find<Dio>();

  Future<void> login() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both username and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Please enter both username and password')),
      // );
      // return;
    }

    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('https://transaction-management-system-beta.vercel.app/auth');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['AuthenticationToken'];

      // Navigate to the home screen with the token
      Get.to(HomeScreen(token: token));

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(token: token),
      //   ),
      // );
    } else {
      Get.snackbar(
        'Error',
        'Login failed. Please check your credentials.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Login failed. Please check your credentials.')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: AppBar(
            title: Text(
              'Login',
              style: TextStyle(fontSize: 20.sp, color: Colors.white),
            ),
            backgroundColor: Colors.green,
            toolbarHeight: 56.h, // Adjust the height of the AppBar
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  style: const TextStyle(color: Colors.black)),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
