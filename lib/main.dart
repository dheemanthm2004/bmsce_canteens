import 'package:bmsce_canteens/admin/admin_login.dart';
import 'package:bmsce_canteens/pages/bottomnav.dart';
import 'package:bmsce_canteens/pages/onboard.dart';
import 'package:bmsce_canteens/widget/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = publishableKey;

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMS-CANTEENS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Onboard(),
    );
  }
}
