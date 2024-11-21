import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About the BMSCE Canteen App Development Team',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'We are a dedicated group of Computer Science and Engineering students from BMS College of Engineering, committed to transforming the campus dining experience through innovative technology. Our team has developed the BMSCE Canteen App, designed to streamline food ordering for students and faculty, and the Canteen Admin App, which facilitates efficient management for canteen operators.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Meet the Team:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16),
            DeveloperInfo(
              name: '              Team Lead\nDheemanth M',
              description:
              'Dheemanth specializes in user experience design, focusing on creating a seamless and intuitive interface for our app. His expertise ensures that the application is not only functional but also user-friendly, enhancing the overall experience for both students and canteen staff.',
              imagePath: 'images/dheemanth.jpg',

            ),
            SizedBox(height: 16),
            DeveloperInfo(
              name: '             Assistant\nDhanush C',
              description:
              'As a backend developer, Dhanush is responsible for building and maintaining the robust infrastructure of our app. His proficiency in handling server-side operations guarantees that the app performs reliably and efficiently, meeting the needs of all users.',
              imagePath: 'images/dhanusch.jpg',

            ),
            SizedBox(height: 16),

            DeveloperInfo(
              name: 'Dhanush S',
              description:
              'Dhanush brings strong programming skills to the team, focusing on implementing and optimizing the app’s features. His technical acumen plays a crucial role in ensuring that the application runs smoothly and delivers a high-quality user experience.',
              imagePath: 'images/dhanush.jpg',
            ),
            SizedBox(height: 16),
            DeveloperInfo(
              name: 'Charan G',
              description:
              'Charan serves as the project coordinator and front-end developer. His role involves integrating the app’s various components and ensuring that the project aligns with our vision. Charan’s organizational skills and attention to detail help in delivering a polished and cohesive final product.',
              imagePath: 'images/charan.jpg',
            ),
            SizedBox(height: 24),
            Text(
              'Our goal is to enhance the dining experience at BMSCE by providing a convenient, efficient, and user-friendly platform. We are proud of our work and excited to see how it benefits our campus community. For any inquiries or feedback, please do not hesitate to contact us.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Thank you for your support.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 24),
            Footer(),
          ],
        ),
      ),
    );
  }
}

class DeveloperInfo extends StatelessWidget {
  final String name;
  final String description;
  final String imagePath;

  const DeveloperInfo({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.deepPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Us:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Phone: 9686490654 | 9113879950',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const Text(
            'Address: 4th Floor PJ Block, BMS College of Engineering',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.instagram, color: Colors.white),
                onPressed: () => _launchURL('https://www.instagram.com/dheemanth._m/'),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.twitter, color: Colors.white),
                onPressed: () => _launchURL('https://twitter.com/charan_g_cg'),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.youtube, color: Colors.white),
                onPressed: () => _launchURL('https://www.youtube.com/channel/dhanush.c8264/'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
