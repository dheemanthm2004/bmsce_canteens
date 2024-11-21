import 'package:flutter/material.dart';
import 'package:bmsce_canteens/pages/signup.dart';
import 'package:bmsce_canteens/widget/content_model.dart';
import 'package:bmsce_canteens/widget/widget_support.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8, // Adjust height as needed
              child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            contents[i].image,
                            height: 300, // Adjust height as needed
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Text(
                            contents[i].title,
                            style: AppWidget.HeadlineTextFeildStyle(),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            contents[i].description,
                            style: AppWidget.LightTextFeildStyle(),
                          )
                        ],
                      ),
                    );
                  }
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                      (index) => buildDot(index, context),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp())
                  );
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn,
                  );
                }
              },
              child: Container(
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
                height: 60,
                margin: const EdgeInsets.all(40),
                width: double.infinity,
                child: Center(
                  child: Text(
                    currentIndex == contents.length - 1 ? "Start" : "Next",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.black38
      ),
    );
  }
}
