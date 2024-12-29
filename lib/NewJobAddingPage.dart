import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:southern/CustomerAddingPage.dart';
import 'package:southern/NewJobHistoryPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:southern/CustomerHomePage.dart';
import 'package:southern/DailyImpressionPage.dart';
import 'package:southern/NewJobHistoryPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/customerJobhistory.dart';
import 'package:intl/intl.dart';
import 'package:southern/test.dart';



class NewJobAddingPage extends StatefulWidget {
	const NewJobAddingPage({super.key});
	@override
		NewJobAddingPageState createState() => NewJobAddingPageState();
	}
class NewJobAddingPageState extends State<NewJobAddingPage> {
     String? selectedCustomer; // Selected customer for the dropdown
  List<String> customers = [];
  String jobName = '';
  String description = '';
  DateTime _selectedDate = DateTime.now();
    int _currentIndex = 3;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomers(); // Fetch customers when the widget initializes
  }
// Fetch customer list from API
 Future<void> fetchCustomers() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.1.31:3000/customers'));
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      debugPrint('API Response: $decodedResponse');
      setState(() {
        customers = List<String>.from(decodedResponse.where((e) => e != null)); // Filter out nulls
      });
    } else {
      throw Exception('Failed to load customers');
    }
  } catch (e) {
    debugPrint('Error fetching customers: $e');
  }
}

  Future<void> submitNewJob() async {
    if (selectedCustomer == null || jobName.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    final data = {
      'customer': selectedCustomer,
      'jobname': jobName,
      'description': description,
      'date': _selectedDate.toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.31:3000/newjob'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job added successfully!')),
        );
       Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  const NewJobHistoryPage()), // Replace `NextPage` with your desired page widget.
  );
      } else {
        throw Exception('Failed to submit job');
      }
    } catch (e) {
      debugPrint('Error submitting job: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit job')),
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
    color: const Color.fromARGB(255, 251, 249, 249),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            color: const Color.fromARGB(255, 225, 223, 223),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date selection
                  IntrinsicHeight(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 17),
                            child: Text(
                              "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 251, 29, 29),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _pickDate(context),
                            child: const SizedBox(
                              width: 19,
                              height: 19,
                              child: Icon(
                                Icons.calendar_today,
                                size: 19,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Customer Add Button
                  Container(
                    margin: const EdgeInsets.only(bottom: 5, left: 23, right: 23),
                    height: 50,
                    width: double.infinity,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_business_sharp,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: const CustomerAddingPage(),
                            duration: const Duration(milliseconds: 500),
                          ),
                        );
                      },
                    ),
                  ),

                  // Customer Dropdown
                  const Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 5),
                    child: Text(
                      "Customer Name",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 10),

                  // Job Name
                  const Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 5),
                    child: Text(
                      "Job Name",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 43),
                      margin: const EdgeInsets.only(bottom: 38, left: 29, right: 29),
                      width: double.infinity,
                      child: TextField(
                        style: const TextStyle(
                          color: Color(0xFF565454),
                          fontSize: 15,
                        ),
                        onChanged: (value) {
                          setState(() {
                            jobName = value;
                          });
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

                  // Job Description
                  const Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 5),
                    child: Text(
                      "Job Description",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IntrinsicHeight(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(7),
                        color: const Color(0xFFB5B3B3),
                      ),
                      padding: const EdgeInsets.only(top: 17, bottom: 50, left: 42, right: 42),
                      margin: const EdgeInsets.only(bottom: 40, left: 27, right: 27),
                      width: double.infinity,
                      child: TextField(
                        style: const TextStyle(
                          color: Color(0xFF565454),
                          fontSize: 15,
                        ),
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: " ",
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 3),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  // Submit Button
                  InkWell(
                    onTap: () {
                      submitNewJob(); // Call the submit function when the button is pressed
                    },
                    child: IntrinsicHeight(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF205192),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        margin: const EdgeInsets.only(bottom: 80, left: 100, right: 100),
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

		);
	}
}