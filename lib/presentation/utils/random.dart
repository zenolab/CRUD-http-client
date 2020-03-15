import 'dart:math';
import 'dart:ui';

int random({int range}) {
  Random random = new Random();
  int randomNumber = random.nextInt(100);
  return randomNumber;
}