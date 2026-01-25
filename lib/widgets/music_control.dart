import 'package:daily_app/components/audio_player.dart';
import 'package:daily_app/components/text_scroller.dart';
import 'package:flutter/material.dart';

class MusicControl extends StatefulWidget {
  const MusicControl({super.key});

  @override
  State<MusicControl> createState() => _MusicControlState();
}

class _MusicControlState extends State<MusicControl> {
  void onPlayPressed() async {
    if (GlobalAudioPlayer.isPlaying) {
      await GlobalAudioPlayer.pause();
    } else {
      await GlobalAudioPlayer.resume();
    }
    setState(() {});
  }

  void onSkipNextPressed(){
    // GlobalAudioPlayer.resume();
  }

  void onSkipPreviousPressed(){
    // GlobalAudioPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black)],
      ),
      child: Row(
        children: [
          const Icon(Icons.music_note),
          const Padding(padding: EdgeInsetsGeometry.only(left: 16)),
          Expanded(
            child: TextScroller(text: GlobalAudioPlayer.getCurrentTrack()?.title ?? '<No Track playing>', style: const TextStyle(fontSize: 18)),
          ),
          IconButton(
            onPressed: onSkipPreviousPressed,
            icon: const Icon(Icons.skip_previous_rounded),
          ),
          IconButton(
            onPressed: onPlayPressed,
            icon: Icon(GlobalAudioPlayer.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
          ),
          IconButton(
            onPressed: onSkipNextPressed,
            icon: const Icon(Icons.skip_next_rounded),
          ),
        ],
      ),
    );
  }
}
