import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:southern/NewJobAddingPage.dart';
import 'package:southern/CustomerHomePage.dart';
import 'package:southern/DailyImpressionPage.dart';
import 'package:southern/NewJobHistoryPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/customerJobhistory.dart';
import 'package:southern/test.dart';
class CustomerAddingPage extends StatefulWidget {
  const CustomerAddingPage({super.key});
  
  @override
  CustomerAddingPageState createState() => CustomerAddingPageState();
}

class CustomerAddingPageState extends State<CustomerAddingPage> {
  String textField1 = ''; // Customer Name
  String textField2 = ''; // WhatsApp Numbera
  String textField3 = ''; // Email Address
  String textField4 = ''; // Press Name
    int _currentIndex = 2;

  Future<void> submitCustomerData() async {
    // The URL of your backend API
    final url = Uri.parse('http://192.168.1.31:3000/addCustomer');

    // Prepare the data to send in the request body
    final body = json.encode({
      'name': textField1,
      'number': textField2,
      'email': textField3,
      'shopName': textField4,
    });

    // Send the POST request
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Success
      if (kDebugMode) {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer Add Successfully')),
        );
      }
	    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const CustomerAddingPage()), // Replace `NextPage` with your desired page widget.
  );
      // You can show a success message or navigate the user to another page
    } else {
      // Failure
      if (kDebugMode) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add Customer')),
        );
      }
      // Show an error message
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
        backgroundColor:
            const Color.fromARGB(255, 194, 117, 2), // Light Orange
        title: const Text(
          'Daily Impression Details ',
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
        centerTitle: false,
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
										padding: const EdgeInsets.only( top: 100),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												
												Container(
													margin: const EdgeInsets.only( bottom: 9, left: 20),
													child: const Text(
														"Customer Name",
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
														padding: const EdgeInsets.only( top: 11, bottom: 11, left: 43, right: 43),
														margin: const EdgeInsets.only( bottom: 49, left: 33, right: 33),
														width: double.infinity,
														child: TextField(
															style: const TextStyle(
																color: Color(0xFF565454),
																fontSize: 15,
															),
															onChanged: (value) { 
																setState(() { textField1 = value; });
															},
															decoration: const InputDecoration(
																hintText: "",
																isDense: true,
																contentPadding: EdgeInsets.symmetric(vertical: 0),
																border: InputBorder.none,
															),
														),
													),
												),
												Container(
													margin: const EdgeInsets.only( bottom: 10, left: 19),
													child: const Text(
														"Whats app Number ",
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
														padding: const EdgeInsets.only( top: 11, bottom: 11, left: 43, right: 43),
														margin: const EdgeInsets.only( bottom: 49, left: 33, right: 33),
														width: double.infinity,
														child: TextField(
															style: const TextStyle(
																color: Color(0xFF565454),
																fontSize: 15,
															),
															onChanged: (value) { 
																setState(() { textField2 = value; });
															},
															decoration: const InputDecoration(
																hintText: "",
																isDense: true,
																contentPadding: EdgeInsets.symmetric(vertical: 0),
																border: InputBorder.none,
															),
														),
													),
												),
												Container(
													margin: const EdgeInsets.only( bottom: 10, left: 22),
													child: const Text(
														"Email Address",
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
														padding: const EdgeInsets.only( top: 12, bottom: 12, left: 43, right: 43),
														margin: const EdgeInsets.only( bottom: 34, left: 31, right: 31),
														width: double.infinity,
														child: TextField(
															style: const TextStyle(
																color: Color(0xFF565454),
																fontSize: 15,
															),
															onChanged: (value) { 
																setState(() { textField3 = value; });
															},
															decoration: const InputDecoration(
																hintText: "Sarasavi Printers",
																isDense: true,
																contentPadding: EdgeInsets.symmetric(vertical: 0),
																border: InputBorder.none,
															),
														),
													),
												),
												Container(
													margin: const EdgeInsets.only( bottom: 9, left: 22),
													child: const Text(
														"Press Name or ",
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
														padding: const EdgeInsets.only( top: 12, bottom: 12, left: 43, right: 43),
														margin: const EdgeInsets.only( bottom: 34, left: 31, right: 31),
														width: double.infinity,
														child: TextField(
															style: const TextStyle(
																color: Color(0xFF565454),
																fontSize: 15,
															),
															onChanged: (value) { 
																setState(() { textField4 = value; });
															},
															decoration: const InputDecoration(
																hintText: "",
																isDense: true,
																contentPadding: EdgeInsets.symmetric(vertical: 0),
																border: InputBorder.none,
															),
														),
													),
												),
												 InkWell(
                          onTap: () {
                            submitCustomerData(); // Call the function when the user presses Submit
                          },
													child: IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: BorderRadius.circular(12),
																color: const Color(0xFF205192),
															),
															padding: const EdgeInsets.symmetric(vertical: 11),
															margin: const EdgeInsets.only( bottom: 0, left: 130, right: 130),
															width: double.infinity,
															child: const Column(
																children: [
																	Text(
																		"Submit",
																		style: TextStyle(
																			color: Color(0xFFFFFFFF),
																			fontSize: 15,
																		),
																	),
																]
															),
														),
													),
                        ),
											],
										)
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