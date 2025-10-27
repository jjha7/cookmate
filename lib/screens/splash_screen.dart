import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Lottie.asset('assets/animations/healthy_food.json', width: 220, height: 220),
          const SizedBox(height: 8),
          Text("CookMate", style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text("Recipes • Planner • Groceries"),
        ]),
      ),
    );
  }
}
