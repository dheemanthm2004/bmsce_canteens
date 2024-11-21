import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  final String userId;

  const OrderHistoryPage({super.key, required this.userId});

  Stream<QuerySnapshot> getOrderHistoryStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Widget buildOrderItem(Map<String, dynamic> orderData) {
    List<dynamic> items = orderData['items'] ?? [];
    Timestamp? timestamp = orderData['timestamp'] as Timestamp?;
    DateTime orderTime = timestamp?.toDate() ?? DateTime.now();
    String status = orderData['status'] ?? 'pending'; // Default to pending

    // Determine the color based on the status
    Color statusColor = status == 'Completed' ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          'Order #${orderData['orderNumber']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...items
                .map((item) =>
                Text('${item['Name']} (Qty: ${item['Quantity']})'))
                ,
            Text('Total: ₹${(orderData['total'] ?? 0).toStringAsFixed(2)}'),
            Text('Ordered at: ${orderTime.toLocal().toString()}'),
            Text(
              'Status: $status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: statusColor, // Use dynamic color based on status
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () async {
              // Clear orders for the user
              await FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: userId)
                  .get()
                  .then((snapshot) {
                for (var doc in snapshot.docs) {
                  doc.reference.delete();
                }
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getOrderHistoryStream(),
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

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
              return buildOrderItem(orderData);
            }).toList(),
          );
        },
      ),
    );
  }
}
