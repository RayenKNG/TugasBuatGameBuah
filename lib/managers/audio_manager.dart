import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  // Jebakan Singleton diperbaiki
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  final double _musicVolume = 0.7;
  final double _sfxVolume = 1.0;

  Future<void> initialize() async {
    try {
      await FlameAudio.audioCache.loadAll([
        'music/background_music.mp3',
        'sfx/collect.mp3',
        'sfx/explosion.mp3',
        'sfx/jump.mp3',
      ]);
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  void playBackgroundMusic() {
    if (_isMusicEnabled) {
      FlameAudio.bgm.play('music/background_music.mp3', volume: _musicVolume);
    }
  }

  void pauseBackgroundMusic() => FlameAudio.bgm.pause();
  void resumeBackgroundMusic() {
    if (_isMusicEnabled) FlameAudio.bgm.resume();
  }

  void playSfx(String fileName) {
    if (_isSfxEnabled) {
      FlameAudio.play('sfx/$fileName', volume: _sfxVolume);
    }
  }

  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    _isMusicEnabled ? resumeBackgroundMusic() : pauseBackgroundMusic();
  }

  void toggleSfx() {
    _isSfxEnabled = !_isSfxEnabled;
  }
}
