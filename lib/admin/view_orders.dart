import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bmsce_canteens/service/database.dart';
import 'package:bmsce_canteens/widget/widget_support.dart';

class ViewOrders extends StatefulWidget {
  const ViewOrders({super.key});

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  Stream<QuerySnapshot>? orderStream;
  String selectedTimeSlot = 'all'; // 'all' to show all orders initially
  Set<String> completedOrders = {}; // Track completed orders locally

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    Stream<QuerySnapshot> fetchedStream = await DatabaseMethods().getAllOrders();
    setState(() {
      orderStream = fetchedStream;
    });
  }

  Future<void> markOrderAsCompleted(String orderNumber) async {
    try {
      // Fetch the document with the corresponding orderNumber
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('orderNumber', isEqualTo: orderNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs[0].id;

        // Update the status to 'completed'
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(documentId)
            .update({'status': 'Completed'});

        setState(() {
          completedOrders.add(orderNumber);
        });
      } else {
        print("Order with orderNumber $orderNumber not found.");
      }
    } catch (e) {
      print("Error marking order as completed: $e");
    }
  }

  Future<void> clearOrdersByTimeSlot(String timeSlot) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('timeSlot', isEqualTo: timeSlot)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Optionally re-fetch orders to update UI if needed
      fetchOrders();
    } catch (e) {
      print("Error clearing orders: $e");
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    return userSnapshot.data() as Map<String, dynamic>;
  }

  Widget buildOrderItem(String orderNumber, Map<String, dynamic> item, String itemId) {
    return ListTile(
      title: Text(
        '${item['Name'] ?? 'Unknown Item'} (Quantity: ${item['Quantity'] ?? 0})',
        style: AppWidget.semiBoldTextFeildStyle(),
      ),
    );
  }

  Widget buildOrderCard(String orderNumber, Map<String, dynamic> orderData, DateTime orderTime) {
    List<dynamic> items = orderData['items'] ?? [];
    bool isCompleted = orderData['status'] == 'Completed' || completedOrders.contains(orderNumber);

    return FutureBuilder(
      future: fetchUserDetails(orderData['userId']),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.hasError) {
          return Center(child: Text('Error fetching user details: ${userSnapshot.error}'));
        }
        if (!userSnapshot.hasData) {
          return const Center(child: Text('User details not found.'));
        }

        Map<String, dynamic> userData = userSnapshot.data!;
        String userName = userData['Name'] ?? 'Unknown';
        String userEmail = userData['Email'] ?? 'Unknown';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionTile(
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Order #$orderNumber',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '\nOrdered by: $userName ($userEmail)',
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: '\nOrdered at: ${orderTime.toLocal().toString()}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            trailing: isCompleted
                ? const Icon(Icons.check_circle, color: Colors.green, size: 30.0)
                : TextButton(
              onPressed: () async {
                await markOrderAsCompleted(orderNumber);
              },
              child: const Text('Mark as Completed', style: TextStyle(color: Colors.green)),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...items.map((item) => buildOrderItem(orderNumber, item, item['id'] ?? 'UnknownId')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total: ₹${(orderData['total'] ?? 0).toStringAsFixed(2)}',
                      style: AppWidget.boldTextFeildStyle().copyWith(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildOrdersByTimeSlot(String timeSlot, List<Map<String, dynamic>> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$timeSlot \nOrders',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.purple,
                ),
              ),
              if (timeSlot != 'all')
                TextButton(
                  onPressed: () async {
                    await clearOrdersByTimeSlot(timeSlot);
                  },
                  child: const Text('Clear Cart', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
        ...orders.map((order) {
          String orderNumber = order['orderNumber'] ?? 'N/A';
          Timestamp? timestamp = order['timestamp'] as Timestamp?;
          DateTime orderTime = timestamp?.toDate() ?? DateTime.now(); // Provide a default DateTime
          return buildOrderCard(orderNumber, order, orderTime);
        }),
      ],
    );
  }

  Widget orderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: orderStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No orders found.'));
        }

        Map<String, List<Map<String, dynamic>>> categorizedOrders = {
          'Tea-break (10.45 am)': [],
          'Lunch-break (1.00 pm)': [],
          '20 mins': [],
        };

        for (var doc in snapshot.data!.docs) {
          Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
          String timeSlot = orderData['timeSlot'] ?? 'Unknown';
          if (categorizedOrders.containsKey(timeSlot)) {
            categorizedOrders[timeSlot]!.add(orderData);
          }
        }

        // Filter orders based on selected time slot
        if (selectedTimeSlot != 'all') {
          categorizedOrders.forEach((key, value) {
            if (key != selectedTimeSlot) {
              categorizedOrders[key] = [];
            }
          });
        }

        return ListView(
          children: categorizedOrders.entries.map((entry) {
            String timeSlot = entry.key;
            List<Map<String, dynamic>> orders = entry.value;
            return orders.isNotEmpty ? buildOrdersByTimeSlot(timeSlot, orders) : const SizedBox();
          }).toList(),
        );
      },
    );
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Orders'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilterChip(
                      label: const Text('Tea-break (10.45 am)'),
                      selected: selectedTimeSlot == 'Tea-break (10.45 am)',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedTimeSlot = isSelected ? 'Tea-break (10.45 am)' : 'all';
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: FilterChip(
                      label: const Text('Lunch-break (1.00 pm)'),
                      selected: selectedTimeSlot == 'Lunch-break (1.00 pm)',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedTimeSlot = isSelected ? 'Lunch-break (1.00 pm)' : 'all';
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FilterChip(
                      label: const Text('           20 mins           '),
                      selected: selectedTimeSlot == '20 mins',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedTimeSlot = isSelected ? '20 mins' : 'all';
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: FilterChip(
                      label: const Text('          All Orders          '),
                      selected: selectedTimeSlot == 'all',
                      onSelected: (isSelected) {
                        setState(() {
                          selectedTimeSlot = isSelected ? 'all' : selectedTimeSlot;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(child: orderList()),
        ],
      ),
    );
  }

}
