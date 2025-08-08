import 'dart:math';

class EyeParticle {
  double x;
  double y;
  final double dx;
  final double dy;
  final double minRadius;
  final double maxRadius;

  EyeParticle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.minRadius,
    required this.maxRadius,
  });

  double get radius => sqrt(x * x + y * y);
}