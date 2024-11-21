import 'dart:io';
import 'package:bmsce_canteens/service/auth.dart';
import 'package:bmsce_canteens/service/shared_pref.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:bmsce_canteens/pages/login.dart';
import 'package:bmsce_canteens/pages/termsandcondition.dart';
import 'package:bmsce_canteens/pages/about.dart';
import 'package:bmsce_canteens/pages/order_history.dart'; // Import Order History Page

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email, userId; // Added userId
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    selectedImage = File(image!.path);
    setState(() {
      uploadItem();
    });
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("profileImages")
          .child(addId); // Updated storage path
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserProfile(downloadUrl);
      setState(() {
        profile = downloadUrl;
      });
    }
  }

  getthesharedpref() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    userId = await SharedPreferenceHelper().getUserId(); // Added userId
    setState(() {});
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    onthisload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 45.0, left: 20.0, right: 20.0),
                        height: MediaQuery.of(context).size.height / 4.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.elliptical(
                                    MediaQuery.of(context).size.width, 105.0))),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 6.5),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(60),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: selectedImage == null
                                  ? GestureDetector(
                                      onTap: () {
                                        getImage();
                                      },
                                      child: profile == null
                                          ? Image.asset(
                                              "images/boy.png",
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              profile!,
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            ),
                                    )
                                  : Image.file(
                                      selectedImage!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ProfileItem(icon: Icons.person, label: "Name", value: name!),
                  const SizedBox(height: 30.0),
                  ProfileItem(icon: Icons.email, label: "Email", value: email!),
                  const SizedBox(height: 30.0),
                  ProfileItem(
                    icon: Icons.history,
                    label: "Order History",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderHistoryPage(
                                userId: userId!)), // Pass userId
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                  ProfileItem(
                    icon: Icons.description,
                    label: "Terms and Condition",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsAndCondition()),
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                  ProfileItem(
                    icon: Icons.info,
                    label: "About",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const About()),
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      AuthMethods().SignOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LogIn()),
                      );
                    },
                    child: const Text("Log Out"),
                  ),
                ],
              ),
            ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  const ProfileItem({super.key, 
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 2.0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                    if (value != null)
                      Text(
                        value!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
