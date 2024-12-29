import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:southern/HomePage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String? selectedCustomer; // Selected customer for the dropdown
  String password = ''; // Password entered by the user

  List<String> customers = []; // Customer list fetched from API

  @override
  void initState() {
    super.initState();
    fetchCustomers(); // Fetch customers when the widget initializes
  }

  // Fetch customer list from API
  Future<void> fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.31:3000/user'));
      if (response.statusCode == 200) {
        setState(() {
          customers = List<String>.from(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      debugPrint('Error fetching customers: $e');
    }
  }

  // Handle login
  Future<void> handleLogin() async {
    if (selectedCustomer == null || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer and enter a password.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.31:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': selectedCustomer,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const DailyWorkListPage(),
            duration: const Duration(milliseconds: 500),
          ),
        );
      } else {
        debugPrint('Login failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid login credentials.')),
        );
       /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DailyWorkListPage()),
        );*/}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error logging in. Please try again.')),
      );
      debugPrint('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 245, 228, 228),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Container(
                        margin: const EdgeInsets.only(top: 100, bottom: 130, left: 58, right: 58),
                        width: double.infinity,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 247, 142, 49),
                              Color.fromARGB(255, 164, 84, 3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                          ).createShader(Rect.largest),
                          child: const Text(
                            "Southern\n\t Graphics",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 65,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      // Dropdown
                      Container(
                        margin: const EdgeInsets.only(bottom: 10, left: 20),
                        child: const Text(
                          "Customer Name",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonFormField<String>(
                          value: selectedCustomer,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color(0xFFB5B3B3),
                          ),
                          items: customers.map((customer) {
                            return DropdownMenuItem<String>(
                              value: customer,
                              child: Text(
                                customer,
                                style: const TextStyle(
                                  color: Color(0xFF565454),
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCustomer = value;
                            });
                          },
                        ),
                      ),
                      // Password Field
                      Container(
                        margin: const EdgeInsets.only(bottom: 5, left: 26),
                        child: const Text(
                          "Password",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 27),
                        child: TextField(
                          obscureText: true,
                          style: const TextStyle(
                            color: Color(0xFF565454),
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Enter Password",
                            filled: true,
                            fillColor: Color(0xFFB5B3B3),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                      ),
                      // Login Button
                      InkWell(
                        onTap: handleLogin,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 149),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF000000), width: 1),
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              begin: Alignment(-1, -1),
                              end: Alignment(-1, 1),
                              colors: [
                                Color(0xFFCE690A),
                                Color(0xFFF2F2F2),
                              ],
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color(0xFF062293),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
