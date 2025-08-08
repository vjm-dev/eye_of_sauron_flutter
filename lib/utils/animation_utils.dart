import 'dart:async';
import 'dart:math';

class AnimationUtils {
  static Timer createAnimationTimer(void Function() callback) {
    const frameDuration = Duration(milliseconds: 16);
    return Timer.periodic(frameDuration, (_) => callback());
  }

  static double Function(double) generateNoise(Random random) {
    return (double range) => random.nextDouble() * range - range / 2;
  }

  static Timer scheduleBlink(void Function() blinkCallback, Random random) {
    return Timer(
      Duration(milliseconds: 5500 + random.nextInt(3500)),
      blinkCallback,
    );
  }
}