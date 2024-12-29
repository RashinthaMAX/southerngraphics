import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:southern/CustomerAddingPage.dart';
import 'package:southern/CustomerHomePage.dart';
import 'package:southern/DailyImpressionPage.dart';
import 'package:southern/LoginAddingPage.dart';
import 'package:southern/NewJobHistoryPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/customerJobhistory.dart';
import 'package:southern/test.dart';
class ProfileSetup extends StatefulWidget {
	const ProfileSetup({super.key});
	@override
		ProfileSetupState createState() => ProfileSetupState();
	}
class ProfileSetupState extends State<ProfileSetup> {
   int _currentIndex = 5;



// Handle navigation based on selected index
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to respective pages
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DailyWorkListPage()), // Replace with actual homepage widget
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DailyImpressionPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Customerjobhistory()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NewJobHistoryPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PaperDetailsPage()),
        );
        break;
      case 5:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSetup()),
        );
        break;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 194, 117, 2), // Light Orange
  title: const Text(
    'New Job Add',
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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 181, 109, 0), // Light Orange
        selectedItemColor: const Color.fromARGB(255, 193, 94, 2), // Selected color
        unselectedItemColor: Colors.black, // Unselected color
        currentIndex: _currentIndex,
        onTap: _onTabTapped,// Change to your desired color for unselected icons
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Daily Impression',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: 'Daily Work Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Customer Details',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.new_label),
          label: 'New Work add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.scanner),
          label: 'Paper Shop Details',
          
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_sharp),
          label: 'Account',
        ),
      ],
    ),
			body: SafeArea(
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
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Adding Users Button
                  IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF9D4C00),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      margin: const EdgeInsets.only(bottom: 62, left: 67, right: 67),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                           Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginAddingPage()),
        );
                          // Add your onPressed action for the "Adding Users" button here
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.transparent, // Text color
                          elevation: 0, // No shadow
                        ),
                        child: const Text(
                          "Adding Users",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Password Change Button
                  IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF9D4C00),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      margin: const EdgeInsets.only(bottom: 301, left: 67, right: 67),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your onPressed action for the "Password Change" button here
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.transparent, // Text color
                          elevation: 0, // No shadow
                        ),
                        child: const Text(
                          "Password Change",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 24,
                          ),
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
    
		);
	}
}