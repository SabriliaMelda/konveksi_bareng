import 'dart:async';
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/features/auth/pages/login.dart';
import 'package:konveksi_bareng/features/auth/pages/register.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const Welcome(),
    );
  }
}

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // ====== LIST GAMBAR SLIDER ATAS ======
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

    // ===== AUTO SLIDE SETIAP 1 DETIK =====
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      int nextPage;

      if (_currentPage < _sliderImages.length - 1) {
        nextPage = _currentPage + 1;
      } else {
        nextPage = 0; // balik ke halaman pertama
      }

      setState(() {
        _currentPage = nextPage;
      });

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
            // ===== TOP IMAGE SLIDER =====
            Positioned(
              top: screenHeight * 0.10,
              left: 0,
              right: 0,
              child: SizedBox(
                height: screenHeight * 0.52,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _sliderImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    print('Halaman slider: ${index + 1}');
                  },
                  itemBuilder: (context, index) {
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

            // ===== DOT INDICATOR UNGU =====
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
                    child: Dot(isActive: _currentPage == index),
                  ),
                ),
              ),
            ),

            // ===== LOGIN BUTTON =====
            Positioned(
              left: 22,
              bottom: screenHeight * 0.22,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
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
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // ===== REGISTER BUTTON =====
            Positioned(
              left: 22,
              bottom: screenHeight * 0.12,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(), // <-- KE REGISTER
                    ),
                  );
                },
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
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // ===== CONTINUE AS GUEST =====
            Positioned(
              left: screenWidth * 0.32,
              bottom: screenHeight * 0.03,
              child: const Text(
                'Continue as a guest',
                style: TextStyle(
                  color: Color(0xFF6B257F),
                  fontSize: 15,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final bool isActive;

  const Dot({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 16 : 8,
      height: 8,
      decoration: ShapeDecoration(
        color: isActive
            ? const Color(0xFF6B257F) // ungu kalau aktif
            : const Color(0xFFD4DBE1), // abu kalau non-aktif
        shape: const OvalBorder(),
      ),
    );
  }
}
