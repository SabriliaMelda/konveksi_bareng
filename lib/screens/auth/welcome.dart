import 'dart:async';
import 'package:flutter/material.dart';
import 'package:konveksi_bareng/config/app_colors.dart';
import 'package:go_router/go_router.dart';

class WelcomeApp extends StatelessWidget {
  const WelcomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark()
          .copyWith(
            scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
          )
          .copyWith(textTheme: ThemeData(fontFamily: 'Poppins').textTheme),
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Theme.of(context).appColors.card,
        child: Column(
          children: [
            // Image slider — takes up available space
            Expanded(
              child: Stack(
                children: [
                  // Image slider
                  Positioned.fill(
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

                  // Dot indicators
                  Positioned(
                    bottom: 16,
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
                ],
              ),
            ),

            // Buttons section — fixed at bottom
            Padding(
              padding: EdgeInsets.fromLTRB(22, 16, 22, 0),
              child: GestureDetector(
                onTap: () => context.push('/login'),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color(0xFF6B257F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Theme.of(context).appColors.card,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: GestureDetector(
                onTap: () => context.push('/register'),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(0xFF6B257F),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Theme.of(context).appColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Continue as a guest',
              style: TextStyle(
                color: Color(0xFF6B257F),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 24),
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
        color: isActive ? const Color(0xFF6B257F) : const Color(0xFFD4DBE1),
        shape: const OvalBorder(),
      ),
    );
  }
}
