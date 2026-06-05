import 'package:flutter/material.dart';

class MockPdpRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  MockPdpRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          opaque: false, // Ensures home screen is visible behind
          barrierColor: Colors.black54, // The dark dimming background
          barrierDismissible: true,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var slideTween = Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOutCubic));

            var slideAnimation = animation.drive(slideTween);

            return SlideTransition(
              position: slideAnimation,
              child: child,
            );
          },
        );
}
