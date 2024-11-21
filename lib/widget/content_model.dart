class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent(
      {required this.description, required this.image, required this.title});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      description: 'Pick your food from our menu\n          ',
      image: "images/screen1.png",
      title: 'Select your desired item \n        ''from our College \n '
          '              Canteens'),
  UnboardingContent(
      description: 'Pay easily with any debit or credit card. \n            Secure online transactions \n                          made simple.',
      image: "images/screen2.png",
      title: 'Easy and Online Payment'),
  UnboardingContent(
      description: 'No more queues \n     for the bills',
      image: "images/screen3.png",
      title: 'Enjoy your favourite\n    Foods & Snacks ')
];
