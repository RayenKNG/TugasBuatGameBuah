import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart'; // Penting untuk deteksi sentuhan jari (PanDetector)
import 'package:flutter/material.dart';
import '../managers/audio_manager.dart';
import 'components/basket.dart';
import 'components/fruit.dart';

// Tambahkan HasCollisionDetection agar keranjang bisa menangkap buah
// Tambahkan PanDetector agar layar bisa di-swipe untuk gerakin keranjang
class FruitCatcherGame extends FlameGame
    with HasCollisionDetection, PanDetector {
  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

  late Basket basket; // Deklarasi keranjang
  late Timer fruitSpawner; // Deklarasi timer untuk memunculkan buah otomatis

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    AudioManager().playBackgroundMusic();

    // 1. Masukkan keranjang ke dalam game
    basket = Basket();
    add(basket);

    // 2. Buat mekanisme pemunculan buah (spawn) setiap 1.5 detik
    fruitSpawner = Timer(1.5, onTick: _spawnFruit, repeat: true);
    fruitSpawner.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Timer harus selalu di-update setiap frame agar waktunya jalan
    fruitSpawner.update(dt);
  }

  // Fungsi untuk memunculkan buah dari atas langit
  void _spawnFruit() {
    // Cari titik X secara acak agar buah jatuhnya nyebar (tidak di situ-situ aja)
    final randomX = Random().nextDouble() * (size.x - 40) + 20;

    // Munculkan buah sedikit di atas batas layar (-50)
    final fruit = Fruit(position: Vector2(randomX, -50));
    add(fruit);
  }

  // 3. Fungsi bawaan PanDetector untuk menggeser keranjang dengan jari
  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Geser sumbu X keranjang sesuai dengan geseran jari di layar
    basket.position.x += info.delta.global.x;

    // Cegah keranjang keluar dari batas kiri dan kanan layar
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
