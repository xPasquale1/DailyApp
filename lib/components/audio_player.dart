import 'package:audioplayers/audioplayers.dart';
import 'package:daily_app/models/track.dart';

class GlobalAudioPlayer {
  static bool isActive = false;
  static final player = AudioPlayer();
  static bool isPlaying = false;
  static int currentPlaylistIndex = 0;
  static List<Track> currentPlaylist = [];

  static Future<bool> play() async {
    if (currentPlaylistIndex >= currentPlaylist.length) return false;
    Track track = currentPlaylist[currentPlaylistIndex];
    if (track.audioFileName == null) return false;
    await player.play(DeviceFileSource(track.audioFileName!));
    isPlaying = true;
    isActive = true;
    return true;
  }

  static Future<void> pause() async {
    await player.pause();
    isPlaying = false;
  }

  static Future<void> resume() async {
    await player.resume();
    isPlaying = true;
  }

  static Future<void> stop() async {
    await player.stop();
    isPlaying = false;
    isActive = false;
  }

  static Future<void> seek(int millis) async {
    await player.seek(Duration(milliseconds: millis));
  }

  static Future<void> skipNext() async {
    if(currentPlaylist.isEmpty) return;
    currentPlaylistIndex = (currentPlaylistIndex + 1) % currentPlaylist.length;
    await play();
  }

  static void addTrackToPlaylist(Track track){
    currentPlaylist.add(track);
  }

  static void removeTrackFromPlaylist(Track track){
    currentPlaylist.remove(track);
  }

  static void clearPlaylist(){
    currentPlaylist.clear();
  }

  static Track? getCurrentTrack(){
    if(currentPlaylistIndex >= currentPlaylist.length) return null;
    return currentPlaylist[currentPlaylistIndex];
  }
}
