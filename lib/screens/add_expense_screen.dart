// add_expense_screen.dart
import 'package:flutter/material.dart';
import '../hive_database.dart';
import '../models/expense_model.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? editingExpense;

  const AddExpenseScreen({Key? key, this.editingExpense}) : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final HiveDatabase _hiveDatabase = HiveDatabase(); // Declare _hiveDatabase here

  @override
  void initState() {
    super.initState();

    if (widget.editingExpense != null) {
      // If editing an existing expense, populate the fields with its data
      _titleController.text = widget.editingExpense!.title;
      _amountController.text = widget.editingExpense!.amount.toString();
    }
  }

  void _addOrUpdateExpense() async {
    final String title = _titleController.text;
    final double amount = double.parse(_amountController.text);
    final DateTime date = DateTime.now();

    final Expense newExpense = Expense(id: widget.editingExpense?.id ?? 0, title: title, amount: amount);

    if (widget.editingExpense != null) {
      // If editing an existing expense, update it
      await _hiveDatabase.updateExpense(newExpense);
    } else {
      // If adding a new expense, add it
      await _hiveDatabase.addExpense(newExpense);
    }

    print('Expense added/updated: $newExpense');

    Navigator.pop(context); // Close the add expense screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editingExpense != null ? 'Edit Expense' : 'Add Expense'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addOrUpdateExpense,
              child: Text(widget.editingExpense != null ? 'Update Expense' : 'Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
