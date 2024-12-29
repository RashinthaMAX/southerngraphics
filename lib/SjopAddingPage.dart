import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:southern/CustomerHomePage.dart';
import 'package:southern/DailyImpressionPage.dart';
import 'package:southern/NewJobHistoryPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/customerJobhistory.dart';
import 'package:southern/test.dart';
class ShopAddingPage extends StatefulWidget {
  const ShopAddingPage({super.key});

  @override
  ShopAddingPageState createState() => ShopAddingPageState();
}

class ShopAddingPageState extends State<ShopAddingPage> {
  String shopName = '';
  String whatsappNumber = '';
  String emailAddress = '';
  int _currentIndex = 0;

  Future<void> addShop() async {
    const url = 'http://192.168.1.31:3000/add-shop'; // Replace with your server URL
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: '''{
        "shopName": "$shopName",
        "whatsappNumber": "$whatsappNumber",
        "emailAddress": "$emailAddress"
      }''',
    );

    if (response.statusCode == 200) {
      // Shop added successfully
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Shop added successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Error occurred
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to add shop. ${response.body}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

 // Handle navigation based on selected index
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to respective pages
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DailyWorkListPage()), // Replace with actual homepage widget
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DailyImpressionPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Customerjobhistory()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewJobHistoryPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaperDetailsPage()),
        );
        break;
      case 5:
        Navigator.push(
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
        backgroundColor:
            const Color.fromARGB(255, 194, 117, 2), // Light Orange
        title: const Text(
          'Shop Add ',
          style: TextStyle(
            fontFamily: 'Yasarath',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 219, 217, 217),
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
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.new_label),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.scanner),
          label: '',
          
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_sharp),
          label: '',
        ),
      ],
    ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shop Name'),
              TextField(
                onChanged: (value) => shopName = value,
                decoration: const InputDecoration(
                  hintText: 'Enter Shop Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text('WhatsApp Number'),
              TextField(
                onChanged: (value) => whatsappNumber = value,
                decoration: const InputDecoration(
                  hintText: 'Enter WhatsApp Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Email Address'),
              TextField(
                onChanged: (value) => emailAddress = value,
                decoration: const InputDecoration(
                  hintText: 'Enter Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: addShop,
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
