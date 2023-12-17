import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'models/expense_model.dart';

class HiveDatabase {
  static const String _expenseBoxName = 'expenses';

  Future<void> addExpense(Expense expense) async {
    final box = await Hive.openBox<Expense>(_expenseBoxName);
    await box.add(expense);
    print('Expense added: $expense');
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
    await box.put(expense.id, expense);
    print('Expense updated: $expense');
  }

  Future<void> initFlutter() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    Hive.registerAdapter(ExpenseAdapter());
  }
}
