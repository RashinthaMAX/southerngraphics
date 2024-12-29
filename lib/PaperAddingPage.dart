import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:southern/CustomerHomePage.dart';
import 'package:southern/DailyImpressionPage.dart';
import 'package:southern/NewJobHistoryPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/customerJobhistory.dart';

class PaperAddingPage extends StatefulWidget {
  const PaperAddingPage({super.key});

  @override
  PaperAddingPageState createState() => PaperAddingPageState();
}

class PaperAddingPageState extends State<PaperAddingPage> {
  String textField2 = ''; // For amount
  String textField3 = ''; // For payment
  String description = 'A4 500 papers';
  DateTime _selectedDate = DateTime.now();
  String? _dropdownValue;
  List<String> _dropdownOptions = [];
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

  Future<List<String>> fetchShopNames() async {
    const url = 'http://192.168.1.31:3000/getShopNames'; // Replace with your server's URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<String>((shop) => shop['shop_name'] as String).toList();
      } else {
        throw Exception('Failed to load shop names');
      }
    } catch (e) {
      throw Exception('Error fetching shop names: $e');
    }
  }

  Future<void> submitPaperDetails() async {
    const url = 'http://192.168.1.31:3000/addPaperDetails'; // Replace with your server URL
    final data = {
      'shopName': _dropdownValue,
      'amount': double.tryParse(textField2) ?? 0.0,
      'payment': double.tryParse(textField3) ?? 0.0,
      'description': description,
      'date': _selectedDate.toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data submitted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit data: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadShopNames();
  }

  Future<void> loadShopNames() async {
    try {
      final shopNames = await fetchShopNames();
      setState(() {
        _dropdownOptions = shopNames;
        _dropdownValue = shopNames.isNotEmpty ? shopNames[0] : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return; // Avoid navigating multiple times
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerHomePage()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyImpressionPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Customerjobhistory()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewJobHistoryPage()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PaperDetailsPage()));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSetup()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 194, 117, 2),
        title: const Text(
          'Paper Bill Detailss',
          style: TextStyle(
            fontFamily: 'Yasarath',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 219, 217, 217),
            shadows: [
              Shadow(offset: Offset(2.0, 2.0), blurRadius: 3.0, color: Color.fromARGB(96, 0, 0, 0)),
            ],
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 181, 109, 0),
        selectedItemColor: const Color.fromARGB(255, 193, 94, 2),
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.new_label), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.scanner), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_sharp), label: ''),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_dropdownOptions.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownValue = newValue!;
                  });
                },
                items: _dropdownOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Shop Name', border: OutlineInputBorder()),
              )
            else
              const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => setState(() => textField2 = value),
              decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => setState(() => textField3 = value),
              decoration: const InputDecoration(labelText: 'Payment', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => setState(() => description = value),
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Text("Selected Date: ${_selectedDate.toLocal()}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.calendar_today), onPressed: () => _pickDate(context)),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: submitPaperDetails,
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
