import 'package:flutter/material.dart';
import 'package:expense_list/models/expense_model.dart';
import 'package:expense_list/hive_database.dart';
import 'package:hive/hive.dart';
import 'add_expense_screen.dart';

class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  static const String _expenseBoxName = 'expenses';

  final HiveDatabase _hiveDatabase = HiveDatabase();
  List<Expense> expenses = [];
  int nextExpenseId = 0;

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

    print('Expenses loaded: $expenses');
  }

  Future<void> _deleteExpense(int? id) async {
    if (id != null) {
      final expenseIndex = expenses.indexWhere((expense) => expense.key == id);
      if (expenseIndex != -1) {
        print('Deleting expense with ID: $id');
        try {
          print('Deleting expense with Hive key: ${expenses[expenseIndex].key}');
          await expenses[expenseIndex].delete();
          print('Expense deleted with id: $id');
          setState(() {
            expenses.removeAt(expenseIndex);
          });
        } catch (e) {
          print('Error deleting expense: $e');
        }
      } else {
        print('Expense not found with ID: $id');
      }
    } else {
      print('Invalid expense ID');
    }
  }


  Future<void> _editExpense(Expense expense) async {
    print('Editing expense: $expense');

    final updatedExpense = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(editingExpense: expense),
      ),
    );

    print('Updated expense from AddExpenseScreen: $updatedExpense');

    if (updatedExpense != null && updatedExpense is Expense) {
      try {
        final index = expenses.indexOf(expense);

        if (index != -1) {
          setState(() {
            // Update the existing expense in the list
            expenses[index] = updatedExpense;
          });

          // Use the original key when updating in Hive
          await _hiveDatabase.updateExpense(updatedExpense);

          print('Expense updated in UI and Hive');
        } else {
          print('Original expense not found in the list');
        }
      } catch (e) {
        print('Error updating expense in Hive or UI: $e');
      }
    }
  }


  Future<List<Expense>> getExpenses() async {
    final box = await Hive.openBox<Expense>(_expenseBoxName);
    return box.values.toList();
  }

  double _calculateTotalCost() {
    return expenses.fold(0.0, (double total, Expense expense) => total + expense.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker",
          style: TextStyle(
            fontFamily: 'BrownFox',
            fontSize: 50.0,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(
                    expense.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${expense.amount} \$',
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editExpense(expense),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          print('Deleting expense with ID: ${expense.key}');
                          _deleteExpense(expense.key);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Expenses: \$${_calculateTotalCost().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  return Colors.green;
                }),
                minimumSize: MaterialStateProperty.all(const Size(300, 40)),
              ),
              child: const Text(
                'Add Expense',
                style: TextStyle(
                  fontFamily: 'BrownFox',
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
