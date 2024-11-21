import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  UpdateUserwallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Wallet": amount});
  }

  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addFoodToCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }

  Future addOrder(Map<String, dynamic> orderInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('orders')
        .add(orderInfoMap);
  }

  Future<Stream<QuerySnapshot>> getAllOrders() async {
    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future clearUserCart(String userId) async {
    QuerySnapshot cartItems = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .get();
    for (QueryDocumentSnapshot doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }
}

Future<void> clearUserCart(String userId) async {
  final cartCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('Cart');
  final cartSnapshot = await cartCollection.get();

  for (DocumentSnapshot ds in cartSnapshot.docs) {
    await ds.reference.delete();
  }
}
