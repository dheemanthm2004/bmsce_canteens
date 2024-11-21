import 'dart:async';
import 'dart:math';
import 'package:bmsce_canteens/pages/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bmsce_canteens/service/database.dart';
import 'package:bmsce_canteens/service/shared_pref.dart';
import 'package:bmsce_canteens/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

String generateOrderNumber() {
  final random = Random();
  return (10000 + random.nextInt(90000)).toString();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0;
  List<Map<String, dynamic>> foodItems = [];
  String? selectedTimeSlot = 'Tea-break (10.45 am)'; // Default time slot

  List<String> timeSlots = [
    'Tea-break (10.45 am)',
    'Lunch-break (1.00 pm)',
    '20 mins'
  ];

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      setState(() {});
    });
  }

  Future<void> getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  Future<void> ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
    startTimer();
  }

  Stream? foodStream;

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          foodItems.clear();
          total = 0; // Reset total for each build
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              total += int.parse(ds["Total"]);
              foodItems.add({
                "Name": ds["Name"],
                "Quantity": ds["Quantity"],
                "Total": ds["Total"],
                "Image": ds["Image"]
              });
              return Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: 90,
                          width: 40,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text(ds["Quantity"])),
                        ),
                        const SizedBox(width: 20.0),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              ds["Image"],
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )),
                        const SizedBox(width: 20.0),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds["Name"],
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              Text(
                                "₹" + ds["Total"],
                                style: AppWidget.semiBoldTextFeildStyle(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<void> showConfirmationDialog() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total Price: ₹$total"), // Show full total
              Text("Available Balance: ₹$wallet"),
              const SizedBox(height: 10),
              ...foodItems.map((item) {
                return Text(
                  '${item['Name']} (Quantity: ${item['Quantity']}) - ₹${item['Total']}',
                );
              }),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      checkWalletAndProceed();
    }
  }

  void checkWalletAndProceed() async {
    if (total == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Empty Cart'),
            content: const Text(
                'Your cart is empty. Please add items to your cart before checking out.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    int walletAmount = int.parse(wallet!);
    if (walletAmount < total) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Insufficient Funds'),
            content: Text(
                'Your current wallet balance is ₹$walletAmount, but the total price is ₹$total. Please add funds to continue.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      completeCheckout();
    }
  }

  void completeCheckout() async {
    String orderNumber = generateOrderNumber();

    // Add order to Firestore orders collection with order number
    await DatabaseMethods().addOrder({
      'userId': id,
      'items': foodItems,
      'total': total,
      'timeSlot': selectedTimeSlot,
      'timestamp': FieldValue.serverTimestamp(),
      'orderNumber': orderNumber,
      'status': 'Pending', // Set initial status to pending
    });

    // Update user's wallet balance
    int amount = int.parse(wallet!) - total;
    await DatabaseMethods().UpdateUserwallet(id!, amount.toString());
    await SharedPreferenceHelper().saveUserWallet(amount.toString());

    // Clear user's cart
    await DatabaseMethods().clearUserCart(id!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptPage(
          foodItems: foodItems,
          totalPrice: total,
          orderNumber: orderNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60.0,
                  bottom: 120.0), // Padding to avoid overlap with footer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 2.0,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Center(
                        child: Text(
                          "Food Cart",
                          style: AppWidget.HeadlineTextFeildStyle(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: foodCart(),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
          // Fixed footer at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DropdownButtonFormField<String>(
                      value: selectedTimeSlot,
                      decoration: InputDecoration(
                        labelText: 'Select Time Slot',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      items: timeSlots.map((String slot) {
                        return DropdownMenuItem<String>(
                          value: slot,
                          child: Text(slot),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedTimeSlot = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await DatabaseMethods().clearUserCart(id!);
                          setState(() {
                            foodItems.clear();
                            total = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete_forever,
                                  color: Colors.red[700], size: 20.0),
                              const SizedBox(width: 8.0),
                              Text(
                                'Clear Cart',
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 12.0), // Increased vertical padding
                        decoration: BoxDecoration(
                          color: Colors.green[500],
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (total == 0) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Empty Cart'),
                                    content: const Text(
                                        'Your cart is empty. Please add items to your cart before checking out.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showConfirmationDialog();
                            }
                          },
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 8.0),
                                Text(
                                  'Checkout',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0), // Increased font size
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Price",
                          style: AppWidget.boldTextFeildStyle(),
                        ),
                        Text(
                          "₹$total",
                          style: AppWidget.semiBoldTextFeildStyle(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
