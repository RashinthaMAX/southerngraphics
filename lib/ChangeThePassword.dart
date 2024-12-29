import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class ChangeThePassword extends StatefulWidget {
	const ChangeThePassword({super.key});
	@override
		ChangeThePasswordState createState() => ChangeThePasswordState();
	}
class ChangeThePasswordState extends State<ChangeThePassword> {
     String? selectedCustomer; 
  final List<String> customers = ['Customer A', 'Customer B', 'Customer C']; // Sample customer list

	 String textField1 = '';
   String textField2 = '';
   String textField3 = '';
  
  
  @override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 194, 117, 2), // Light Orange
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontFamily: 'Yasarath',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 248, 246, 246),
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
                color: Color.fromARGB(96, 0, 0, 0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
   

			body: SafeArea(
				child: Container(
					constraints: const BoxConstraints.expand(),
					color: const Color.fromARGB(255, 255, 255, 255),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: Container(
									color: const Color.fromARGB(255, 227, 227, 227),
									width: double.infinity,
									height: double.infinity,
									child: SingleChildScrollView(
										padding: const EdgeInsets.only( top: 64),
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
													margin: const EdgeInsets.only( bottom: 10, left: 26),
													child: const Text(
														"New Password",
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
                              obscureText: true,
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
													margin: const EdgeInsets.only( bottom: 10, left: 26),
													child: const Text(
														"Confirm Password",
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
														margin: const EdgeInsets.only( bottom: 39, left: 33, right: 33),
														width: double.infinity,
														child: TextField(
															style: const TextStyle(
																color: Color(0xFF565454),
																fontSize: 15,
															),
															onChanged: (value) { 
																setState(() { textField3 = value; });
															},
                              obscureText: true,
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
													onTap: () { if (kDebugMode) {
													  print('Pressed');
													} },
													child: IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																borderRadius: BorderRadius.circular(12),
																color: const Color(0xFF205192),
															),
															padding: const EdgeInsets.symmetric(vertical: 12),
															margin: const EdgeInsets.only( bottom: 150, left: 130, right: 130),
															width: double.infinity,
															child: const Column(
																children: [
																	Text(
																		"Submit",
																		style: TextStyle(
																			color: Color(0xFFFFFFFF),
																			fontSize: 15,
                                      fontWeight: FontWeight.bold,
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