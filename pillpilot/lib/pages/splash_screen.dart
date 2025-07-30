import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  
  late Animation<Color?> _backgroundColor;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textOpacity;
  late Animation<double> _fadeOpacity;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Define animations
    _backgroundColor = ColorTween(
      begin: Colors.white,
      end: AppTheme.primaryColor,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _logoScale = Tween<double>(
      begin: 1.0, // Start from normal size (matching launch screen)
      end: 1.2,   // Slightly larger for animation
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoRotation = Tween<double>(
      begin: 0.0,
      end: 1.0, // 1.0 = 360 Grad (eine vollständige Umdrehung)
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _fadeOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _pulseScale = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Start background transition first (seamless from launch screen)
    _backgroundController.forward();
    
    // Start logo animation after a short delay
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    
    // Start pulse animation after logo appears
    await Future.delayed(const Duration(milliseconds: 800));
    _pulseController.repeat(reverse: true);
    
    // Start text animation after background transition
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
    
    // Wait for animations to complete, then fade out and navigate
    await Future.delayed(const Duration(milliseconds: 1800));
    _fadeController.forward();
    
    // Navigate to main app
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      AppRouter.instance.goToHome();
    }
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColor.value,
          body: FadeTransition(
            opacity: _fadeOpacity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _backgroundColor.value ?? Colors.white,
                    (_backgroundColor.value ?? Colors.white).withOpacity(0.9),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated App Icon with seamless transition
                    AnimatedBuilder(
                      animation: Listenable.merge([_logoController, _pulseController]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value * _pulseScale.value,
                          child: Transform.rotate(
                            angle: _logoRotation.value * 2 * 3.14159,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'android/app/src/main/res/drawable/app_icon.png',
                                  width: 124,
                                  height: 124,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback to medication icon if app icon fails to load
                                    return Container(
                                      width: 124,
                                      height: 124,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        borderRadius: BorderRadius.circular(27),
                                      ),
                                      child: const Icon(
                                        Icons.medication,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Animated App Name
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: const Column(
                            children: [
                              Text(
                                'PillPilot',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2.5,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Ihre Medikamentenverwaltung',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 80),
                    
                    // Loading indicator with fade in
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 