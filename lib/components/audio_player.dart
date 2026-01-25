import 'package:audioplayers/audioplayers.dart';
import 'package:daily_app/models/track.dart';

class GlobalAudioPlayer {
  static Track? currentTrack;
  static final player = AudioPlayer();

  static Future<bool> play(Track track) async {
    if (track.audioFileName == null) return false;
    await player.play(DeviceFileSource(track.audioFileName!));
    currentTrack = track;
    return true;
  }

  static Future<void> resume() async {
    await player.resume();
  }

  static Future<void> stop() async {
    currentTrack = null;
    await player.stop();
  }

  static Future<void> seek(int millis) async {
    await player.seek(Duration(milliseconds: millis));
  }
}
