import 'package:flutter/material.dart';
import 'package:eye_of_sauron_flutter/models/eye_particle.dart';

class EyePainter extends CustomPainter {
  final List<EyeParticle> particles;

  EyePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final progress = (particle.radius - particle.minRadius) / 
                     (particle.maxRadius - particle.minRadius) * 100;
      
      final green = _getGreen(progress);
      final opacity = progress > 70 ? 1.0 - (progress - 70) / 30 : 1.0;
      
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(particle.x, particle.y),
          width: 1,
          height: 1,
        ),
        Paint()..color = Color.fromRGBO(255, green, 0, opacity),
      );
    }
    
    canvas.restore();
  }

  int _getGreen(double progress) {
    if (progress < 5) return _interpolate(255, 180, 0, 2, progress);
    if (progress < 10) return _interpolate(180, 100, 2, 5, progress);
    if (progress < 40) return _interpolate(100, 0, 5, 30, progress);
    if (progress < 70) return _interpolate(0, 100, 30, 70, progress);
    if (progress < 75) return _interpolate(100, 180, 70, 80, progress);
    return _interpolate(180, 255, 80, 100, progress);
  }

  int _interpolate(int a, int b, double from, double to, double value) {
    final t = (value - from) / (to - from);
    return (a + t * (b - a)).round();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}