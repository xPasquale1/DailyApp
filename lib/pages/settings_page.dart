import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final List<DropdownMenuEntry<String>> currencies = [
    DropdownMenuEntry(value: "de_DE", label: "de_DE"),
    DropdownMenuEntry(value: "en_US", label: "en_US"),
    DropdownMenuEntry(value: "en_UK", label: "en_UK"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade900,
        ),
        child: Expanded(
          child: DropdownMenu<String>(
            label: Text(
              'Currency',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            width: double.infinity,
            dropdownMenuEntries: currencies,
            initialSelection: currencies.first.value,
          ),
        ),
      ),
    );
  }
}
