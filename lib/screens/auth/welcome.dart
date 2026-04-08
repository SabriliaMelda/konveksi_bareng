import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class WelcomeApp extends StatelessWidget {
  const WelcomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ).copyWith(textTheme: ThemeData(fontFamily: 'Poppins').textTheme),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<String> _sliderImages = [
    'assets/images/baju.png',
    'assets/images/logo.png',
    'assets/images/baju.png',
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final nextPage = (_currentPage + 1) % _sliderImages.length;
      setState(() => _currentPage = nextPage);
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.white,
        child: Stack(
          children: [
            // Image slider
            Positioned(
              top: screenHeight * 0.10,
              left: 0,
              right: 0,
              child: SizedBox(
                height: screenHeight * 0.52,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _sliderImages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (_, index) {
                    return Center(
                      child: Image.asset(
                        _sliderImages[index],
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Dot indicators
            Positioned(
              top: screenHeight * 0.65,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _sliderImages.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _Dot(isActive: _currentPage == index),
                  ),
                ),
              ),
            ),

            // Login button
            Positioned(
              left: 22,
              bottom: screenHeight * 0.22,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: Container(
                  width: screenWidth - 44,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B257F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Register button
            Positioned(
              left: 22,
              bottom: screenHeight * 0.12,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: Container(
                  width: screenWidth - 44,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF6B257F),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Color(0xFF1E232C),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Continue as guest
            Positioned(
              left: 0,
              right: 0,
              bottom: screenHeight * 0.03,
              child: const Center(
                child: Text(
                  'Continue as a guest',
                  style: TextStyle(
                    color: Color(0xFF6B257F),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 16 : 8,
      height: 8,
      decoration: ShapeDecoration(
        color: isActive
            ? const Color(0xFF6B257F)
            : const Color(0xFFD4DBE1),
        shape: const OvalBorder(),
      ),
    );
  }
}
