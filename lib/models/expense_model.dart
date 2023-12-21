import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  late int key;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double amount;

  Expense({required this.key, required this.title, required this.amount});
}

