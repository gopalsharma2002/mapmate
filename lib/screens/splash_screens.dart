import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo container -
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                //  color: Colors.white,



                ),
                child: Image.asset(
                "assets/app_logo.png",
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 8),

              // Tagline -
              Text(
                'Find. Search. Navigate.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF2E8B87),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 60),

              // Loading indicator -
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color:Color(0xFF2E8B87),
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}