import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
//import 'package:southern/CustomerHomePage.dart';
import 'package:southern/DailyImpressionPage.dart';
import 'package:southern/NewJobHistoryPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/test.dart';
import 'package:intl/intl.dart';
import 'package:southern/xx.dart';



class Customerjobhistory extends StatefulWidget {
  const Customerjobhistory({super.key});

  @override
  _CustomerjobhistoryPageState createState() => _CustomerjobhistoryPageState();
}

class _CustomerjobhistoryPageState extends State<Customerjobhistory> {
  String textField2 = '';
  final DateTime _selectedDate = DateTime.now();
  double _totalImpressionAmount = 0.0;
  double _totalPayment = 0.0;
  double _noofimpression = 0.0;
  double _balance = 0.0;
  List<dynamic> dailyWorks = [];
  int _currentIndex = 2;

  String? selectedCustomer; // Selected customer for the dropdown
  List<String> customers = []; // Customer list fetched from API

  String textField3 = ''; // paper_description
  String textField4 = ''; // binding_amount
  String textField5 = ''; // no_of_impressions
  String textField6 = ''; // impression_amount
  String textField7 = ''; // paper_amount
  String textField8 = ''; // total_amount
  String textField9 = ''; // payment
  String textField10 = ''; // date

  String formatDateToLocal(String isoDate) {
    try {
      DateTime parsedDate = DateTime.parse(isoDate).toUtc();
      DateTime localDate = parsedDate.toLocal();
      return DateFormat('yyyy-MM-dd').format(localDate);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return isoDate;
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
        setState(() {
          customers = List<String>.from(decodedResponse.where((e) => e != null));
        });
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      debugPrint('Error fetching customers: $e');
    }
  }




