import 'dart:io';

import 'package:daily_app/models/track.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TrackWidget extends StatefulWidget {
  final Track track;
  final Function(Track) onPress;

  const TrackWidget({super.key, required this.track, required this.onPress});

  @override
  State<StatefulWidget> createState() {
    return _TrackWidgetState();
  }
}

class _TrackWidgetState extends State<TrackWidget> {
  final thumbnailsPath = getApplicationDocumentsDirectory();

  void onPress() {
    widget.onPress(widget.track);
  }

  @override
  Widget build(Object context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            widget.track.thumbnailFileName != null
                ? Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(16),
                      child: Image.file(
                        File(
                          '$thumbnailsPath/${widget.track.thumbnailFileName}',
                        ),
                        height: 60,
                        width: 60,
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.filter),
                    ),
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.track.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Interpret: ${widget.track.interpret ?? '<Unbekannt>'}'),
                  Text('Album: ${widget.track.album ?? '<Unbekannt>'}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
