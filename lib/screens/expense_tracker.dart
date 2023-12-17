import 'package:flutter/material.dart';
import 'package:expense_list/models/expense_model.dart';
import 'package:expense_list/hive_database.dart';

import 'add_expense_screen.dart';

class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final HiveDatabase _hiveDatabase = HiveDatabase();
  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final loadedExpenses = await _hiveDatabase.getExpenses();
    setState(() {
      expenses = loadedExpenses;
    });
  }

  Future<void> _deleteExpense(int id) async {
    await _hiveDatabase.deleteExpense(id);
    _loadExpenses();
  }

  Future<void> _editExpense(Expense expense) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(editingExpense: expense),
      ),
    );
    _loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(),
                  ),
                ).then((_) => _loadExpenses());
              },
              child: Text('Add Expense'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text('${expense.amount} \$'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editExpense(expense),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteExpense(expense.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
