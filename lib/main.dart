import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: EyeOfSauron(),
      debugShowCheckedModeBanner: kDebugMode
    )
  );
}

class EyeOfSauron extends StatefulWidget {
  const EyeOfSauron({super.key});

  @override
  State<EyeOfSauron> createState() => _EyeOfSauronState();
}

class _EyeOfSauronState extends State<EyeOfSauron> {
  final List<EyeParticle> _particles = [];
  final Random _random = Random();
  Timer? _blinkTimer;
  Timer? _particleTimer;
  double _eyeHeight = 300;
  bool _isBlinking = false;

  static const particlesPerFrame = 95;
  static const pupil = Size(9, 46);
  static const eye = Size(200, 125);
  static const double speed = 60.0;

  @override
  void initState() {
    super.initState();
    _startParticleAnimation();
    _scheduleBlink();
  }

  void _startParticleAnimation() {
    const frameDuration = Duration(milliseconds: 16); // ~60 FPS
    _particleTimer = Timer.periodic(frameDuration, (timer) {
      if (!_isBlinking) {
        _addParticles();
      }
      _updateParticles();
    });
  }

  void _updateParticles() {
    setState(() {
      _particles.removeWhere((particle) {
        particle.x += particle.dx;
        particle.y += particle.dy;
        return particle.radius > particle.maxRadius;
      });
    });
  }

  void _addParticles() {
    for (int i = 0; i < particlesPerFrame; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final startX = pupil.width * cos(angle) + _noise(5);
      final startY = pupil.height * sin(angle) + _noise(5);
      final endX = eye.width * cos(angle) + _noise(25);
      final endY = eye.height * sin(angle) + _noise(25);
      
      _particles.add(EyeParticle(
        x: startX,
        y: startY,
        dx: (endX - startX) / speed,
        dy: (endY - startY) / speed,
        minRadius: sqrt(startX * startX + startY * startY),
        maxRadius: sqrt(endX * endX + endY * endY),
      ));
    }
  }

  double _noise(double range) => _random.nextDouble() * range - range / 2;

  void _scheduleBlink() {
    _blinkTimer?.cancel();
    _blinkTimer = Timer(
      Duration(milliseconds: 5500 + _random.nextInt(3500)),
      () {
        _blink();
      },
    );
  }

  void _blink() {
    setState(() {
      _isBlinking = true;
      _eyeHeight = 1; // Completely crush the eye
    });
    
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        _eyeHeight = 300; // Restore original height
        _isBlinking = false;
      });
      _scheduleBlink();
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _particleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container that acts as the eye (the box that is crushed)
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 500,
              height: _eyeHeight,
              clipBehavior: Clip.hardEdge, // Important for trimming particles
              decoration: BoxDecoration(
                color: const Color(0x06000000),
              ),
              child: CustomPaint(
                painter: EyePainter(particles: _particles),
              ),
            ),
            const SizedBox(height: 20),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "Idea by "),
                  TextSpan(
                    text: "TheBaconFromHell",
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: "\nImplementation "),
                  TextSpan(
                    text: "OdiliTime",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class EyePainter extends CustomPainter {
  final List<EyeParticle> particles;

  EyePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    // Center coordinate system
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    // Draw particles
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