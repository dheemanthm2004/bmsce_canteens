import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:bmsce_canteens/widget/widget_support.dart';

class ReceiptPage extends StatelessWidget {
  final List<Map<String, dynamic>> foodItems;
  final int totalPrice;
  final String orderNumber; // Add order number here

  const ReceiptPage({
    super.key,
    required this.foodItems,
    required this.totalPrice,
    required this.orderNumber, // Initialize order number here
  });

  @override
  Widget build(BuildContext context) {
    final String qrCodeData = foodItems.map((item) => item['Name']).join(', ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Receipt',
                style: AppWidget.HeadlineTextFeildStyle(),
              ),
            ),

            const SizedBox(height: 60.0),
            PrettyQr(
              image: const AssetImage('images/bms.png'), // Ensure this path is correct
              typeNumber: 3,
              size: 200,
              data: qrCodeData,
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Order Number: $orderNumber', // Display the order number
              style: TextStyle(
                fontWeight: FontWeight.bold, // Makes the text bold
                fontSize: 24.0, // Sets the font size to be large
                fontStyle: FontStyle.italic, // Makes the text italic
                color: Colors.blue, // Sets the color of the text
                letterSpacing: 1.2, // Adds space between letters
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // Centers the text
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Take a screenshot for further reference.',
              textAlign: TextAlign.center, // Centers the text
            ),
            const SizedBox(height: 10.0),
            Text(
              'Thank you for ordering.',
              style: AppWidget.boldTextFeildStyle(),
              textAlign: TextAlign.center, // Centers the text
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Please pick up your order within your selected time slot.',
              textAlign: TextAlign.center, // Centers the text
            ),
            const SizedBox(height: 20.0),
            // You can add more widgets or adjust spacing here if needed
          ],
        ),
      ),
    );
  }
}
