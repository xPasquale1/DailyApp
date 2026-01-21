import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:daily_app/models/financial.dart';

class FinancialWidget extends StatefulWidget {
  final Financial financial;
  final Function(Financial) onPress;

  const FinancialWidget({
    super.key,
    required this.financial,
    required this.onPress,
  });

  @override
  State<StatefulWidget> createState() {
    return _TaskViewState();
  }
}

class _TaskViewState extends State<FinancialWidget> {
  final euroFormatter = NumberFormat.simpleCurrency(
    locale: 'de_DE',
    name: 'EUR',
    decimalDigits: 2
  );

  void onPress() {
    widget.onPress(widget.financial);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.financial.description,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Receiver: ${widget.financial.receiver}'),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.financial.amount >= 0 ? '+${euroFormatter.format(widget.financial.amount)}' : euroFormatter.format(widget.financial.amount),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: widget.financial.amount >= 0 ? Colors.green : Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
