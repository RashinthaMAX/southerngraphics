import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:southern/DailyImpressionPage.dart';
import 'package:southern/NewJobAddingPage.dart';
import 'package:southern/PaperHistoryPage.dart';
import 'package:southern/ProfileSetup.dart';
import 'package:southern/customerJobhistory.dart';
import 'package:intl/intl.dart';
import 'package:southern/test.dart';

class NewJobHistoryPage extends StatefulWidget {
  const NewJobHistoryPage({super.key});

  @override
  NewJobHistoryPageState createState() => NewJobHistoryPageState();
}

class NewJobHistoryPageState extends State<NewJobHistoryPage> {
  List<dynamic> toDoJobs = [];
  List<dynamic> doneJobs = [];
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    fetchJobs(); // Fetch jobs when the page loads
  }

  String formatDateToLocal(String isoDate) {
    try {
      DateTime parsedDate = DateTime.parse(isoDate).toLocal();
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing date: $e');
      }
      return isoDate; // Return the original string if parsing fails
    }
  }

  Future<void> fetchJobs() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.31:3000/newjobsshow'));
      if (response.statusCode == 200) {
        final jobs = json.decode(response.body);

        jobs.sort((b, a) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));

        setState(() {
          toDoJobs = jobs.where((job) => job['process'] == 'To Do').toList();
          doneJobs = jobs.where((job) => job['process'] == 'Done').toList();
        });
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      debugPrint('Error fetching jobs: $e');
    }
  }

  Future<void> updateJobDetails(int jobId, String jobName, String description, String process) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.31:3000/updatejob/$jobId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'jobname': jobName,
          'description': description,
          'process': process,
        }),
      );

      if (response.statusCode == 200) {
        fetchJobs(); // Refresh the job lists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job updated successfully!')),
        );
      } else {
        throw Exception('Failed to update job');
      }
    } catch (e) {
      debugPrint('Error updating job: $e');
    }
  }

  void openEditDialog(BuildContext context, Map<String, dynamic> job) {
  final TextEditingController jobNameController =
      TextEditingController(text: job['jobname']);
  final TextEditingController descriptionController =
      TextEditingController(text: job['description']);
  String selectedProcess = job['process'];

  // Ensure job['id'] is not null and is a valid number
  if (job['id'] == null || job['id'] is! int) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid job ID')),
    );
    return; // Early return if job ID is invalid
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Edit Job Details'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: jobNameController,
                decoration: const InputDecoration(
                  labelText: 'Job Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedProcess,
                decoration: const InputDecoration(
                  labelText: 'Process Status',
                  border: OutlineInputBorder(),
                ),
                items: ['To Do', 'Done'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedProcess = newValue!;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Safely cast job['id'] to int after null check
              await updateJobDetails(
                job['id'] as int, 
                jobNameController.text,
                descriptionController.text,
                selectedProcess,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}



  Widget buildJobList(String title, List<dynamic> jobs) {
    return jobs.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 48, 2, 175),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        job['customer'],
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 143, 1, 1),
                        ),
                      ),
                      subtitle: Text(
                        '***${job['jobname']}*** - \n\n${job['description']}\n ${formatDateToLocal(job['date'])}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 2, 0, 7),
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          openEditDialog(context, job);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: job['process'] == 'Done'
                              ? Colors.green
                              : Colors.red,
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 248, 248, 248),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
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
            child: const NewJobAddingPage(),
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
      body: toDoJobs.isEmpty && doneJobs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(top: 57),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildJobList('To Do JOB List', toDoJobs),
                  buildJobList('Done Job List', doneJobs),
                ],
              ),
            ),
    );
  }
}
