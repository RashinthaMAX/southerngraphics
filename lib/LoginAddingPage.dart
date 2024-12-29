import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginAddingPage extends StatefulWidget {
  const LoginAddingPage({super.key});

  @override
  LoginAddingPageState createState() => LoginAddingPageState();
}

class LoginAddingPageState extends State<LoginAddingPage> {
  String userName = '';  // Store the username input
  String password = '';  // Store the password input

  // Function to handle the form submission and add user
  Future<void> addUser() async {
    if (userName.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and Password are required.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.31:3000/add-user'),  // Update this URL with your server endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': userName,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // User successfully added
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add user. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error while adding user.')),
      );
      debugPrint('Error adding user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 194, 117, 2), // Light Orange
        title: const Text(
          'User Add',
          style: TextStyle(
            fontFamily: 'Yasarath',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 248, 246, 246),
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Color.fromARGB(96, 0, 0, 0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Container(
            constraints: const BoxConstraints.expand(),
            color: const Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFFCAC8C8),
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 65),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username input
                          Container(
                            margin: const EdgeInsets.only(bottom: 9, left: 26),
                            child: const Text(
                              "Login Name",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(7),
                                color: const Color(0xFFB5B3B3),
                              ),
                              padding: const EdgeInsets.only(
                                  top: 11, bottom: 11, left: 43, right: 43),
                              margin: const EdgeInsets.only(
                                  bottom: 49, left: 33, right: 33),
                              width: double.infinity,
                              child: TextField(
                                style: const TextStyle(
                                  color: Color(0xFF565454),
                                  fontSize: 15,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    userName = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: "",
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          // Password input
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, left: 26),
                            child: const Text(
                              "Password",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(7),
                                color: const Color(0xFFB5B3B3),
                              ),
                              padding: const EdgeInsets.only(
                                  top: 11, bottom: 11, left: 43, right: 43),
                              margin: const EdgeInsets.only(
                                  bottom: 69, left: 27, right: 27),
                              width: double.infinity,
                              child: TextField(
                                style: const TextStyle(
                                  color: Color(0xFF565454),
                                  fontSize: 15,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: "Enter Password",
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          // Submit button
                          InkWell(
                            onTap: () {
                              addUser();
                            },
                            child: IntrinsicHeight(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFF205192),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                margin: const EdgeInsets.only(
                                    bottom: 256, left: 100, right: 100),
                                width: double.infinity,
                                child: const Column(
                                  children: [
                                    Text(
                                      "Submit",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
