import 'package:daily_app/components/audio_player.dart';
import 'package:daily_app/components/text_scroller.dart';
import 'package:flutter/material.dart';

class MusicControl extends StatefulWidget {
  const MusicControl({super.key});

  @override
  State<MusicControl> createState() => _MusicControlState();
}

class _MusicControlState extends State<MusicControl> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(16),
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
            child: TextScroller(text: GlobalAudioPlayer.currentTrack?.title ?? '<No Track playing>', style: TextStyle(fontSize: 20)),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.skip_previous_rounded),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.play_arrow_rounded),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.skip_next_rounded),
          ),
        ],
      ),
    );
  }
}
