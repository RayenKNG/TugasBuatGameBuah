import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'managers/audio_manager.dart';
import 'game/fruit_catcher_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioManager().initialize(); // Inisialisasi audio sebelum app jalan
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Fruit Catcher Game', home: GameScreen());
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FruitCatcherGame game;

  @override
  void initState() {
    super.initState();
    game = FruitCatcherGame(); // Inisialisasi game
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Layer 1: Game Engine
          GameWidget(game: game),

          // Layer 2: Score di kiri atas
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ValueListenableBuilder<int>(
                valueListenable:
                    game.scoreNotifier, // Dengarkan perubahan skor dari game
                builder: (context, score, child) {
                  return Text(
                    'Score: $score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),

          // Layer 3: Audio Controls di kanan atas
          Positioned(
            top: 50,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.music_note, color: Colors.black),
                  onPressed: () => AudioManager().toggleMusic(),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.black),
                  onPressed: () => AudioManager().toggleSfx(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
