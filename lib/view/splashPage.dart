import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kagi_project/view/homePage.dart';
import 'package:kagi_project/view/biometric_auth_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Navigate to biometric auth screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BiometricAuthScreen(
            onSuccess: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            onSkip: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
             const Color.fromARGB(255, 191, 224, 228),
                          const Color.fromARGB(255, 186, 215, 215).withOpacity(0.8),
            const Color.fromARGB(255, 241, 165, 1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated logo container
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Container(
                    height: 15.h,
                    width: 15.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 241, 165, 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'K',
                        style: GoogleFonts.poppins(
                          fontSize: Adaptive.sp(32),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              // Animated text
              FadeTransition(
                opacity: _opacityAnimation,
                child: Column(
                  children: [
                    Text(
                      'Kagi\'s Kite',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'News App',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              // Animated progress indicator
              FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  width: 30.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}