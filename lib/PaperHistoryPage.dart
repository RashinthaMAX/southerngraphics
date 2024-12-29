import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:southern/CustomerHomePage.dart';
import 'package:southern/DailyImpressionPage.dart';
import 'package:southern/HomePage.dart';
import 'package:southern/NewJobHistoryPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/customerJobhistory.dart';

class PaperDetailsPage extends StatefulWidget {
  const PaperDetailsPage({Key? key}) : super(key: key);

  @override
  _PaperDetailsPageState createState() => _PaperDetailsPageState();
}

class _PaperDetailsPageState extends State<PaperDetailsPage> {
  List<dynamic> toPayList = [];
  List<dynamic> paidList = [];
    int _currentIndex = 4;

  @override
  void initState() {
    super.initState();
    fetchPaperDetails();
  }

  Future<void> fetchPaperDetails() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.31:3000/paperdetails'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          // Explicitly cast `balance` to double to avoid type errors
          toPayList = data
              .where((item) => (item['balance'] as num).toDouble() > 0)
              .toList();
          paidList = data
              .where((item) => (item['balance'] as num).toDouble() <= 0)
              .toList();
        });
      } else {
        throw Exception('Failed to load paper details');
      }
    } catch (error) {
      print('Error fetching paper details: $error');
    }
  }

  Future<void> _updatePayment(int id, double additionalPayment) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.31:3000/updatePaymentpaper'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'additionalPayment': additionalPayment}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment updated successfully!")),
        );
        fetchPaperDetails(); // Refresh the data after successful payment
      } else {
        throw Exception('Failed to update payment');
      }
    } catch (error) {
      print('Error updating payment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update payment")),
      );
    }
  }

  void _showPaymentDialog(int id, double balance) {
    final TextEditingController paymentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Make a Payment"),
          content: TextField(
            controller: paymentController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Enter payment amount"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final payment = double.tryParse(paymentController.text) ?? 0.0;
                if (payment > 0 && payment <= balance) {
                  _updatePayment(id, payment);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid payment amount")),
                  );
                }
              },
              child: const Text("Pay"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaperCard(Map<String, dynamic> paper, {bool isToPay = false}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Container(
      color: isToPay
          ? const Color.fromARGB(255, 255, 245, 230) // Light orange for "To Pay"
          : const Color.fromARGB(255, 230, 255, 230), // Light green for "Paid"
      padding: const EdgeInsets.all(8.0), // Padding inside the card
      child: ListTile(
        title: Text(
          paper['shop_name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Amount: Rs. ${(paper['amount'] as num).toDouble()}"),
            Text("Payment: Rs. ${(paper['payment'] as num).toDouble()}"),
            Text(
              "To pay : Rs. ${(paper['balance'] as num).toDouble()}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 133, 54, 2),
              ),
            ),
            if (paper['description'] != null)
              Text("Description: ${paper['description']}"),
            Text("Date: ${paper['date']}"),
          ],
        ),
        trailing: isToPay
            ? ElevatedButton(
  onPressed: () => _showPaymentDialog(
      paper['id'], (paper['balance'] as num).toDouble()),
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 235, 22, 40), // Set the text color (White)
  ),
  child: const Text("Pay"),
)

            : const Icon(Icons.check, color: Colors.green),
      ),
    ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "*** To Pay",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 235, 22, 40)),
                ),
              ),
              Container(  // Wrap the list of unpaid items in a Container to set a background color
            color: Color.fromARGB(255, 252, 164, 148),  // Light orange for "To Pay"
            child: Column(
              children: toPayList.map((paper) => _buildPaperCard(paper, isToPay: true)).toList(),
            ),
          ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "*** Paid",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 2, 165, 43)),
                ),
              ),
              Container(  // Wrap the list of paid items in a Container to set a background color
            color: Color.fromARGB(255, 211, 250, 140),  // Light green for "Paid"
            child: Column(
              children: paidList.map((paper) => _buildPaperCard(paper)).toList(),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
