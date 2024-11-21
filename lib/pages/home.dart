import 'package:bmsce_canteens/pages/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bmsce_canteens/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, pizza = false, salad = false, burger = false;
  Stream<QuerySnapshot>? fooditemStream;

  void ontheload(String category) async {
    setState(() {
      fooditemStream =
          FirebaseFirestore.instance.collection(category).snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    ontheload('Pizza'); // Initial load with 'Pizza' category //Law-Canteen
  }

  Widget allItemsVertically() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Details(
                              detail: ds["Detail"],
                              name: ds["Name"],
                              price: ds["Price"],
                              image: ds["Image"],
                            )));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  ds["Image"],
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(ds["Name"],
                                  style: AppWidget.semiBoldTextFeildStyle()),
                              const SizedBox(height: 5),
                              Text(
                                ds["Detail"],
                                style: AppWidget.LightTextFeildStyle(),
                                maxLines: 12,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "₹${ds["Price"]}",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              )
                            ]),
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Widget allItems() {
    return StreamBuilder(
      stream: fooditemStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: snapshot.data!.docs.map((doc) {
              DocumentSnapshot ds = doc;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                        detail: ds["Detail"],
                        name: ds["Name"],
                        price: ds["Price"],
                        image: ds["Image"],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 200, // Adjusted width for better display
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              ds["Image"],
                              height: 150, // Adjusted height for consistency
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ds["Name"],
                            style: AppWidget.semiBoldTextFeildStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            ds["Detail"],
                            style: AppWidget.LightTextFeildStyle(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "₹${ds["Price"]}",
                            style: AppWidget.semiBoldTextFeildStyle(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120, // Increase AppBar height
        title: Column(
          children: [
            Text(
              "BMSCE CANTEENS",
              style: AppWidget.boldTextFeildStyle().copyWith(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Avoid queues, save time, enjoy meal😋",
              style: AppWidget.LightTextFeildStyle().copyWith(fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showItem(),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: 270,
                child: allItems(),
              ),
              const SizedBox(
                height: 30.0,
              ),
              allItemsVertically(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    icecream = true;
                    pizza = false;
                    salad = false;
                    burger = false;
                  });
                  ontheload("Vidyarthi-Khaana"); //Vidyarthi-Khaana //Ice-cream
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: icecream
                        ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 167, 193, 228),
                        Color.fromARGB(255, 7, 50, 110)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'images/ice-cream.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    icecream = false;
                    pizza = true;
                    salad = false;
                    burger = false;
                  });
                  ontheload("Pizza");
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: pizza
                        ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 167, 193, 228),
                        Color.fromARGB(255, 7, 50, 110)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'images/pizza.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    icecream = false;
                    pizza = false;
                    salad = true;
                    burger = false;
                  });
                  ontheload("Salad"); //Salad //Library-Canteen
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: salad
                        ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 167, 193, 228),
                        Color.fromARGB(255, 7, 50, 110)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'images/salad.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    icecream = false;
                    pizza = false;
                    salad = false;
                    burger = true;
                  });
                  ontheload("Nescafe-Canteen"); //Burger //Nescafe-Canteen
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: burger
                        ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 167, 193, 228),
                        Color.fromARGB(255, 7, 50, 110)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'images/burger.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
