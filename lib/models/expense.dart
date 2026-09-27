class Expense {
  final int id;
  String name;
  double amount;
  String category;
  DateTime date;

  Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}
