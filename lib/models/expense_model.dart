// expense_model.dart
import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double amount;


  Expense({required this.id, required this.title, required this.amount});
}
