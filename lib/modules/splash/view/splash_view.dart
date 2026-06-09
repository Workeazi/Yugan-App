import 'dart:async';
import 'dart:math' as math;

import 'package:kartly_e_commerce/core/constants/app_assets.dart';
import 'package:kartly_e_commerce/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kartly_e_commerce/core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _flipAnimation; // Added 3D flip

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _continuousController;

  // Add random offsets for premium floating particles
  final List<Offset> _particles = List.generate(20, (index) => Offset(math.Random().nextDouble(), math.Random().nextDouble()));
  final List<double> _particleSpeeds = List.generate(20, (index) => 0.2 + math.Random().nextDouble() * 0.8);
  final List<double> _particleSizes = List.generate(20, (index) => 2.0 + math.Random().nextDouble() * 4.0);

  @override
  void initState() {
    super.initState();

    // Main entrance animation
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200), // Slightly longer for premium feel
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _flipAnimation = Tween<double>(begin: math.pi / 1.5, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Continuous pulse/glow animation for the background
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Continuous controller for rings, particles, and background gradient shift
    _continuousController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _mainController.forward();

    // Keep the exact same logic for navigation
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Get.offNamed(AppRoutes.bottomNavbarView);
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _continuousController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 0. Animated Premium Background Gradient
          _buildAnimatedBackground(),

          // 1. Floating Particles
          _buildParticles(),

          // 2. Pulsating Background Glow
          _buildBackgroundGlow(),

          // 3. Rotating Aesthetic Rings with stagger entrance
          _buildRotatingRings(),

          // 4. Logo with Fade, Slide, Flip, and Elastic Scale
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_mainController, _pulseController]),
              builder: (context, child) {
                // 3D Flip Transform
                final transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(_flipAnimation.value)
                  ..scale(_scaleAnimation.value * _pulseAnimation.value);

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: transform,
                      child: child,
                    ),
                  ),
                );
              },
              child: _buildLogo(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _continuousController,
      builder: (context, child) {
        final value = _continuousController.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(math.cos(value * 2 * math.pi), math.sin(value * 2 * math.pi)),
              end: Alignment(-math.cos(value * 2 * math.pi), -math.sin(value * 2 * math.pi)),
              colors: const [
                Color(0xFF800080), // Slightly darker purple
                Color(0xFF97009A), // Main matching purple
                Color(0xFFA500A8), // Slightly lighter purple
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _continuousController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(
            progress: _continuousController.value,
            particles: _particles,
            speeds: _particleSpeeds,
            sizes: _particleSizes,
          ),
        );
      },
    );
  }

  Widget _buildBackgroundGlow() {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainController, _pulseController]),
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            width: 280 * _pulseAnimation.value,
            height: 280 * _pulseAnimation.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15),
                  blurRadius: 80,
                  spreadRadius: 30 * _pulseAnimation.value,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.05),
                  blurRadius: 150,
                  spreadRadius: 60 * _pulseAnimation.value,
                ),
                // Extra inner intense glow
                BoxShadow(
                  color: Colors.pinkAccent.withValues(alpha: 0.2),
                  blurRadius: 50,
                  spreadRadius: 10 * _pulseAnimation.value,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRotatingRings() {
    return AnimatedBuilder(
      animation: Listenable.merge([_continuousController, _mainController]),
      builder: (context, child) {
        return Opacity(
          // Fade in rings slightly after the logo
          opacity: Curves.easeIn.transform(
              math.max(0.0, (_mainController.value - 0.3) / 0.7)),
          child: Transform.scale(
            scale: Curves.easeOutBack.transform(
                math.max(0.0, (_mainController.value - 0.2) / 0.8)),
            child: Transform.rotate(
              angle: _continuousController.value * 2 * math.pi,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                      gradient: SweepGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.4),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Middle ring (rotating opposite)
                  Transform.rotate(
                    angle: -_continuousController.value * 4 * math.pi,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                        gradient: SweepGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.3),
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: 0.3),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Inner dashed/dotted ring
                  Transform.rotate(
                    angle: _continuousController.value * 6 * math.pi,
                    child: CustomPaint(
                      size: const Size(190, 190),
                      painter: _DashedRingPainter(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          // Deep shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          // Glow shadow
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
        // Subtle border to make it pop
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          AppAssets.appLogo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final List<Offset> particles;
  final List<double> speeds;
  final List<double> sizes;

  _ParticlePainter({
    required this.progress,
    required this.particles,
    required this.speeds,
    required this.sizes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.15);

    for (int i = 0; i < particles.length; i++) {
      // Particles move upwards
      double yPos = particles[i].dy - (progress * speeds[i]);
      // Wrap around
      yPos = yPos - yPos.floor();

      // Slight horizontal drift
      double xPos = particles[i].dx + math.sin(progress * math.pi * 4 + i) * 0.02;
      // Wrap around
      xPos = xPos - xPos.floor();

      canvas.drawCircle(
        Offset(xPos * size.width, yPos * size.height),
        sizes[i],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _DashedRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const int dashCount = 40;
    const double dashLength = (math.pi * 2) / (dashCount * 2);

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * 2 * dashLength;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
