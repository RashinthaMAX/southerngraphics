import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:southern/CustomerAddingPage.dart';

import 'package:southern/NewJobHistoryPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/customerJobhistory.dart';
import 'package:southern/test.dart';

class DailyImpressionPage extends StatefulWidget {
  const DailyImpressionPage({super.key});

  @override
  DailyImpressionPageState createState() => DailyImpressionPageState();
}

class DailyImpressionPageState extends State<DailyImpressionPage> {
  String? selectedCustomer; // Selected customer for the dropdown
  List<String> customers = []; // Customer list fetched from API

  String textField2 = ''; // job_name
  String textField3 = ''; // paper_description
  String textField4 = ''; // binding_amount
  String textField5 = ''; // no_of_impressions
  String textField6 = ''; // impression_amount
  String textField7 = ''; // paper_amount
  String textField8 = ''; // total_amount
  String textField9 = ''; // payment
  DateTime _selectedDate = DateTime.now(); // Store the selected date
  int _currentIndex = 1;

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



   // Update total amount dynamically
  void _updateTotalAmount() {
    final double bindingAmount = double.tryParse(textField4) ?? 0.0;
    final double impressionAmount = double.tryParse(textField6) ?? 0.0;
    final double paperAmount = double.tryParse(textField7) ?? 0.0;

    setState(() {
      textField8 = (bindingAmount + impressionAmount + paperAmount).toStringAsFixed(2);
    });
  }

  // Function to pick the date
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

  // Function to submit data to the backend
  Future<void> _submitData() async {
    if (selectedCustomer == null || selectedCustomer!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer')),
      );
      return;
    }

