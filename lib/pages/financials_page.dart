import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  final euroFormatter = NumberFormat.simpleCurrency(
    locale: 'de_DE',
    name: 'EUR',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    loadFinancials();
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
    double amount = NumberFormat.decimalPattern(
      'de_DE',
    ).parse(result['amount'] as String).toDouble();
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
                  ? '+${euroFormatter.format(total)}'
                  : euroFormatter.format(total),
              style: TextStyle(
                color: total >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
          Expanded(
            child: financials.isNotEmpty
                ? ListView(
                    children: financials.map((financial) {
                      return FinancialWidget(
                        financial: financial,
                        onPress: (financial) => onFinancialPressed(financial),
                      );
                    }).toList(),
                  )
                : Container(
                    padding: EdgeInsets.all(64),
                    child: Align(
                      child: Text(
                        'There are currently no entries. Add them using the Plus-Button.',
                      ),
                    ),
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
