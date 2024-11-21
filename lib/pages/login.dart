import 'package:bmsce_canteens/pages/bottomnav.dart';
import 'package:bmsce_canteens/pages/forgotpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bmsce_canteens/pages/signup.dart';
import 'package:bmsce_canteens/widget/widget_support.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const BottomNav()));
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "Invalid credentials.";
      } else if (e.code == 'wrong-password') {
        message =
            "Invalid credentials.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid credentials.";
      } else if (e.code == 'user-disabled') {
        message = "Invalid credentials.";
      } else if (e.code == 'too-many-requests') {
        message =
            "Invalid credentials.";
      } else {
        message = "Invalid credentials.";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 255, 220, 23),
                      Color.fromARGB(255, 222, 247, 85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: const Text(""),
              ),
              Container(
                margin:
                    const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                          child: Image.asset(
                        "images/logo.png",
                        width: MediaQuery.of(context).size.width / 1.5,
                        fit: BoxFit.cover,
                      )),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Text(
                                  "Login",
                                  style: AppWidget.HeadlineTextFeildStyle(),
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                TextFormField(
                                  controller: useremailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle:
                                        AppWidget.semiBoldTextFeildStyle(),
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                TextFormField(
                                  controller: userpasswordcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle:
                                        AppWidget.semiBoldTextFeildStyle(),
                                    prefixIcon:
                                        const Icon(Icons.password_outlined),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPassword()));
                                  },
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "Forgot Password?",
                                        style:
                                            AppWidget.semiBoldTextFeildStyle(),
                                      )),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        email = useremailcontroller.text;
                                        password = userpasswordcontroller.text;
                                      });
                                      userLogin();
                                    }
                                  },
                                  child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      width: 200,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromARGB(255, 255, 220, 23),
                                            Color.fromARGB(255, 222, 247, 85),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                          child: Text(
                                        "LOGIN",
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 2, 2, 2),
                                            fontSize: 18.0,
                                            fontFamily: 'Poppins1',
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()));
                          },
                          child: Text(
                            "Don't have an account? Sign up",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
