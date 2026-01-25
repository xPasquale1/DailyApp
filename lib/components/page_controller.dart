import 'package:daily_app/components/audio_player.dart';
import 'package:daily_app/pages/music_page.dart';
import 'package:daily_app/widgets/music_control.dart';
import 'package:flutter/material.dart';
import 'package:daily_app/pages/financials_page.dart';
import 'package:daily_app/pages/home_page.dart';
import 'package:daily_app/pages/settings_page.dart';
import 'package:daily_app/pages/tasks_page.dart';

class PagesController extends StatefulWidget {
  const PagesController({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PagesController();
  }
}

class _PagesController extends State<PagesController> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    TasksPage(),
    MusicPage(),
    FinancialsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          if(GlobalAudioPlayer.isActive) Positioned(bottom: 16, left: 16, right: 16, child: MusicControl()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.fact_check), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.queue_music), label: 'Music'),
          NavigationDestination(
            icon: Icon(Icons.account_balance),
            label: 'Financials',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
