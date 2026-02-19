import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gamebuah/managers/audio_manager.dart';

class FruitCatcherGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Sky blue

  // Jebakan PDF diperbaiki di sini
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Memutar background music saat game load
    AudioManager().playBackgroundMusic();
  }

  // Fungsi ini wajib ditambahkan agar buah bisa menambah skor
  void incrementScore() {
    scoreNotifier.value++;
    AudioManager().playSfx(
      'collect.mp3',
    ); // Opsional: bunyi saat dapat skoraudio_manager.dart
  }
}
