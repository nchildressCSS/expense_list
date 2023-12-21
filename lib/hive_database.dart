import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'models/expense_model.dart';

class HiveDatabase {
  static const String _expenseBoxName = 'expenses';

  Future<void> addExpense(Expense expense) async {
    final box = await Hive.openBox<Expense>(_expenseBoxName);

    // Ensure that the key is within the valid range for integer keys
    final validKey = expense.key % 0xFFFFFFFF;

    // Use add method to add the expense with a specific key
    await box.add(expense);
  }


  Future<List<Expense>> getExpenses() async {
    final box = await Hive.openBox<Expense>(_expenseBoxName);
    final expenses = box.values.toList();
    print('Expenses retrieved: $expenses');
    return expenses;
  }

  Future<void> deleteExpense(int id) async {
    final box = await Hive.openBox<Expense>(_expenseBoxName);
    await box.delete(id);
    print('Expense deleted with id: $id');
  }

  Future<void> updateExpense(Expense expense) async {
    final box = await Hive.openBox<Expense>(_expenseBoxName);

    // Ensure that the key is within the valid range for integer keys
    final validKey = expense.key % 0xFFFFFFFF;

    // Use put method to update the expense with a specific key
    await box.put(validKey, expense);
  }



  Future<void> initFlutter() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    Hive.registerAdapter(ExpenseAdapter());
  }
}
