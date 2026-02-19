import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../managers/audio_manager.dart';
import 'components/basket.dart';
import 'components/fruit.dart';

class FruitCatcherGame extends FlameGame
    with HasCollisionDetection, PanDetector {
  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

  late Basket basket;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    AudioManager().playBackgroundMusic();

    // 1. Munculkan keranjang
    basket = Basket();
    add(basket);

    // 2. Mekanisme Spawn Buah pakai TimerComponent (Lebih stabil!)
    add(
      TimerComponent(
        period: 1.5, // Waktu tunggu antar buah (1.5 detik)
        repeat: true,
        onTick: () {
          // Cari titik X acak untuk posisi jatuh buah
          final randomX = Random().nextDouble() * (size.x - 40) + 20;

          // Lempar buahnya ke dalam layar!
          add(Fruit(position: Vector2(randomX, -50)));
        },
      ),
    );
  }

  // 3. Logic geser keranjang
  @override
  void onPanUpdate(DragUpdateInfo info) {
    basket.position.x += info.delta.global.x;

    if (basket.position.x < basket.size.x / 2) {
      basket.position.x = basket.size.x / 2;
    } else if (basket.position.x > size.x - (basket.size.x / 2)) {
      basket.position.x = size.x - (basket.size.x / 2);
    }
  }

  void incrementScore() {
    scoreNotifier.value++;
    AudioManager().playSfx('collect.mp3');
  }
}
