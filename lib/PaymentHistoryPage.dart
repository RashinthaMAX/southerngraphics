import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class PaymentHistoryPage extends StatefulWidget {
	const PaymentHistoryPage({super.key});
	@override
		PaymentHistoryPageState createState() => PaymentHistoryPageState();
	}
class PaymentHistoryPageState extends State<PaymentHistoryPage> {
     String? selectedCustomer; // Selected customer for the dropdown

  final List<String> customers = ['Customer A', 'Customer B', 'Customer C']; // Sample customer list
	@override
	Widget build(BuildContext context) {
		return Scaffold(
      
			appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 194, 117, 2), // Light Orange
        title: const Text(
          'To Do Pay list',
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
										padding: const EdgeInsets.only( top: 65),
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
														margin: const EdgeInsets.only( bottom: 23, left: 145, right: 100),
														width: double.infinity,
														child: const Row(
															mainAxisAlignment: MainAxisAlignment.spaceBetween,
															children: [
																SizedBox(
																	width: 30,
																	height: 30,
																	child:Icon(
              Icons.payment, // Choose the desired icon
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
															]
														),
													),
												),
												IntrinsicHeight(
													child: Container(
														decoration: BoxDecoration(
															border: Border.all(
																color: const Color(0xFFF2F2F2),
																width: 1,
															),
														),
														margin: const EdgeInsets.only( bottom: 53, left: 10, right: 5),
														width: double.infinity,
														child: Column(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																IntrinsicHeight(
																	child: SizedBox(
																		width: double.infinity,
																		child: Row(
																			mainAxisAlignment: MainAxisAlignment.spaceBetween,
																			children: [
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 99),
																						width: 171,
																						child: const Row(
																							mainAxisAlignment: MainAxisAlignment.spaceBetween,
																							children: [
																								Text(
																									"Date",
																									style: TextStyle(
																										color: Color(0xFF0B0B0B),
																										fontSize: 16,
                                                    fontWeight: FontWeight.w900,
																									),
																								),
																								/*SizedBox(
																									width: 16,
																									height: 16,
																									child: Icon(
                                                    Icons.sort_by_alpha,
                                                  )
																								),*/
																							]
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.all(16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"Payments",
																									style: TextStyle(
																										color: Color(0xFF0C0C0C),
																										fontSize: 15,
                                                     fontWeight: FontWeight.w900,
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
																IntrinsicHeight(
																	child: SizedBox(
																		width: double.infinity,
																		child: Row(
																			mainAxisAlignment: MainAxisAlignment.spaceBetween,
																			children: [
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"12.12.2024",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
																									),
																								),
																							]
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"3750",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
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
																IntrinsicHeight(
																	child: SizedBox(
																		width: double.infinity,
																		child: Row(
																			mainAxisAlignment: MainAxisAlignment.spaceBetween,
																			children: [
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 17, bottom: 17, left: 16, right: 16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"11.10.2024",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
																									),
																								),
																							]
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.all(16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"2585",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
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
																IntrinsicHeight(
																	child: SizedBox(
																		width: double.infinity,
																		child: Row(
																			mainAxisAlignment: MainAxisAlignment.spaceBetween,
																			children: [
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"8/16/13",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
																									),
																								),
																							]
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"\$710.68",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
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
																IntrinsicHeight(
																	child: SizedBox(
																		width: double.infinity,
																		child: Row(
																			mainAxisAlignment: MainAxisAlignment.spaceBetween,
																			children: [
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"1/15/12",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
																									),
																								),
																							]
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"\$601.13",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
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
																IntrinsicHeight(
																	child: SizedBox(
																		width: double.infinity,
																		child: Row(
																			mainAxisAlignment: MainAxisAlignment.spaceBetween,
																			children: [
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"4/21/12",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
																									),
																								),
																							]
																						),
																					),
																				),
																				IntrinsicHeight(
																					child: Container(
																						color: const Color(0xFFFFFFFF),
																						padding: const EdgeInsets.only( top: 15, bottom: 15, left: 16, right: 16),
																						width: 171,
																						child: const Column(
																							crossAxisAlignment: CrossAxisAlignment.start,
																							children: [
																								Text(
																									"\$943.65",
																									style: TextStyle(
																										color: Color(0xFF404040),
																										fontSize: 12,
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
															]
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