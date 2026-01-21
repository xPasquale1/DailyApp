import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:daily_app/components/database.dart';
import 'package:daily_app/models/financial.dart';
import 'package:daily_app/models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int openTasksCount = 0;

  final euroFormatter = NumberFormat.simpleCurrency(
    locale: 'de_DE',
    name: 'EUR',
    decimalDigits: 2,
  );

  Future<double> calculateTotal() async {
    List<Financial> financials = await DB.getAllFinancials();
    double total = 0;
    for (Financial financial in financials) {
      total += financial.amount;
    }
    return total;
  }

  Future<int> getOpenTasksCount() async {
    List<Task> tasks = await DB.getAllTasks();
    return tasks.where((task) => !task.completed).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            margin: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade900,
            ),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Open Tasks:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                FutureBuilder(
                  future: getOpenTasksCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        '...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      );
                    }
                    return Text(
                      '${snapshot.data}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(24),
            margin: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade900,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Financials:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                FutureBuilder(
                  future: calculateTotal(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        '...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      );
                    }
                    return Text(
                      snapshot.data! >= 0
                          ? '+${euroFormatter.format(snapshot.data)}'
                          : euroFormatter.format(snapshot.data),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: snapshot.data! >= 0 ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
