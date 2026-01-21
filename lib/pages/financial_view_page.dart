import 'package:flutter/material.dart';
import 'package:daily_app/models/financial.dart';

class FinancialViewPage extends StatefulWidget {
  final Financial financial;

  const FinancialViewPage({super.key, required this.financial});

  @override
  State<StatefulWidget> createState() {
    return _FinancialViewPageState();
  }
}

class _FinancialViewPageState extends State<FinancialViewPage> {
  late TextEditingController amountController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    amountController = TextEditingController(text: widget.financial.amount.toString());
    descriptionController = TextEditingController(
      text: widget.financial.description,
    );
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(widget.financial.description, style: TextStyle(fontSize: 32)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          setState(() {
            widget.financial.description = descriptionController.text;
          });
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            TextField(controller: descriptionController),
            Text(
              'Amount',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            TextField(controller: amountController),
            Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Delete Financial',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
