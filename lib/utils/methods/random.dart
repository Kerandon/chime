import 'dart:math';

class RandomClass {
  static Random random = Random();
  static int next(int min, int max) => min + random.nextInt(max - min);
}
