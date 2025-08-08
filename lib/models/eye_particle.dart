import 'dart:math';

class EyeParticle {
  double x;
  double y;
  final double dx;
  final double dy;
  final double minRadius;
  final double maxRadius;
  
  // Trail history (stores positions with timestamps)
  final List<Map<String, dynamic>> positionHistory = [];
  static const int maxHistoryLength = 7; // Keep last 10 positions

  EyeParticle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.minRadius,
    required this.maxRadius,
  });

  void addPositionToHistory() {
    positionHistory.add({
      'x': x,
      'y': y,
      'timestamp': DateTime.now(),
    });
    
    // Maintain history length
    if (positionHistory.length > maxHistoryLength) {
      positionHistory.removeAt(0);
    }
  }

  double get radius => sqrt(x * x + y * y);
}