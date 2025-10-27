import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("More Recipes")),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Lottie.asset('assets/animations/food_carousel.json', width: 220, height: 220),
          const SizedBox(height: 16),
          const Text("New recipes are baking... 🍰", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text("Stay tuned for weekly drops!", textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
