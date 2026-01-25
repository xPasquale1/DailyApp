import 'package:flutter/material.dart';

class TextScroller extends StatefulWidget {
  final String text;
  final TextStyle style;

  const TextScroller({super.key, required this.text, required this.style});

  @override
  State<TextScroller> createState() => _TextScrollerState();
}

class _TextScrollerState extends State<TextScroller> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => animate());
    animate();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<void> animate() async {
    if(!scrollController.hasClients) return;
    
    while(mounted){
      await scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(seconds: 2), curve: Curves.linear);
      await Future.delayed(Duration(milliseconds: 500));
      await scrollController.animateTo(0, duration: Duration(seconds: 2), curve: Curves.linear);
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(widget.text, style: widget.style),
    );
  }
}
