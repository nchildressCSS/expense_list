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
  final HiveDatabase _hiveDatabase = HiveDatabase();

  @override
  void initState() {
    super.initState();

    if (widget.editingExpense != null) {
      _titleController.text = widget.editingExpense!.title;
      _amountController.text = widget.editingExpense!.amount.toString();
    }
  }

  void _saveExpense() async {
    final String title = _titleController.text;
    final double amount = double.parse(_amountController.text);

    if (widget.editingExpense != null) {
      final Expense updatedExpense = Expense(
        key: widget.editingExpense!.key,
        title: title,
        amount: amount,
      );

      await _hiveDatabase.updateExpense(updatedExpense);
      Navigator.pop(context, updatedExpense); // Return the updated expense
    } else {
      final Expense newExpense = Expense(
        key: DateTime.now().millisecondsSinceEpoch, // Ensure a unique key
        title: title,
        amount: amount,
      );
      await _hiveDatabase.addExpense(newExpense);
      Navigator.pop(context, newExpense); // Return the new expense
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editingExpense != null ? 'Edit Expense' : 'Add Expense',
          style: const TextStyle(
            fontFamily: 'BrownFox',
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return Colors.green;
                      },
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(300, 40)),
                  ),
                  child: Text(
                    widget.editingExpense != null
                        ? 'Update Expense'
                        : 'Save Expense',
                    style: const TextStyle(
                      fontFamily: 'BrownFox',
                      fontSize: 30.0,
                    ),
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
