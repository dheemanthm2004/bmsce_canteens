import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart extends StatelessWidget {
  final Map<String, int> cartItems;
  final String userId;

  const Cart(this.cartItems, this.userId, {super.key});

  Future<void> clearCart() async {
    final cartCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart');
    final cartSnapshot = await cartCollection.get();

    for (DocumentSnapshot ds in cartSnapshot.docs) {
      await ds.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = cartItems.values.fold(0, (prev, curr) => prev + curr);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await clearCart(); // Call the function to clear cart items
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart cleared')),
              );
              Navigator.pop(context); // Go back after clearing the cart
            },
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(
        child: Text('Cart is empty.'),
      )
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          String itemName = cartItems.keys.elementAt(index);
          int quantity = cartItems.values.elementAt(index);
          return ListTile(
            title: Text(itemName),
            subtitle: Text('Quantity: $quantity'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50.0,
          child: Center(
            child: Text(
              'Total Items: $totalItems',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
