import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class CustomerHomePage extends StatefulWidget {
	const CustomerHomePage({super.key});
	@override
		CustomerHomePageState createState() => CustomerHomePageState();
	}
class CustomerHomePageState extends State<CustomerHomePage> {
   String? selectedCustomer; // Selected customer for the dropdown

  final List<String> customers = ['Customer A', 'Customer B', 'Customer C']; // Sample customer list

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 194, 117, 2), // Light Orange
        title: const Text(
          'Customers ',
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
										padding: const EdgeInsets.only( top: 60),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
											
												Container(
													margin: const EdgeInsets.only( bottom: 8, left: 28),
													child: const Text(
														"Customer  Name",
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
                const SizedBox(height: 20),
												IntrinsicHeight(
													child: Container(
														margin: const EdgeInsets.only( bottom: 12, left: 10, right: 30),
														width: double.infinity,
														child: Row(
															mainAxisAlignment: MainAxisAlignment.spaceBetween,
															children: [
																IntrinsicHeight(
																	child: Container(
																		decoration: BoxDecoration(
																			border: Border.all(
																				color: const Color.fromARGB(255, 21, 1, 132),
																				width: 5,
																			),
																			borderRadius: BorderRadius.circular(20),
                                      
																		),
																		padding: const EdgeInsets.only( top: 21, bottom: 21, left: 20, right: 20),
																		width: 160,
																		child: Column(
																			crossAxisAlignment: CrossAxisAlignment.start,
																			children: [
																				Container(
																					margin: const EdgeInsets.only( bottom: 28),
																					child: const Text(
																						"Total Amount",
																						style: TextStyle(
																							color: Color(0xFF000000),
																							fontSize: 16,
																						),
																					),
																				),
																				const Text(
																					"Rs. 280000",
																					style: TextStyle(
																						color: Color(0xFF000000),
																						fontSize: 24,
																					),
																				),
																			]
																		),
																	),
																),
																IntrinsicHeight(
																	child: Container(
																		decoration: BoxDecoration(
																			border: Border.all(
																				color: const Color.fromARGB(255, 127, 1, 129),
																				width: 5,
																			),
																			borderRadius: BorderRadius.circular(20),
																		),
																		padding: const EdgeInsets.symmetric(vertical: 23),
                                    
																		width: 160,
																		child: Column(
																			crossAxisAlignment: CrossAxisAlignment.start,
																			children: [
																				Container(
																					margin: const EdgeInsets.only( bottom: 27, left: 30, right: 30),
																					width: double.infinity,
																					child: const Text(
																						"last Payment",
																						style: TextStyle(
																							color: Color(0xFF000000),
																							fontSize: 16,
																						),
																					),
																				),
																				Container(
																					margin: const EdgeInsets.symmetric(horizontal: 20),
																					width: double.infinity,
																					child: const Text(
																						"Rs. 250000",
																						style: TextStyle(
																							color: Color(0xFF000000),
																							fontSize: 24,
																						),
																					),
																				),
																			]
																		),
																	),
																),
															]
														),
													),
												),
												InkWell(
													child: IntrinsicHeight(
														child: Container(
															decoration: BoxDecoration(
																border: Border.all(
																	color: const Color.fromARGB(255, 252, 100, 70),
																	width: 6,
																),
																borderRadius: BorderRadius.circular(20),
															),
															padding: const EdgeInsets.symmetric(vertical: 17),
															margin: const EdgeInsets.only( bottom: 12, left: 52, right: 52),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.center,
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 30),
																		child: const Text(
																			"Balance",
																			style: TextStyle(
																				color: Color(0xFF000000),
																				fontSize: 16,
																			),
																		),
																	),
																	const Text(
																		"Rs. 250000",
																		style: TextStyle(
																			color: Color(0xFFFF0B0B),
																			fontSize: 24,
																		),
																	),
																]
															),
														),
													),
												),
												IntrinsicHeight(
  child: Container(
    margin: const EdgeInsets.only(bottom: 40, left: 100, right: 110),
    width: double.infinity,
    child: InkWell(
      onTap: () {
        // Define what happens when the button is pressed
        print("Payment button pressed");
      },
      borderRadius: BorderRadius.circular(8), // Optional, for rounded effect
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            height: 44,
            child: Icon(
              Icons.add_to_queue, // Choose the desired icon
              size: 50, // Adjust the size of the icon
              color: Colors.black, // Set the icon color
            ),
          ),
          Text(
            "Payment ",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  ),
),

												IntrinsicHeight(
  child: Container(
    margin: const EdgeInsets.only(bottom: 40, left: 90, right: 95),
    width: double.infinity,
    child: InkWell(
      onTap: () {
        // Define what happens when the button is pressed
        print("Payment button pressed");
      },
      borderRadius: BorderRadius.circular(8), // Optional, for rounded effect
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            height: 44,
            child: Icon(
              Icons.history, // Choose the desired icon
              size: 50, // Adjust the size of the icon
              color: Colors.black, // Set the icon color
            ),
          ),
          Text(
            "Job History ",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  ),
),

												IntrinsicHeight(
  child: Container(
    margin: const EdgeInsets.only(bottom: 40, left: 90, right: 80),
    width: double.infinity,
    child: InkWell(
      onTap: () {
        // Define what happens when the button is pressed
        print("Payment button pressed");
      },
      borderRadius: BorderRadius.circular(8), // Optional, for rounded effect
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            height: 44,
            child: Icon(
              Icons.add, // Choose the desired icon
              size: 50, // Adjust the size of the icon
              color: Colors.black, // Set the icon color
            ),
          ),
          Text(
            "Add Customer ",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  ),
),
												IntrinsicHeight(
  child: Container(
    margin: const EdgeInsets.only(bottom: 40, left: 90, right: 95),
    width: double.infinity,
    child: InkWell(
      onTap: () {
        // Define what happens when the button is pressed
        print("Payment button pressed");
      },
      borderRadius: BorderRadius.circular(8), // Optional, for rounded effect
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            height: 44,
            child: Icon(
              Icons.payment_outlined, // Choose the desired icon
              size: 50, // Adjust the size of the icon
              color: Colors.black, // Set the icon color
            ),
          ),
          Text(
            "Job History ",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 16,
            ),
          ),
        ],
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