  // Fetch customer data and display work history
  Future<void> _fetchCustomerData(String customerName) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.31:3000/customer-summary'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'customerName': customerName}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _totalImpressionAmount = (data['summary']['total_amount'] ?? 0).toDouble();
          _totalPayment = (data['summary']['last_payment'] ?? 0).toDouble();
          _balance = (data['summary']['balance'] ?? 0).toDouble();
          dailyWorks = data['history'] ?? [];
        });
      } else {
        throw Exception('Failed to fetch customer data');
      }
    } catch (error) {
      print('Error fetching customer data: $error');
    }
  }

  // Update work details in the backend
  Future<void> _updateWorkDetails(Map<String, dynamic> work) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.31:3000/update-job'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(work),
      );
      if (response.statusCode == 200) {
        debugPrint('Work updated successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Customerjobhistory()), // Replace with actual homepage widget
        );
      } else {
        throw Exception('Failed to update work');
      }
    } catch (error) {
      debugPrint('Error updating work: $error');
    }
  }

  // Show Edit Dialog for updating work details
  void _showEditDialog(Map<String, dynamic> work) {
    TextEditingController jobNameController = TextEditingController(text: work['job_name']);
    TextEditingController paperDescriptionController = TextEditingController(text: work['paper_description']);
    TextEditingController bindingAmountController = TextEditingController(text: work['binding_amount'].toString());
    TextEditingController noOfImpressionsController = TextEditingController(text: work['no_of_impressions'].toString());
    TextEditingController impressionAmountController = TextEditingController(text: work['impression_amount'].toString());
    TextEditingController paperAmountController = TextEditingController(text: work['paper_amount'].toString());
    TextEditingController totalAmountController = TextEditingController(text: work['total_amount'].toString());
    TextEditingController paymentController = TextEditingController(text: work['payment'].toString());
    
 // Use formatDateToLocal() to properly format the date before assigning it to dateController
  TextEditingController dateController = TextEditingController(
    text: formatDateToLocal(work['date']),
  );

    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Work Details"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: jobNameController,
                  decoration: const InputDecoration(labelText: 'Job Name'),
                  enabled: true, // Prevent editing `job_name`
                ),
                TextField(
                  controller: paperDescriptionController,
                  decoration: const InputDecoration(labelText: 'Paper Description'),
                ),
                TextField(
                  controller: bindingAmountController,
                  decoration: const InputDecoration(labelText: 'Binding Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: noOfImpressionsController,
                  decoration: const InputDecoration(labelText: 'No. of Impressions'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: impressionAmountController,
                  decoration: const InputDecoration(labelText: 'Impression Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: paperAmountController,
                  decoration: const InputDecoration(labelText: 'Paper Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: totalAmountController,
                  decoration: const InputDecoration(labelText: 'Total Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: paymentController,
                  decoration: const InputDecoration(labelText: 'Payment'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  work['paper_description'] = paperDescriptionController.text;
                  work['binding_amount'] = double.parse(bindingAmountController.text);
                  work['no_of_impressions'] = int.parse(noOfImpressionsController.text);
                  work['impression_amount'] = double.parse(impressionAmountController.text);
                  work['paper_amount'] = double.parse(paperAmountController.text);
                  work['total_amount'] = double.parse(totalAmountController.text);
                  work['payment'] = double.parse(paymentController.text);
                  work['date'] = DateFormat('yyyy-MM-dd').format(DateTime.parse(dateController.text));

                });
                Navigator.pop(context);
                _updateWorkDetails(work);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
    // Group works into "To Pay" and "Paid" categories

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
        Icons.payment,
        color: Color.fromARGB(255, 60, 4, 192),
        size: 30,
        
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const CustomerSummaryScreen(selectedCustomer: 'customerName',),
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
          color: const Color.fromARGB(255, 250, 234, 205),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Picker Row
              IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "To Total bill \t\t ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 43, 20, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
              // Customer Dropdown
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
                    if (value != null) {
                      _fetchCustomerData(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Summary Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //_buildDataCard("Total Amount", "Rs. $_totalImpressionAmount"),
                    //_buildDataCard("Last Payment", "Rs. $_totalPayment"),
                    _buildDataCard("Balance", "Rs. $_balance"),
                  ],
                ),
              ),
              // Job History List
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: dailyWorks.isEmpty
                      ? const Center(
                          child: Text(
                            "No works available for the selected customer",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : Container(
  color: const Color.fromARGB(255, 228, 208, 172),
  child: ListView.builder(
    key: ValueKey(dailyWorks.length),
    itemCount: dailyWorks.length,
    itemBuilder: (context, index) {
      final work = dailyWorks[index];
      final count = (index + 1);
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: ListTile(
          title: Text(
            '($count). ${work['job_name']}',
            style: const TextStyle(
              color: Color.fromARGB(255, 15, 11, 255),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "* Date :  ${formatDateToLocal(work['date'])}",
                style: const TextStyle(
                  color: Color.fromARGB(255, 143, 55, 55),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "* Impressions : ${work['no_of_impressions']} \t\t\t\t\t * Impression Amount : Rs. ${work['impression_amount']}",
              ),
              Text(
                "* Description : \t\t ${work['paper_description']} \t\n* Paper Amount : Rs. ${work['paper_amount']}",
              ),
              Text(
                "* Binding Amount : \t\t ${work['binding_amount']} \t\n* Total amount for this job : Rs. ${work['total_amount']}  \t\n* Payment : Rs. ${work['payment']}",
              ),
              Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
      work['balance'] == 0
      ? const Text(
          "********* Paid *****",
          style: TextStyle(
            color: Color.fromARGB(255, 18, 145, 2),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        )
      : Text(
          "* To Pay : Rs. ${work['balance']}",
          style: const TextStyle(
            color: Color.fromARGB(255, 143, 55, 55),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
    ElevatedButton(
      onPressed: () {
        _showEditDialog(work); // Open edit dialog with the current work details
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 250, 3, 3),
      ),
      child: const Text(
        'Edit',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),

            ],
          ),
        ),
      );
    },
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

  Widget _buildDataCard(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF9D4C00), width: 3),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Color.fromARGB(255, 255, 40, 40), fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}