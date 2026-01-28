import 'package:daily_app/components/currency.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:daily_app/components/database.dart';
import 'package:daily_app/models/financial.dart';
import 'package:daily_app/pages/financial_view_page.dart';
import 'package:daily_app/widgets/financial_widget.dart';

class FinancialsPage extends StatefulWidget {
  const FinancialsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FinancialsPageState();
  }
}

class _FinancialsPageState extends State<FinancialsPage> {
  double total = 0;
  List<Financial> financials = [];

  final List<double> weeklyTotal = [0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    loadFinancials();
  }

  DateTime startOfWeek(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  void calculateWeeklyFinancials(List<Financial> financials) {
    for (int i = 0; i < 7; ++i) {
      weeklyTotal[i] = 0;
    }
    DateTime currentDate = DateTime.now();
    final weekStart = startOfWeek(currentDate);
    for (Financial financial in financials) {
      if (currentDate.isBefore(weekStart)) continue;
      if (financial.date.weekday > currentDate.weekday) continue;
      weeklyTotal[financial.date.weekday - 1] += financial.amount;
    }
  }

  Future<void> loadFinancials() async {
    financials = await DB.getAllFinancials();
    calculateTotal();
    setState(() {});
  }

  void calculateTotal() {
    total = 0;
    for (Financial financial in financials) {
      total += financial.amount;
    }
    calculateWeeklyFinancials(financials);
  }

  void onFinancialPressed(Financial financial) async {
    final shouldDelete = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinancialViewPage(financial: financial),
      ),
    );

    await DB.updateFinancial(financial);
    calculateTotal();
    setState(() {});

    if (shouldDelete == null || !shouldDelete) return;
    await DB.deleteFinancial(financial);
    setState(() {
      financials.remove(financial);
      calculateTotal();
    });
  }

  SideTitleWidget getChartBottomTitles(double value, TitleMeta meta) {
    Text text = const Text('');
    switch (value.toInt()) {
      case 0:
        text = const Text('Mon');
        break;
      case 1:
        text = const Text('Tue');
        break;
      case 2:
        text = const Text('Wed');
        break;
      case 3:
        text = const Text('Thu');
        break;
      case 4:
        text = const Text('Fri');
        break;
      case 5:
        text = const Text('Sat');
        break;
      case 6:
        text = const Text('Sun');
        break;
    }
    return SideTitleWidget(meta: meta, child: text);
  }

  Container getWeekOverviewChart() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.grey.shade900,
      ),
      child: Column(
        children: [
          Text('Weekly Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          SizedBox(
            height: 200,
            child: Container(
              padding: EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          Currency.doubleToString(rod.toY),
                          TextStyle(
                            color: rod.toY >= 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: getChartBottomTitles,
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(weeklyTotal.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: weeklyTotal[index],
                          width: 30,
                          borderRadius: BorderRadius.circular(12),
                          color: weeklyTotal[index] >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addFinancialDialog() async {
    final descriptionInputController = TextEditingController();
    final receiverInputController = TextEditingController();
    final amountInputController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add new Financial'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: descriptionInputController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  controller: amountInputController,
                  decoration: const InputDecoration(hintText: 'Amount'),
                ),
                TextField(
                  controller: receiverInputController,
                  decoration: const InputDecoration(hintText: 'Receiver'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, <String, String>{}),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {
                'description': descriptionInputController.text,
                'amount': amountInputController.text,
                'receiver': receiverInputController.text,
              }),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
    if (result == null) return;
    if (!result.containsKey('amount')) return;
    double amount = Currency.stringToDouble(result['amount'] as String);
    String description = result.containsKey('description')
        ? result['description'] as String
        : '';
    String receiver = result.containsKey('receiver')
        ? result['receiver'] as String
        : '';
    Financial? financial = await DB.addFinancial(amount, receiver, description);
    if (financial == null) return;
    setState(() {
      financials.add(financial);
      calculateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Financials',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              total >= 0
                  ? '+${Currency.doubleToString(total)}'
                  : Currency.doubleToString(total),
              style: TextStyle(
                color: total >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
          // getWeekOverviewChart(),
          Expanded(
            child: ListView.builder(
              itemCount: financials.isEmpty ? 2 : financials.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return getWeekOverviewChart();
                }
                if (financials.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(64),
                    child: Align(
                      child: Text(
                        'There are currently no entries. Add them using the Plus-Button.',
                      ),
                    ),
                  );
                }
                return FinancialWidget(
                  financial: financials[index - 1],
                  onPress: (financial) => onFinancialPressed(financial),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addFinancialDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
