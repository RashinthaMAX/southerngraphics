import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;
import 'package:southern/CustomerHomePage.dart';
import 'package:southern/DailyImpressionPage.dart';
import 'package:southern/NewJobHistoryPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/customerJobhistory.dart';
import 'package:intl/intl.dart';
import 'package:southern/test.dart';

class CustomerSummaryScreen extends StatefulWidget {
  final String selectedCustomer;  // Define the parameter

  const CustomerSummaryScreen({Key? key, required this.selectedCustomer}) : super(key: key);  // Use it in the constructor

  @override
  _CustomerSummaryScreenState createState() => _CustomerSummaryScreenState();
}


class _CustomerSummaryScreenState extends State<CustomerSummaryScreen> {
  final TextEditingController _paymentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic> _summary = {};
  List<dynamic> _history = [];
  List<String> customers = [];
  String? selectedCustomer;
 
  List<dynamic> _paymentHistory = [];
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  // Fetch list of customers from the backend
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

  // Fetch customer summary (balance, last payment, etc.)
  Future<void> fetchCustomerSummary(String customerName) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.31:3000/customer-summary'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'customerName': customerName}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _summary = data['summary'];
        _history = data['history'];
      });
    } else {
      debugPrint('Failed to fetch customer summary');
    }
  }

  // Fetch payment history for the selected customer
  Future<void> fetchPaymentHistory(String customerName) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.31:3000/payment-history?customerName=$customerName'));

    if (response.statusCode == 200) {
      setState(() {
        _paymentHistory = json.decode(response.body);
      });
    } else {
      debugPrint('Failed to fetch payment history');
    }
  }

  // Add a payment to the system
  Future<void> addPayment(double paymentAmount) async {
    if (selectedCustomer == null || _selectedDate == null) return;

    final response = await http.post(
      Uri.parse('http://192.168.1.31:3000/add-payment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'customerName': selectedCustomer,
        'paymentAmount': paymentAmount,
        'paymentDate': DateFormat('yyyy-MM-dd').format(_selectedDate!)
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('Payment added successfully');
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Customerjobhistory()), // Navigate to job history
      );*/
    } else {
      debugPrint('Failed to add payment');
    }
  }

  // Pick a date for the payment
  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Apply payment (submit it to the server)
 Future<void> applyPayment(String customerName, double paymentAmount) async {
  if (customerName == null || paymentAmount <= 0) return;

  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.31:3000/apply-payment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'customerName': customerName,
        'paymentAmount': paymentAmount,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final remainingPayment = data['remainingPayment'];
      final message = data['message'];

      debugPrint('Payment applied successfully. Remaining payment: $remainingPayment');

      // After payment is successfully applied, fetch the updated payment history and summary
      fetchPaymentHistory(customerName);
      fetchCustomerSummary(customerName);

      // Navigate to CustomerSummaryScreen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Customerjobhistory()),
        );
    } else {
      final errorData = json.decode(response.body);
      debugPrint('Failed to apply payment: ${errorData['error']}');
    }
  } catch (e) {
    debugPrint('Error applying payment: $e');
  }
}


  // Trigger payment application when the button is pressed
  void _onAddPaymentPressed() {
    final paymentAmount = double.tryParse(_paymentController.text) ?? 0;
    if (selectedCustomer != null && paymentAmount > 0) {
      applyPayment(selectedCustomer!, paymentAmount);
      addPayment( paymentAmount); 
      fetchPaymentHistory( selectedCustomer!); // Use applyPayment instead of addPayment
    }else {
    debugPrint('Invalid payment amount or customer not selected');
  }
  }

  
String formatDateToLocal(String isoDate) {
  try {
    DateTime parsedDate = DateTime.parse(isoDate).toUtc(); // Interpret as UTC
    DateTime localDate = parsedDate.toLocal(); // Convert to local time
    return DateFormat('yyyy-MM-dd').format(localDate);
  } catch (e) {
    debugPrint('Error parsing date: $e');
    return isoDate;
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

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          color: const Color.fromARGB(255, 250, 234, 205),
          child: Column(
            children: [
              // Dropdown for selecting customer
              DropdownButtonFormField<String>(
                value: selectedCustomer,
                items: customers.map((customer) {
                  return DropdownMenuItem(value: customer, child: Text(customer));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCustomer = value;
                  });
                  if (value != null) {
                    fetchCustomerSummary(value);
                    fetchPaymentHistory(value);
                  }
                },
                decoration: const InputDecoration(labelText: 'Select Customer'),
              ),
              const SizedBox(height: 20),
              if (_summary.isNotEmpty) ...[
                Text('***** To pay: Rs. ${_summary['balance']} *****', style: const TextStyle(
                        color: Color.fromARGB(255, 143, 55, 55),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
              ],
              const SizedBox(height: 20),
              TextField(
                controller: _paymentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Payment Amount'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(width: 10),
                  Text(_selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : 'No Date Selected'),
                ],
              ),
              const SizedBox(height: 30),
              Container(decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: const Color.fromARGB(255, 236, 39, 4),
                        ),
                child: ElevatedButton(
                  
                  onPressed: _onAddPaymentPressed,
                  
                  child: const Text('Add Payment',style: const TextStyle(
                            color: Color.fromARGB(255, 177, 2, 2),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Payment History:',style: const TextStyle(
                          color: Color.fromARGB(255, 7, 161, 141),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        )),
              Expanded(
                child: Container(
                  color: const Color.fromARGB(255, 228, 208, 172),
                  child: ListView.builder(
                    itemCount: _paymentHistory.length,
                    itemBuilder: (context, index) {
                      final payment = _paymentHistory[index];
                      return ListTile(
                        title: Text('\t\t\t\t\t\t\t\t\t\t\t# \tPaid Rs. ${payment['payment_amount']}', style: const TextStyle(
                          color: Color.fromARGB(255, 11, 1, 146),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )),
                        subtitle: Text('\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tDate:  ${formatDateToLocal(payment['payment_date'])}',style: const TextStyle(
                          color: Color.fromARGB(255, 1, 0, 14),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        )),
                      );
                    },
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
