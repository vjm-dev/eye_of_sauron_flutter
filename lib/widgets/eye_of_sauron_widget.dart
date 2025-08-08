import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:eye_of_sauron_flutter/models/eye_particle.dart';
import 'package:eye_of_sauron_flutter/widgets/eye_painter.dart';

// Public state class for testing
class EyeOfSauronWidgetState extends State<EyeOfSauronWidget> {
  final List<EyeParticle> _particles = [];
  final Random _random = Random();
  Timer? _blinkTimer;
  Timer? _particleTimer;
  double _eyeHeight = 300;
  bool _isBlinking = false;

  static const particlesPerFrame = 30;
  static const pupil = Size(9, 46);
  static const eye = Size(200, 125);
  static const double speed = 40.0;

  // Public accessors for testing
  Timer? get blinkTimer => _blinkTimer;
  Timer? get particleTimer => _particleTimer;
  void triggerBlink() => _blink();

  @override
  void initState() {
    super.initState();
    _startParticleAnimation();
    _scheduleBlink();
  }

  void _startParticleAnimation() {
    const frameDuration = Duration(milliseconds: 16);
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
        
        // Add current position to history
        particle.addPositionToHistory();
        
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
      _eyeHeight = 1;
    });
    
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        _eyeHeight = 300;
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
    return AnimatedContainer(
      key: const ValueKey('eye-container'),
      duration: const Duration(milliseconds: 100),
      width: 500,
      height: _eyeHeight,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0x00000000),
      ),
      child: CustomPaint(
        painter: EyePainter(particles: _particles),
      ),
    );
  }
}

class EyeOfSauronWidget extends StatefulWidget {
  const EyeOfSauronWidget({super.key});

  @override
  EyeOfSauronWidgetState createState() => EyeOfSauronWidgetState();
}