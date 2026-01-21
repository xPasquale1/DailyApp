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
    FinancialsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.fact_check), label: 'Tasks'),
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