    final url = Uri.parse('http://192.168.1.31:3000/add-dailywork');
    final data = {
      'customer_name': selectedCustomer,
      'job_name': textField2,
      'paper_description': textField3,
      'binding_amount': double.tryParse(textField4) ?? 0.0,
      'no_of_impressions': int.tryParse(textField5) ?? 0,
      'impression_amount': double.tryParse(textField6) ?? 0.0,
      'paper_amount': double.tryParse(textField7) ?? 0.0,
      'total_amount': double.tryParse(textField8) ?? 0.0,
      'payment': double.tryParse(textField9) ?? 0.0,
      'balance': (double.tryParse(textField8) ?? 0.0) - (double.tryParse(textField9) ?? 0.0),
      'date': "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data submitted successfully')),
        );
		  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const DailyWorkListPage()), // Replace `NextPage` with your desired page widget.
  );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit data')),
        );
      }
    } catch (error) {
      debugPrint('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting data')),
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
  actions: [
    IconButton(
      icon: const Icon(
        Icons.dashboard_customize_rounded,
        color: Color.fromARGB(255, 2, 0, 0),
        size: 30,
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const CustomerAddingPage(),
            duration: const Duration(milliseconds: 500),
          ),
        );
      },
    ),
  ],
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
					color:  const Color.fromARGB(255, 255, 255, 255),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: Container(
									color: const Color.fromARGB(255, 245, 244, 244),
									width: double.infinity,
									height: double.infinity,
									child: SingleChildScrollView(
										padding: const EdgeInsets.only( top: 64),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												
												IntrinsicHeight(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Display the selected date dynamically
                                Text(
                                  "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                                  style: const TextStyle(
                                    
                                    color: Color.fromARGB(255, 243, 2, 2),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
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
												Container(
													margin: const EdgeInsets.only( bottom: 9, left: 20),
													child: const Text(
														"Customer Name",
														style: TextStyle(
															color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
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
                const SizedBox(height: 10),

												Container(
													margin: const EdgeInsets.only( bottom: 10, left: 20),
													child: const Text(
														"Job Name",
														style: TextStyle(
															color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
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
														margin: const EdgeInsets.only( bottom: 39, left: 33, right: 33),
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
													margin: const EdgeInsets.only( bottom: 13, left: 22),
													child: const Text(
														"Job Description",
														style: TextStyle(
															color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
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
														padding: const EdgeInsets.only( top: 17, bottom: 17, left: 42, right: 42),
														margin: const EdgeInsets.only( bottom: 31, left: 31, right: 31),
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
																hintText: "",
																isDense: true,
																contentPadding: EdgeInsets.symmetric(vertical: 0),
																border: InputBorder.none,
															),
														),
													),
												),
												Container(
													margin: const EdgeInsets.only( bottom: 13, left: 22),
													child: const Text(
														"Binding and Plate amount",
														style: TextStyle(
															color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
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
														margin: const EdgeInsets.only( bottom: 30, left: 31, right: 31),
														width: double.infinity,
														child: TextField(
															style: const TextStyle(
																color: Color(0xFF565454),
																fontSize: 15,
															),
															onChanged: (value) { 
																setState(() { textField4 = value;
																_updateTotalAmount();
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
												IntrinsicHeight(
													child: Container(
														margin: const EdgeInsets.only( bottom: 3, left: 20, right: 20),
														width: double.infinity,
														child: Row(
															mainAxisAlignment: MainAxisAlignment.spaceBetween,
															children: [
																IntrinsicHeight(
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFF9D4C00),
        width: 3,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.only(top: 19, bottom: 7),
    width: 150,
    child: Column(
      children: [
       TextField(
  decoration: const InputDecoration(
    hintText: "", // Placeholder text
    hintStyle: TextStyle(
      color: Color(0xFF0A0909),
      fontSize: 40,
    ),
    border: InputBorder.none, // Removes the default border
    contentPadding: EdgeInsets.zero, // Adjust padding
  ),
  textAlign: TextAlign.center, // Center the text within the field
  style: const TextStyle(
    color: Color(0xFF0A0909),
    fontSize: 24,
  ),
  onChanged: (value) { 
    setState(() {
      textField5 = value;
    });
  },
),

      ],
    ),
  ),
),

																IntrinsicHeight(
																	child: Container(
																		decoration: BoxDecoration(
																			border: Border.all(
																				color: const Color(0xFF9D4C00),
																				width: 2,
																			),
																			borderRadius: BorderRadius.circular(20),
																		),
																		padding: const EdgeInsets.only( top: 19, bottom: 7),
																		width: 150,
																		child: Column(
																			children: [
																				 TextField(
  decoration: const InputDecoration(
    hintText: "", // Placeholder text
    hintStyle: TextStyle(
      color: Color(0xFF0A0909),
      fontSize: 40,
    ),
    border: InputBorder.none, // Removes the default border
    contentPadding: EdgeInsets.zero, // Adjust padding
  ),
  textAlign: TextAlign.center, // Center the text within the field
  style: const TextStyle(
    color: Color(0xFF0A0909),
    fontSize: 24,
  ),
  onChanged: (value) { 
    setState(() {
      textField6 = value;
	  _updateTotalAmount();
    });
  },
),
																			]
																		),
																	),
																),
															]
														),
													),
												),
												IntrinsicHeight(
													child: Container(
														margin: const EdgeInsets.only( bottom: 25, left: 50, right: 50),
														width: double.infinity,
														child: const Row(
															mainAxisAlignment: MainAxisAlignment.spaceBetween,
															children: [
																Text(
																	"No of Impression",
																	style: TextStyle(
																		color: Color(0xFF000000),
																		fontSize: 13,
																	),
																),
																Text(
																	"Impression Amount",
																	style: TextStyle(
																		color: Color(0xFF000000),
																		fontSize: 13,
																	),
																),
															]
														),
													),
												),
												IntrinsicHeight(
													child: Container(
														margin: const EdgeInsets.only( bottom: 4, left: 20, right: 20),
														width: double.infinity,
														child: Row(
															mainAxisAlignment: MainAxisAlignment.spaceBetween,
															children: [
																IntrinsicHeight(
																	child: Container(
																		decoration: BoxDecoration(
																			border: Border.all(
																				color: const Color(0xFF9D4C00),
																				width: 2,
																			),
																			borderRadius: BorderRadius.circular(20),
																		),
																		padding: const EdgeInsets.only( top: 19, bottom: 7),
																		width: 150,
																		child: Column(
																			children: [
																				TextField(
          decoration: const InputDecoration(
            hintText: "", // Placeholder text
            hintStyle: TextStyle(
              color: Color(0xFF0A0909),
              fontSize: 40,
            ),
            border: InputBorder.none, // Removes the default border
            contentPadding: EdgeInsets.zero, // Adjust padding
          ),
          textAlign: TextAlign.center, // Center the text within the field
          style: const TextStyle(
            color: Color(0xFF0A0909),
            fontSize: 24,
          ),
		  onChanged: (value) {
			setState(() {
			  textField7 = value;
			  _updateTotalAmount();
			});
		  },
        ),
																			]
																		),
																	),
																),
																IntrinsicHeight(
																	child: Container(
																		decoration: BoxDecoration(
																			border: Border.all(
																				color: const Color(0xFF9D4C00),
																				width: 2,
																			),
																			borderRadius: BorderRadius.circular(20),
																		),
																		padding: const EdgeInsets.only( top: 19, bottom: 7),
																		width: 150,
																		child: Column(
																			children: [
																				TextField(
          decoration: const InputDecoration(
            labelText: 'Total Amount', // Label for clarity
            labelStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFF9D4C00),
            ),
            border: InputBorder.none, // Removes the default border
            contentPadding: EdgeInsets.zero, // Adjust padding
          ),
          textAlign: TextAlign.center, // Center the text within the field
          style: const TextStyle(
            color: Color(0xFF0A0909),
            fontSize: 24,
          ),
		  controller: TextEditingController(text: textField8),
          readOnly: true, // Prevent user edits
          enableInteractiveSelection: false, // Prevent copy-paste for strict read-only
        ),
																			]
																		),
																	),
																),
															]
														),
													),
												),
												IntrinsicHeight(
													child: Container(
														margin: const EdgeInsets.only( bottom: 13, left: 68, right: 68),
														width: double.infinity,
														child: const Row(
															mainAxisAlignment: MainAxisAlignment.spaceBetween,
															children: [
																Text(
																	"Pepar Amount",
																	style: TextStyle(
																		color: Color(0xFF000000),
																		fontSize: 13,
																	),
																),
																Text(
																	"Total Amount",
																	style: TextStyle(
																		color: Color(0xFF000000),
																		fontSize: 13,
																	),
																),
															]
														),
													),
												),
												
												
												InkWell(
												onTap: () {
    _submitData(); // Call the submit function when the button is pressed
  },
													child: IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: BorderRadius.circular(12),
																color: const Color(0xFF205192),
															),
															padding: const EdgeInsets.symmetric(vertical: 11),
															margin: const EdgeInsets.only( bottom: 8, left: 140, right: 150),
															width: double.infinity,
															child: const Column(
																children: [
																	Text(
																		" Submit ",
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