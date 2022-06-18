// ignore_for_file: file_names

import 'package:audioplayers/audioplayers.dart';

class SoundSystem {
  static AudioCache player = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  playLocal() async {
    player.load('10.mp3');
    player.play('10.mp3');
  }
}
