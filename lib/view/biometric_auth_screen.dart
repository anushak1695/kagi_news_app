import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/biometric_service.dart';
import '../constants.dart';

class BiometricAuthScreen extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onSkip;

  const BiometricAuthScreen({
    super.key,
    required this.onSuccess,
    required this.onSkip,
  });

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> with SingleTickerProviderStateMixin {
  final BiometricService _biometricService = BiometricService();
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
    _checkBiometricSupport();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final canAuthenticate = await _biometricService.canAuthenticate();
      if (!canAuthenticate) {
        setState(() {
          _errorMessage = 'Biometric authentication is not available on this device';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error checking biometric support: $e';
      });
    }
  }

  Future<void> _authenticate() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _biometricService.authenticate();
      if (success && mounted) {
        widget.onSuccess();
      }
    } on BiometricException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.translate(
              offset: _slideAnimation.value,
              child: Stack(
                children: [
                  // Background gradient
                  Container(
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
                  ),
                  // Content
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Biometric dog image with animation
                            Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Pulsing circles
                                  if (_isLoading) ...[
                                    Container(
                                      height: 250,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                  // Biometric dog image
                                  Container(
                                    height: 200,
                                    width: 200,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/images/biometric_dog.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'Welcome to Kagi\'s Kite',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Please authenticate to continue',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white70,
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            if (_errorMessage != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.red[300],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _authenticate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                      ),
                                    )
                                  : Text(
                                      'Authenticate',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                           
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 