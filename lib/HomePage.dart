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
import 'package:southern/test.dart';

class DailyWorkListPage extends StatefulWidget {
  const DailyWorkListPage({super.key});

  @override
  _DailyWorkListPageState createState() => _DailyWorkListPageState();
}

class _DailyWorkListPageState extends State<DailyWorkListPage> {
 DateTime _selectedDate = DateTime.now();
  double _totalImpressionAmount = 0.0;
  double _totalPayment = 0.0;
  double _noofimpression = 0.0;
  List<dynamic> dailyWorks = [];
  int _currentIndex = 0;

  Future<void> _fetchDailyWorks() async {
    final formattedDate =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    try {
      final response = await http.get(Uri.parse('http://192.168.1.31:3000/dailyworks/$formattedDate'));
      if (response.statusCode == 200) {
        setState(() {
          dailyWorks = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load daily works');
      }
    } catch (error) {
      print('Error fetching daily works: $error');
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      await _fetchDataForSelectedDate(_selectedDate);
      await _fetchDailyWorks();
    }
  }

  Future<void> _fetchDataForSelectedDate(DateTime selectedDate) async {
  final formattedDate =
      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
  final response = await http.post(
    Uri.parse('http://192.168.1.31:3000/getDailyWorks'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'selectedDate': formattedDate}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    setState(() {
      // Ensure we handle both int and double types by casting them properly
      _totalImpressionAmount = (data['total_impression_amount'] is int)
          ? (data['total_impression_amount'] as int).toDouble()
          : data['total_impression_amount'].toDouble();
      _totalPayment = (data['total_payment'] is int)
          ? (data['total_payment'] as int).toDouble()
          : data['total_payment'].toDouble();
      _noofimpression = (data['total_impression'] is int)
          ? (data['total_impression'] as int).toDouble()
          : data['total_impression'].toDouble();
    });
  } else {
    throw Exception('Failed to load data');
  }
}


  @override
  void initState() {
    super.initState();
    _fetchDailyWorks();
    _fetchDataForSelectedDate(_selectedDate);
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
          color: const Color.fromARGB(255, 250, 234, 205),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year} Impression Summery",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 43, 20, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _pickDate(context),
                        child: const Icon(
                          Icons.calendar_today,
                          size: 19,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //_buildDataCard("Impression Amount", "Rs. $_totalImpressionAmount"),
                    _buildDataCard("Number of Impression", " $_noofimpression"),
                    _buildDataCard("Impression Amount", "Rs. $_totalImpressionAmount"),
                  ],
                ),
              ),
              //_buildSummaryCard(),
           Expanded(
  child: AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: dailyWorks.isEmpty
        ? const Center(
            child: Text(
              "No works available for the selected date",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          )
        : Container(
            color: const Color.fromARGB(255, 228, 208, 172), // Set the desired background color here
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
                      '($count). ${work['customer_name']}',
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
                          "Job Name: \t${work['job_name']}",
                          style: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "* Impressions: ${work['no_of_impressions']} \n* Impression Amount: Rs. ${work['impression_amount']}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 12, 0, 0),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        /*Text(
                          "* Payment: Rs. ${work['payment']}",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 143, 55, 55),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),*/
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
      padding: const EdgeInsets.symmetric(vertical: 21),
      width: 150,
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
            style: const TextStyle(color: Colors.black, fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF9D4C00), width: 4),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Impression Payment",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          Text(
            "Rs. $_totalPayment",
            style: const TextStyle(color: Colors.red, fontSize: 24),
          ),
        ],
      ),
    );
  }
}

class ProfileSetupPage {
}
