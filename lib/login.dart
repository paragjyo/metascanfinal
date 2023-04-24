import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'data_list.dart';

class LoginModalSheet extends StatefulWidget {
  @override
  _LoginModalSheetState createState() => _LoginModalSheetState();
}

class _LoginModalSheetState extends State<LoginModalSheet> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  String loginToken = '';
  bool isLoggedIn = false;

  void _toggleShowPassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final jsonData = {
      'collectorNumber': username,
      'collectorPassword': password,
    };
    final jsonString = json.encode(jsonData);

    final response = await http.post(
      Uri.parse('https://metascancorp.com/api/login-collector.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonString,
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final status = responseBody['status'];
      final message = responseBody['message'];

      if (status == 'success') {
        // Login success, do something
        final token = responseBody['token'];
        setState(() {
          loginToken = token;
          isLoggedIn = true;
        });
      } else if (message == 'Contact Number is not registered.') {
        // Username not registered
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contact Number is not registered.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (message == 'Password is wrong') {
        // Wrong password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password is wrong.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Login failed, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen1(token: loginToken, isLoggedIn: isLoggedIn),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 50.0),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              controller: _usernameController,
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                labelText: 'Contact Number',
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                hintText: 'Number',
                hintStyle: TextStyle(color: Colors.grey[500]),
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggleShowPassword,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
