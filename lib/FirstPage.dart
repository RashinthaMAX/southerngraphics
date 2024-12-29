import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:southern/LoginPage.dart';

class SouthernGraphicsPage extends StatelessWidget {
  const SouthernGraphicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254), // Background color
      
       appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 194, 117, 2), // Light Orange
        title: const Text(
          'Application Create by Rashintha Wanigasekara ',
          style: TextStyle(
            fontFamily: 'Yasarath',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 7, 3, 3),
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Color.fromARGB(96, 0, 0, 0),
              ),
            ],
          ),
        ),
        centerTitle: false,
      ),

      body: Stack(
        children: [
          // Overlapping Circles at Top-Left
          Positioned(
            top: -200,
            left: -70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Larger Circle
                Container(
                  width: 700,
                  height: 800,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFA500), // Orange color
                    shape: BoxShape.circle,
                  ),
                ),
                // Smaller Circle (overlapping)
                
              ],
            ),
          ),
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Southern Graphics Text
                const Column(
                  children: [
                    Text(
                      'Southern',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 88,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 248, 248, 248),
                        
                      ),
                    ),
                    Text(
                      ' Graphics',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 107, 107, 107),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Image Section
                Image.asset(
                  'assets/first.jpg', // Replace with your actual asset
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 40),
                // GO Button
                GestureDetector(
                    onTap: () {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop, // Choose your desired animation
        child: const LoginPage(),     // Your destination page
        duration: const Duration(milliseconds: 500), // Animation duration
      ),
    );
  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xFFFFA500), // Gradient effect with orange
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'GO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF062293), // Dark blue text color
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}