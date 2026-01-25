import 'package:daily_app/models/track.dart';
import 'package:daily_app/widgets/track_widget.dart';
import 'package:flutter/material.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final List<Track> tracks = [
    Track(title: 'Test'),
    Track(title: 'Test 2'),
    Track(title: 'Test 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Music',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return TrackWidget(track: tracks[index], onPress: (task) => null);
        },
      ),
    );
  }
}
